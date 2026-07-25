import json
from functools import reduce

from django.contrib.contenttypes.models import ContentType
from django.db.models import Sum, Count
from django.utils.timezone import now
from django.utils.translation import gettext_lazy as _
from rest_framework import serializers

from apps.chat.notifications import RecitationRoomCreatedNotification
from apps.recitation.models import Recitation, Record, RecitationFault
from apps.recitation.notifications import RecitationEvaluatedNotification, TeacherRatedRecitationNotification, \
    MarkedAsRemarkableNotification, RecitationAddedToRemarkableRecitationsNotification, RecitationReportedNotification, \
    RecitationAddedToGeneralNotification
from apps.records.serializers import RecordField
from apps.users.models import TeacherProfile, TeacherRecitationPricing
from apps.users.serializers import UserSerializer
from apps.users.utils import update_user_recitation_progress, merge_json_lists


# class RecordField(serializers.RelatedField):
#     def to_representation(self, value):
#         return BaseRecordSerializer(instance=value).data
#
#     def to_internal_value(self, data):
#         if not len(data):
#             raise serializers.ValidationError(_('Record is required'))
#         if not isinstance(data, UploadedFile):
#             raise serializers.ValidationError(_("The uploaded file is not valid."))
#
#         try:
#             MutagenFile(data).info
#         except Exception as e:
#             raise serializers.ValidationError(_("The uploaded file is not valid."))
#         return data


class BaseRecitationSerializer(serializers.ModelSerializer):
    records = RecordField(queryset=Record.objects.all(), many=True, required=True)
    owner = UserSerializer(read_only=True)
    teacher = UserSerializer(read_only=True)
    room = serializers.UUIDField(source='room__uuid', read_only=True)
    send_to_favorite_teacher = serializers.BooleanField(write_only=True, required=True)

    class Meta:
        model = Recitation
        fields = (
            'id', 'name', 'narration_id', 'verse_ids', 'chapter_id', 'records', 'owner', 'teacher',
            'gender', 'is_child', 'is_teacher_recitation', 'updated_at', 'created_at', 'teacher_rate', 'owner_rate',
            'result', 'archived_at', 'is_remarkable', 'conversation_started', 'being_evaluated',
            'evaluated_at', 'is_closed', 'closed_at', 'show_in_general', 'show_in_remarkable', 'room',
            'send_to_favorite_teacher')
        read_only_fields = ()

    def validate_send_to_favorite_teacher(self, data):
        if data and not self.context['user'].favorite_teacher:
            raise serializers.ValidationError("You don't have a favorite teacher")
        return data

    def check_progress(self, attrs):
        verse_ids = json.loads(attrs['verse_ids'])

        recitations_verses = Recitation.objects.filter(
            narration_id=attrs['narration_id'],
            chapter_id=attrs['chapter_id'],
            owner=self.context['user']
        ).values_list('verse_ids', flat=True)

        verses = reduce(merge_json_lists, recitations_verses, [])

        duplicated_verses = []
        if len(verses) != 0:
            duplicated_verses = [str(verse_id) for verse_id in verse_ids if verse_id in verses]

        if len(duplicated_verses) > 0:
            return False, duplicated_verses
        return True, None

    def validate(self, attrs):
        if 'name' not in attrs or not attrs['name']:
            raise serializers.ValidationError(_('Name is required'))

        if 'verse_ids' not in attrs or not attrs['verse_ids']:
            raise serializers.ValidationError(_('Verses are required'))

        if 'chapter_id' not in attrs or not attrs['chapter_id']:
            raise serializers.ValidationError(_('Chapter is required'))

        if 'narration_id' not in attrs or not attrs['narration_id']:
            raise serializers.ValidationError(_('Narration is required'))

        success, duplicated_verses = self.check_progress(attrs)
        if not success:
            raise serializers.ValidationError(
                _('Verses "{}" are already submitted before').format(', '.join(duplicated_verses)))

        return attrs

    def create(self, validated_data):
        records = validated_data.pop('records')
        send_to_favorite_teacher = validated_data.pop('send_to_favorite_teacher')
        validated_data['owner'] = self.context['user']
        validated_data['is_teacher_recitation'] = self.context['user'].is_a_teacher
        validated_data['gender'] = self.context['user'].gender
        validated_data['is_child'] = self.context['user'].get_age <= 12
        instance = super(BaseRecitationSerializer, self).create(validated_data)

        update_user_recitation_progress(
            user_id=instance.owner_id,
            narration_id=instance.narration_id,
            chapter_id=instance.chapter_id)

        if not self.context["user"].is_a_teacher:
            if send_to_favorite_teacher:
                instance.teacher_assigned_at = now()
                instance.save()
                from apps.chat.serializers import RecitationRoomSerializer
                room = RecitationRoomSerializer(room_type='recitation', data={
                    "recitation": instance.id,
                    "users": [self.context['user'].favorite_teacher_id]
                }, context={'user': self.context['user']})
                if room.is_valid():
                    room.save()

                room.instance.notify(
                    RecitationRoomCreatedNotification,
                    sender=self.context["user"],
                    receivers=room.instance.peers(self.context["user"])
                )
            else:
                instance.show_in_general = True
                instance.save()

        if not send_to_favorite_teacher:
            instance.notify(RecitationAddedToGeneralNotification, sender=instance.owner)

        for record in records:
            record.content_object = instance
            record.save()

            # record_serializer = BaseRecordSerializer(data={
            #     "record": record,
            #     "content_type": ContentType.objects.get_for_model(instance).pk,
            #     "object_id": instance.id
            # })
            #
            # if record_serializer.is_valid():
            #     record_serializer.save()

        return instance


