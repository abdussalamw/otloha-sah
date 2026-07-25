from rest_framework import serializers

from apps.users.models import Teacher


class TeacherReportListSerializer(serializers.ModelSerializer):
    teacher_accounting = serializers.SerializerMethodField()

    class Meta:
        model = Teacher
        fields = (
            'id', 'full_name', 'teacher_accounting',
        )

    def get_teacher_accounting(self, obj):
        return {
            'total_earnings': round(obj.total_earnings, 2) if obj.total_earnings is not None else 0.00,
            'total_dues': round(obj.total_dues, 2) if obj.total_dues is not None else 0.00,
            'paid_recitation_count': obj.paid_recitation_count if obj.paid_recitation_count is not None else 0.00,
            'unpaid_recitation_count': obj.unpaid_recitation_count if obj.unpaid_recitation_count is not None else 0.00,
        }