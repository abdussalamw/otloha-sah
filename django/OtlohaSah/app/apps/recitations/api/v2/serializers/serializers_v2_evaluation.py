from django.utils.timezone import now
from django.utils.translation import gettext as _
from rest_framework import serializers

# from apps.chat.serializers import BaseRoomSerializer
from apps.recitations import config
from apps.recitations.models import Evaluation, Recitation
from apps.settings.utils import get_setting
from apps.users.models import TeacherProfile, TeacherRecitationPricing


class EvaluationSerializer(serializers.ModelSerializer):
    fault_type = serializers.ChoiceField(choices=config.FAULT_TYPES, required=False, write_only=True)
    error_text = serializers.CharField(required=False, write_only=True)
    position_from = serializers.IntegerField(required=False, write_only=True)
    position_to = serializers.IntegerField(required=False, write_only=True)
    note = serializers.CharField(required=False)

    class Meta:
        model = Evaluation
        fields = ['id', 'note', 'record', 'fault_type', 'error_text',
                  'position_from', 'position_to', 'is_fault'
                  ]

    def __init__(self, *args, **kwargs):
        self.user = kwargs.pop('user', None)
        super().__init__(*args, **kwargs)

    def validate(self, attrs):
        user = self.user or self.context.get('user')
        recitation = self.context.get('recitation')

        if not recitation:
            raise serializers.ValidationError(_("Recitation is required."))

        if user != recitation.teacher:
            raise serializers.ValidationError(_("You are not authorized to perform this action"))

        if self.instance:
            if recitation.is_closed:
                raise serializers.ValidationError(_("Recitation is closed."))

            if attrs.get('result') == config.RECITATIONS_RESULT_REJECTED and attrs.get('is_remarkable'):
                raise serializers.ValidationError(_("A rejected recitation cannot be marked as remarkable."))

        elif attrs.get('error_text') and not attrs.get('fault_type'):
            raise serializers.ValidationError(_('Fault type is required if error text is provided.'))

        return attrs

    def create(self, validated_data):
        fault_data = {
            "fault_type": validated_data.get('fault_type'),
            "record": validated_data.get('record'),
            "note": validated_data.get('note'),
            "recitation": self.context['recitation']
        }

        if 'error_text' in validated_data:
            fault_data['error_text'] = validated_data.get('error_text')
            fault_data['is_fault'] = True
        if 'position_from' in validated_data:
            fault_data['position_from'] = validated_data.get('position_from')
        if 'position_to' in validated_data:
            fault_data['position_to'] = validated_data.get('position_to')

        return Evaluation.objects.create(**fault_data)


class FinishEvaluationSerializer(serializers.ModelSerializer):
    result = serializers.ChoiceField(choices=config.RECITATIONS_RESULT, required=True)
    teacher_rate = serializers.FloatField(required=False, min_value=0.5, max_value=5)
    is_remarkable = serializers.BooleanField(required=False, default=False)

    class Meta:
        model = Evaluation
        fields = ['result', 'teacher_rate', 'is_remarkable']

    def validate(self, attrs):
        recitation = self.context.get('recitation')

        if recitation and recitation.evaluating:
            raise serializers.ValidationError(_("This recitation already evaluated"))
        elif recitation and recitation.teacher != self.context.get('user'):
            raise serializers.ValidationError(_("you are not authorized to perform this action"))

        if attrs['result'] == config.RECITATIONS_RESULT_ACCEPTED:

            if 'is_remarkable' in attrs and attrs['is_remarkable']:
                recitation.is_remarkable = attrs['is_remarkable']

            if 'teacher_rate' not in attrs:
                raise serializers.ValidationError(_('Rate is required when the recitation is accepted.'))

        elif attrs['result'] == config.RECITATIONS_RESULT_REJECTED:

            if 'is_remarkable' in attrs and attrs['is_remarkable']:
                raise serializers.ValidationError(_('A rejected recitation cannot be marked as remarkable.'))

            recitation.is_closed = True
            recitation.closed_at = now()
            if 'teacher_rate' in attrs and attrs['teacher_rate']:
                raise serializers.ValidationError(
                    _('You cannot set recitation rate if it is {}').format(config.RECITATIONS_RESULT_REJECTED))
        return attrs


class RecitationRateSerializer(serializers.ModelSerializer):
    owner_rate = serializers.FloatField(required=True, min_value=0.5)

    class Meta:
        model = Recitation
        fields = ("owner_rate", "owner_review")

    def __init__(self, *args, **kwargs):
        self.user = kwargs.pop('user')
        super().__init__(*args, **kwargs)

    def validate(self, attrs):
        if self.user != self.instance.owner:
            raise serializers.ValidationError(_("You are not authorized to perform this action"))
        if not self.instance.is_closed:
            raise serializers.ValidationError(_("Recitation is not ended yet!"))

        if float(self.instance.owner_rate) > 0:
            raise serializers.ValidationError(_("You have already rated this recitation!"))

        return attrs


class RecitationAssignSerializer(serializers.ModelSerializer):
    class Meta:
        model = Recitation
        fields = ['id']

    def validate(self, attrs):
        recitation = self.context['recitation']
        user = self.context['user']

        if recitation.is_closed or recitation.evaluating:
            raise serializers.ValidationError(_("This recitation is {message}!").format(
                message=_('Closed') if recitation.is_closed else _("being evaluated")
            ))

        if user.is_a_teacher:
            if recitation.teacher and recitation.teacher != user:
                raise serializers.ValidationError(
                    _("This recitation is already assigned to another teacher!")
                )

            teacher_recitations_today_count = Recitation.objects.filter(
                teacher=user,
                created_at__date=now().date()
            ).count()

            general_box_daily_maximum = get_setting(
                'daily_max_number_of_recitations_a_teacher_can_pull_from_general_box'
            )
            if teacher_recitations_today_count >= general_box_daily_maximum:
                raise serializers.ValidationError(
                    _("You have exceeded the maximum number of recitations you can pull today"))

        return attrs

    def update(self, instance, validated_data):
        user = self.context['user']
        instance.teacher = user
        instance.evaluating = True
        instance.save()

        if instance.teacher.teacherprofile.teacher_type == TeacherProfile.TEACHER_TYPE_PAID:
            TeacherRecitationPricing.objects.create(
                teacher=instance.teacher,
                recitation=instance.id,
                recitation_name=instance.name,
            )
        return instance
