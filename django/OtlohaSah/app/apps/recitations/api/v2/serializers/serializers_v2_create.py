from django.utils.translation import gettext as _
from rest_framework import serializers

from apps.khatma.models import KhatmaUsers
from apps.recitations import config
from apps.recitations.models import Recitation
from apps.recitations.notifications import RecitationAddedToRemarkableRecitationsNotification
from apps.recitations.notifications import UserRecitationAddedToBoxNotification, \
    UserAssignedYouAsFavoriteTeacherForRecitationNotification, RecitationAddedToGeneralNotification
from apps.records.models import Record
from apps.tajweed.models import TajweedLessonExample
from quran_api_client.models import Verse


class RecitationCreateSerializer(serializers.ModelSerializer):
    target = serializers.ChoiceField(
        write_only=True,
        required=False,
        choices=(('favorite_teacher', _('Favorite Teacher')), ('box', _('Box'))),
    )

    class Meta:
        model = Recitation
        fields = ['id', 'narration', 'chapter', 'verses', 'name', 'record', 'khatma',
                  'tajweed_lesson_example', 'target']
        read_only_fields = ['id']
        extra_kwargs = {
            'narration': {'required': True},
            'chapter': {'required': True},
            'name': {'required': True},
            'record': {'required': True},
        }

    def validate_target(self, target):
        if target == 'favorite_teacher' and not self.context['request'].user.favorite_teacher:
            raise serializers.ValidationError(_("You don't have a favorite teacher."))
        return target

    def validate_verses(self, verses):
        verses_ids = Verse.objects.filter(
            chapter_id=self.initial_data['chapter'],
            narration_id=self.initial_data['narration']).values_list('id', flat=True)
        input_verses_ids = [verse.id for verse in verses]
        if not all(item in verses_ids for item in input_verses_ids):
            raise serializers.ValidationError(_("Verses are not valid for this chapter."))

        current_verses = Recitation.objects.filter(
            narration_id=self.initial_data['narration'],
            chapter_id=self.initial_data['chapter'],
            owner=self.context['request'].user,
        ).values_list('verses', flat=True)

        duplicated_verses = [str(verse.verse_number) for verse in verses if verse.id in current_verses]

        if len(duplicated_verses) != 0:
            raise serializers.ValidationError(
                _("The following verses are already assigned to another recitation {verses}").format(
                    verses=', '.join(duplicated_verses)))

        return verses

    def create(self, validated_data):
        verses = validated_data.pop('verses')
        validated_data['page_number'] = verses[0].page_number
        target = validated_data.pop('target', None)
        owner = self.context['request'].user
        khatma = self.context['request'].data.get('khatma', None)
        tajweed_lesson_example = self.context['request'].data.get('tajweed_lesson_example', None)

        if khatma is not None and tajweed_lesson_example is not None:
            raise serializers.ValidationError(_("Only one of Khatma User and Tajweed Lesson Example can be set."))

        if khatma is not None:
            if not KhatmaUsers.objects.filter(khatma_id=khatma, user=owner).exists():
                raise serializers.ValidationError(_("You are not part of this khatma or khatma does not exist."))

        if tajweed_lesson_example is not None:
            if not TajweedLessonExample.objects.filter(pk=tajweed_lesson_example).exists():
                raise serializers.ValidationError(_("This example does not exist."))

        validated_data['owner'] = owner
        if owner.is_a_teacher:
            validated_data['is_teacher_recitation'] = True

        instance = super().create(validated_data)
        instance.verses.add(*verses)
        if target == 'box':
            instance.show_in_box = True
            instance.notify(UserRecitationAddedToBoxNotification, sender=instance)
        if target == 'favorite_teacher':
            instance.teacher = self.context['request'].user.favorite_teacher
            instance.notify(UserAssignedYouAsFavoriteTeacherForRecitationNotification, sender=instance.owner)
        instance.save()
        return instance


class RecitationTargetSerializer(serializers.ModelSerializer):
    target = serializers.ChoiceField(
        write_only=True,
        required=True,
        choices=(('favorite_teacher', _('Favorite Teacher')), ('box', _('Box')), ('remarkable', _('Remarkable'))),
    )

    class Meta:
        model = Recitation
        fields = ['target']

    def validate(self, data):
        request = self.context['request']
        target = data.get('target')
        recitation = self.instance

        if recitation.owner != request.user:
            raise serializers.ValidationError({"detail": recitation.MESSAGES.get("forbidden")})

        if target == 'favorite_teacher' and not request.user.favorite_teacher:
            raise serializers.ValidationError({"target": "You don't have a favorite teacher."})

        return data

    def update(self, instance, validated_data):
        target = validated_data.get('target')
        request = self.context['request']

        message = ''
        if target == 'box':
            if instance.show_in_box:
                instance.show_in_box = False
                message = instance.MESSAGES.get("removed_from_general")
            else:
                instance.show_in_box = True
                message = instance.MESSAGES.get("added_to_general")
                instance.notify(RecitationAddedToGeneralNotification, sender=instance.owner)

        elif target == 'favorite_teacher':
            if instance.teacher:
                instance.teacher = None
                message = instance.MESSAGES.get("teacher_removed_from_recitation")
            else:
                instance.teacher = request.user.favorite_teacher
                message = instance.MESSAGES.get("favorite_teacher_assigned")
                instance.notify(UserAssignedYouAsFavoriteTeacherForRecitationNotification, sender=instance.owner)

        elif target == 'remarkable':
            if instance.show_in_remarkable:
                instance.show_in_remarkable = False
                message = instance.MESSAGES.get("removed_from_remarkable")
            else:
                instance.show_in_remarkable = True
                message = instance.MESSAGES.get("added_to_remarkable")
                instance.notify(RecitationAddedToRemarkableRecitationsNotification, sender=request.user)

        instance.save()
        return {"recitation": instance, "message": message}


class RecitationUpdateSerializer(serializers.ModelSerializer):
    record = serializers.PrimaryKeyRelatedField(queryset=Record.objects.all())

    class Meta:
        model = Recitation
        fields = ['record']

    def __init__(self, *args, **kwargs):
        self.user = kwargs.pop('user', None)
        super().__init__(*args, **kwargs)

    def validate(self, attrs):
        recitation = self.context.get('pk')
        if recitation.result not in [config.RECITATIONS_RESULT_REJECTED, config.RECITATIONS_RESULT_PENDING]:
            raise serializers.ValidationError(_('You cannot update the recitation while it is being evaluated'))

        record = attrs.get('record')
        if Recitation.objects.filter(record=record).exclude(pk=recitation.pk).exists():
            raise serializers.ValidationError({'record': _('This record is already used in another recitation.')})

        return attrs

    def update(self, instance, validated_data):
        instance.result = config.RECITATIONS_RESULT_PENDING
        instance.evaluated_at = None
        instance.being_evaluated = False
        instance.record = validated_data['record']
        instance.save()
        return instance
