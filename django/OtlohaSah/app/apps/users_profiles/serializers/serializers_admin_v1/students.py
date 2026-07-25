from django.db.models import Count
from django.db.models import When, Case
from django.utils.translation import gettext as _
from rest_framework import serializers
from rest_framework.reverse import reverse

from apps.recitations import config
from apps.recitations.models import Recitation
from apps.recitations.models.report import UserRecitationReport
from apps.users.models import Student


class StudentListSerializer(serializers.ModelSerializer):
    recitations_statistics = serializers.SerializerMethodField()
    actions = serializers.SerializerMethodField()
    teacher = serializers.SerializerMethodField()
    level = serializers.SerializerMethodField()
    image = serializers.SerializerMethodField()

    class Meta:
        model = Student
        fields = (
            'id', 'full_name', 'email', 'is_verified', 'rate', 'level',
            'recitations_statistics', 'actions', 'teacher', 'is_blocked',
            'gender', 'image', 'narration_id'
        )

    def get_image(self, obj):
        return self.context['request'].build_absolute_uri(obj.profile_image)

    def get_teacher(self, obj):
        if obj.favorite_teacher:
            teacher_image = obj.favorite_teacher.image
            image_url = self.context['request'].build_absolute_uri(
                teacher_image.url) if teacher_image and teacher_image.name else None
            return {
                'id': obj.favorite_teacher_id,
                'full_name': obj.favorite_teacher.full_name,
                'image': image_url,
            }

    def get_level(self, obj):
        return {
            'text': obj.get_level,
            'value': obj.level
        }

    def get_recitations_statistics(self, obj):
        return {
            'total_recitations': obj.total_recitations,
            'accepted_recitations': obj.accepted_recitations,
            'rejected_recitations': obj.rejected_recitations,
            'reported_recitations': obj.reported_recitations,
            'pending_recitations': obj.pending_recitations,
        }

    def get_actions(self, obj):
        actions = []
        if not obj.is_blocked:
            actions.append({
                'text': _("Block"),
                'url': reverse('api-admin-v1:users:actions:toggle-teacher-action', args=['student', obj.pk, 'block']),
            })

        return actions


class RecitationProgressSerializer(serializers.Serializer):
    accepted = serializers.IntegerField()
    rejected = serializers.IntegerField()
    pending = serializers.IntegerField()
    reported = serializers.IntegerField()
    percentage = serializers.FloatField()

    @staticmethod
    def get_progress_data(student, narration_id):
        recitations = Recitation.objects.filter(owner=student, narration_id=narration_id)

        aggregated_data = recitations.aggregate(
            accepted=Count(Case(When(result=config.RECITATIONS_RESULT_ACCEPTED, then=1))),
            rejected=Count(Case(When(result=config.RECITATIONS_RESULT_REJECTED, then=1))),
            pending=Count(Case(When(result=config.RECITATIONS_RESULT_PENDING, then=1)))
        )

        reported_count = UserRecitationReport.objects.filter(
            recitation__in=recitations
        ).values('recitation').distinct().count()

        accepted_percentage = (aggregated_data['accepted'] / 6236) * 100

        return {
            'accepted': aggregated_data['accepted'],
            'rejected': aggregated_data['rejected'],
            'pending': aggregated_data['pending'],
            'reported': reported_count,
            'percentage': accepted_percentage,
        }
