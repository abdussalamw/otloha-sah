from rest_framework import serializers
from django.contrib.auth.models import Group, Permission
from rest_framework import serializers

from apps.authz.models import PermissionRequest


class GroupSerializer(serializers.ModelSerializer):
    total_users = serializers.IntegerField(read_only=True)

    class Meta:
        model = Group
        fields = ['id', 'name', 'total_users']


class GroupCreateUpdateSerializer(serializers.ModelSerializer):
    permissions = serializers.PrimaryKeyRelatedField(queryset=Permission.objects.all(), many=True)

    class Meta:
        model = Group
        fields = ['id', 'name', 'permissions']


class PermissionRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = PermissionRequest
        fields = ['id', 'user', 'permission', 'requested_at', 'approved_by']
        read_only_fields = ['id', 'user', 'requested_at', 'approved_by']
