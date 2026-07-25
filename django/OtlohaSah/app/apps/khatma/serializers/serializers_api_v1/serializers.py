from rest_framework import serializers

from apps.invitations import config
from apps.khatma.models import Khatma, KhatmaUsers


class KhatmaSerializer(serializers.ModelSerializer):
    num_students = serializers.IntegerField(read_only=True)
    num_teachers = serializers.IntegerField(read_only=True)

    class Meta:
        model = Khatma
        fields = ['id', 'num_teachers', 'num_students', 'narration', 'from_part', 'to_part']

    def create(self, validated_data):
        user = self.context['request'].user

        if validated_data['from_part'].part_number > validated_data['to_part'].part_number:
            raise serializers.ValidationError(
                {'error': 'Invalid data. Ensure from_part is less than or equal to to_part.'})

        khatma_instance = Khatma.objects.create(created_by=user, active=user.is_a_teacher,
                                                status=config.KHATMA_STATUS_PENDING,
                                                **validated_data)
        KhatmaUsers.objects.create(
            khatma=khatma_instance,
            user=user,
            from_chapter=None,
            to_chapter=None,
            is_teacher=user.is_a_teacher,
            from_verse=None,
            to_verse=None,
        )

        return khatma_instance