class UpdateRecitationSerializer(serializers.ModelSerializer):
    records = serializers.PrimaryKeyRelatedField(many=True, queryset=Record.objects.all())

    class Meta:
        model = Recitation
        fields = ('records',)

    def update(self, instance, validated_data):
        instance.result = None
        instance.evaluated_at = None
        instance.being_evaluated = False
        instance.save()
        for record in validated_data['records']:
            instance.records.add(record)
        return instance


# TODO Remove this serializer and use BaseRecitationSerializer
class RecitationGeneralBoxSerializer(BaseRecitationSerializer):
    can_create_message = serializers.SerializerMethodField(read_only=True)

    class Meta(BaseRecitationSerializer.Meta):
        fields = BaseRecitationSerializer.Meta.fields + ('can_create_message',)
        read_only_fields = BaseRecitationSerializer.Meta.read_only_fields + ('can_create_message',)

    def get_can_create_message(self, obj):
        user = self.context['user']
        user_narrations = user.narration_id.split(',')
        return user.is_a_teacher and user.narration_id and obj.narration_id in user_narrations and \
            not obj.being_evaluated or user.is_superuser


class RecitationRateSerializer(serializers.ModelSerializer):
    owner_rate = serializers.FloatField(required=True, min_value=0.5)

    class Meta:
        model = Recitation
        fields = ("owner_rate", "owner_review")

    def __init__(self, *args, **kwargs):
        self.user = kwargs.pop('user')
        super(RecitationRateSerializer, self).__init__(*args, **kwargs)

    def validate(self, attrs):
        if self.user != self.instance.owner:
            raise serializers.ValidationError(_("you are not authorized to preform this action"))
        if not self.instance.is_closed:
            raise serializers.ValidationError(_("Discussion is not ended yet!"))

        if float(self.instance.owner_rate) > 0:
            raise serializers.ValidationError(_("You have already rated this conversation!"))

        return attrs

    def update(self, instance, validated_data):
        instance = super(RecitationRateSerializer, self).update(instance, validated_data)

        teacher_rate = Recitation.objects.filter(
            evaluated_at__isnull=False,
            result=Recitation.RESULT_ACCEPTED,
            is_closed=True,
            teacher=instance.teacher,
            owner_rate__gt=0.0).values(
            'owner_rate').aggregate(
            total_rate=Sum('owner_rate') / Count('owner_rate'))['total_rate']

        instance.teacher.update_user_rate_and_level(teacher_rate)
        return instance


