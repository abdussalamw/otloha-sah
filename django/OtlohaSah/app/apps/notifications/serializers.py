from rest_framework import serializers
from rest_framework.reverse import reverse

from apps.users.serializers import BaseUserSerializer
from .models import Notification


class SenderSerializer(BaseUserSerializer):
    # profile_url = serializers.SerializerMethodField()

    class Meta(BaseUserSerializer.Meta):
        fields = BaseUserSerializer.Meta.fields
                 # + ('profile_url',)

    def __init__(self, *args, **kwargs):
        self.admin = kwargs.pop('admin', False)
        super(SenderSerializer, self).__init__(*args, **kwargs)

    # def get_profile_url(self, obj):
    #     return obj.get_details_url if self.admin else obj.get_absolute_url
        # return reverse("admin:users:details", args=[obj.id])


class StringSenderSerializer(SenderSerializer):
    id = serializers.CharField()
    level = serializers.CharField()
    rate = serializers.CharField()
    favorite_teacher = serializers.CharField()
    narration_id = serializers.CharField()


class BaseNotificationSerializer(serializers.ModelSerializer):
    sender = BaseUserSerializer()
    created_at = serializers.SerializerMethodField()
    content_type = serializers.SerializerMethodField()

    class Meta:
        model = Notification
        fields = (
            'id', 'text', 'sender', 'content_type', 'object_id', 'created_at', 'is_seen', 'target_type', 'target_name',
            'is_read', 'template_name')

    def get_created_at(self, obj):
        from django.utils.timesince import timesince
        return timesince(obj.created_at)

    def get_content_type(self, obj):
        return obj.content_type.model


class PushNotificationNotificationSerializer(BaseNotificationSerializer):
    id = serializers.CharField()
    object_id = serializers.CharField()
    sender = StringSenderSerializer()


class SiteNotificationSerializer(BaseNotificationSerializer):
    sender = serializers.SerializerMethodField()
    target_url = serializers.SerializerMethodField()

    class Meta(BaseNotificationSerializer.Meta):
        fields = BaseNotificationSerializer.Meta.fields + (
            'target_url',
        )

    def __init__(self, *args, **kwargs):
        self.admin = kwargs.pop('admin', False)
        super(SiteNotificationSerializer, self).__init__(*args, **kwargs)

    def get_sender(self, obj):
        return SenderSerializer(obj.sender, admin=self.admin).data

    def get_details_target_url(self, obj):
        path = '#'
        if self.admin and hasattr(obj.content_object, 'get_details_url'):
            path = obj.content_object.get_details_url
        elif not self.admin and hasattr(obj.content_object, 'get_absolute_url'):
            path = obj.content_object.get_absolute_url
        return path

    def get_listing_target_url(self, obj):
        path = '#'
        if self.admin and hasattr(obj.content_object, 'get_admin_listing_url'):
            path = obj.content_object.get_admin_listing_url
        elif not self.admin and hasattr(obj.content_object, 'get_site_listing_url'):
            path = obj.content_object.get_site_listing_url
        return path

    def get_target_url(self, obj):
        if obj.target_type == Notification.TARGET_TYPE_DETAILS:
            return self.get_details_target_url(obj)
        elif obj.target_type == Notification.TARGET_TYPE_LISTING:
            return self.get_listing_target_url(obj)
        return "#"
