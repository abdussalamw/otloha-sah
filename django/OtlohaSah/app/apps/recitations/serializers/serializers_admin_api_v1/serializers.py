from django.utils.translation import gettext as _
from rest_framework import serializers

from apps.recitations import config
from apps.recitations.models import Recitation
from apps.users.models import User
from apps.users_profiles.serializers.serializers import UserListSerializer


class UserWithMinimumInfoListSerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['username', 'image']

    def get_image(self, obj):
        return self.context['request'].build_absolute_uri(obj.profile_image)


class AdminRecitationSerializer(serializers.ModelSerializer):
    owner = UserListSerializer()
    teacher = UserWithMinimumInfoListSerializer()
    result = serializers.SerializerMethodField()

    class Meta:
        model = Recitation
        fields = ['id', 'created_at', 'evaluating', 'evaluated_at', 'owner_rate', 'is_remarkable', 'record', 'verses',
                  'chapter', 'narration', 'name', 'result', 'teacher', 'owner']

    def get_result(self, obj):
        result_map = dict(config.RECITATIONS_RESULT)
        return result_map.get(obj.result, _("Unknown"))


class AdminRecitationDetailsSerializer(serializers.ModelSerializer):
    owner = UserListSerializer()
    teacher = UserWithMinimumInfoListSerializer()
    result = serializers.SerializerMethodField()

    class Meta:
        model = Recitation
        fields = ['id', 'created_at', 'evaluating', 'evaluated_at', 'khatma', 'tajweed_lesson_example',
                  'is_remarkable', 'record', 'verses',
                  'chapter', 'narration', 'name', 'result', 'owner', 'teacher', 'owner_rate', 'owner_review']

    def get_result(self, obj):
        result_map = dict(config.RECITATIONS_RESULT)
        return result_map.get(obj.result, _("Unknown"))
