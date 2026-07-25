from rest_framework import serializers

from apps.settings.models import UserSetting
from apps.settings.utils import cast_value_to_value_type


class SettingValueField(serializers.Field):
    def get_attribute(self, instance):
        return instance

    def to_representation(self, instance):
        return cast_value_to_value_type(instance.value, instance.value_type)

    def to_internal_value(self, data):
        return data


class BaseUserSettingsSerializer(serializers.ModelSerializer):
    value = SettingValueField()

    class Meta:
        model = UserSetting
        fields = ("key", "label", "description", "value", 'value_type', 'group', 'subgroup')
        read_only_fields = (
            "key", "label", "description", 'value_type', 'group'
        )