class EvaluateRecitationSerializer(serializers.ModelSerializer):
    result = serializers.CharField(required=True)
    teacher_rate = serializers.FloatField(required=False, min_value=0.5)

    class Meta:
        model = Recitation
        fields = ('teacher_rate', 'is_remarkable', 'result')

    def __init__(self, *args, **kwargs):
        self.user = kwargs.pop('user')
        super(EvaluateRecitationSerializer, self).__init__(*args, **kwargs)

    def validate(self, attrs):
        if self.instance.evaluated_at or self.instance.teacher != self.user:
            raise serializers.ValidationError(_("you are not authorized to preform this action"))

        if attrs['result'] == Recitation.RESULT_ACCEPTED:
            if 'teacher_rate' not in attrs:
                raise serializers.ValidationError(_('rate is required'))

            if attrs['teacher_rate'] < 0 or attrs['teacher_rate'] > 5:
                raise serializers.ValidationError(_('rate value must be between 0 and 5'))

        elif attrs['result'] in [Recitation.RESULT_REJECTED, Recitation.RESULT_REPORTED]:
            if 'is_remarkable' in attrs and attrs['is_remarkable']:
                raise serializers.ValidationError(
                    _('you can not set recitation as remarkable if it is {}').format(attrs['result']))

            if 'teacher_rate' in attrs and attrs['teacher_rate']:
                raise serializers.ValidationError(
                    _('you can not set recitation rate if it is {}').format(attrs['result']))

        return attrs

    def update(self, instance, validated_data):
        instance.conversation_started = True
        instance.evaluated_at = now()
        instance.result = validated_data['result']
        if validated_data['result'] in [Recitation.RESULT_REJECTED, Recitation.RESULT_REPORTED]:
            instance.is_closed = True
            instance.closed_at = now()

        if instance.teacher.teacherprofile.teacher_type == TeacherProfile.TEACHER_TYPE_PAID \
                and validated_data['result'] == 'accepted':
            TeacherRecitationPricing.objects.create(
                teacher=instance.teacher,
                recitation=instance.id,
                recitation_name=instance.name,
            )

        if 'teacher_rate' in validated_data:
            instance.teacher_rate = validated_data['teacher_rate']
        if 'is_remarkable' in validated_data:
            instance.is_remarkable = validated_data['is_remarkable']
        instance.save()

        owner_rate = Recitation.objects.filter(
            evaluated_at__isnull=False,
            result=Recitation.RESULT_ACCEPTED,
            owner=self.instance.owner,
            teacher_rate__gt=0.0).values(
            'teacher_rate').aggregate(
            total_rate=Sum('teacher_rate') / Count('teacher_rate'))['total_rate']

        self.instance.owner.update_user_rate_and_level(owner_rate)

        self.notify()
        update_user_recitation_progress(
            user_id=instance.owner_id,
            narration_id=instance.narration_id,
            chapter_id=instance.chapter_id)
        return instance

    def notify(self):
        content_type = ContentType.objects.get_for_model(Recitation)
        messages = self.user.messages.filter(room__object_id=self.instance.id, room__content_type=content_type)
        messages.update(is_sent=True, sent_at=now())

        if self.instance.result != Recitation.RESULT_REPORTED:
            self.instance.notify(
                RecitationEvaluatedNotification,
                sender=self.instance.teacher,
                receivers=self.instance.owner
            )
            self.instance.notify(TeacherRatedRecitationNotification)
            if self.instance.is_remarkable:
                self.instance.notify(MarkedAsRemarkableNotification)
                if self.instance.show_in_remarkable:
                    self.instance.notify(RecitationAddedToRemarkableRecitationsNotification)
        else:
            self.instance.notify(RecitationReportedNotification)


class RecitationFaultSerializer(serializers.ModelSerializer):
    class Meta:
        model = RecitationFault
        fields = ('id', 'fault_type', 'error_text', 'position_from', 'position_to',)
