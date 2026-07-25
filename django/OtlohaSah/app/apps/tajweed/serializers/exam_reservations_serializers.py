from django.db.models import Q
from django.utils.translation import gettext as _
from rest_framework import serializers

from apps.tajweed import config
from apps.tajweed.models import TajweedLevel
from apps.tajweed.models.calendar import CalendarSlot
from apps.tajweed.models.exams import ExamReservation
from apps.tajweed.notifications import ApproveReservationNotification, RejectReservationNotification
from apps.tajweed.serializers.serializers import CalendarSlotSerializer
from apps.tajweed.serializers.serializers_levels import LevelSerializer


class LevelField(serializers.Field):
    def to_representation(self, value):
        return LevelSerializer(instance=value).data

    def to_internal_value(self, data):
        try:
            return TajweedLevel.objects.get(id=data)
        except TajweedLevel.DoesNotExist:
            raise serializers.ValidationError(_('Cannot found this level'))


class ExamReservationSerializer(serializers.ModelSerializer):
    calendar_slot = CalendarSlotSerializer(read_only=True)
    level = LevelField()

    class Meta:
        model = ExamReservation
        fields = ['id', 'exam_type', 'status', 'calendar_slot', 'meeting_link', 'notes', 'level']

    def validate(self, attrs):
        calendar_slot_id = self.context['kwargs']['pk']
        calendar_slot = CalendarSlot.objects.get(id=calendar_slot_id)

        if calendar_slot.available_slots - (calendar_slot.reserved_slots or 0) <= 0:
            raise serializers.ValidationError({"error": [_("Slot is not available or already reserved.")]})

        existing_reservation = ExamReservation.objects.filter(
            user=self.context['request'].user,
            exam_type=attrs['exam_type'],
            status=config.STATUS_PENDING,
        ).first()

        if existing_reservation:
            raise serializers.ValidationError({"error": [_("You have open exam request")]})

        existing_reservation = ExamReservation.objects.filter(
            Q(status=config.STATUS_PENDING) | Q(status=config.STATUS_ACCEPTED),
            user=self.context['request'].user,
            calendar_slot=self.context['kwargs']['pk'],
        ).first()

        if existing_reservation:
            raise serializers.ValidationError({"error": [_("You have reserved slot")]})

        return attrs

    def create(self, validated_data):
        instance = super().create({**validated_data,
                                   'calendar_slot_id': self.context['kwargs']['pk'],
                                   'user': self.context['request'].user})

        if self.is_valid():
            calendar_slot_id = self.context['kwargs']['pk']
            calendar_slot = CalendarSlot.objects.get(id=calendar_slot_id)
            calendar_slot.reserved_slots += 1
            calendar_slot.save()

        return instance


class ExamReservationAdminSerializer(serializers.ModelSerializer):
    class Meta:
        model = ExamReservation
        fields = ['id', 'exam_type', 'status', 'calendar_slot', 'meeting_link', 'notes', 'level']
        read_only_fields = ['id', 'user', 'exam_type', 'calendar_slot', 'level']

    def save(self, **kwargs):
        instance = super().save(**kwargs)
        status = self.validated_data.get('status')

        if status == 'approved':
            instance.notify(ApproveReservationNotification, receivers=instance.user,
                            sender=self.context['request'].user)
        elif status == 'rejected':
            instance.notify(RejectReservationNotification, receivers=instance.user,
                            sender=self.context['request'].user)
        return instance


class ExamReservationUserSerializer(serializers.ModelSerializer):
    calendar_slot = CalendarSlotSerializer(read_only=True)
    level = LevelSerializer(read_only=True)

    class Meta:
        model = ExamReservation
        fields = ['id', 'exam_type', 'status', 'calendar_slot', 'meeting_link', 'notes', 'level']
