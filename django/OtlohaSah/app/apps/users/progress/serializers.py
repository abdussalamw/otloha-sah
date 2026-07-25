from rest_framework import serializers

from apps.users.models import UserProgress, Teacher


class BaseProgressSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProgress
        fields = (
            "narration_id", "accepted_recitations", "rejected_recitations", "pending_recitations",
            "number_of_recitations"
        )


class TeacherProgressSerializer(serializers.ModelSerializer):
    accepted_recitations = serializers.SerializerMethodField()
    rejected_recitations = serializers.SerializerMethodField()
    pending_recitations = serializers.SerializerMethodField()
    number_of_recitations = serializers.SerializerMethodField()

    class Meta:
        model = Teacher
        fields = (
            "narration_id", "accepted_recitations", "rejected_recitations", "pending_recitations",
            "number_of_recitations"
        )

    def get_accepted_recitations(self, obj):
        return obj.recitations_teacher.filter(narration_id=self.context.get('narration_id'), result='accepted').count()

    def get_rejected_recitations(self, obj):
        return obj.recitations_teacher.filter(narration_id=self.context.get('narration_id'), result='rejected').count()

    def get_pending_recitations(self, obj):
        return obj.recitations_teacher.filter(narration_id=self.context.get('narration_id'), result__isnull=True).count()

    def get_number_of_recitations(self, obj):
        return obj.recitations_teacher.filter(narration_id=self.context.get('narration_id')).count()
