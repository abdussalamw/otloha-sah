from django.contrib.auth.models import Permission, Group
from django.contrib.auth.password_validation import validate_password
from django.utils.translation import gettext as _
from rest_framework import serializers
from rest_framework.reverse import reverse

from apps.users.models import Admin, User


class AdminListSerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField()
    roles = serializers.SerializerMethodField()
    permissions = serializers.SerializerMethodField()
    actions = serializers.SerializerMethodField()

    class Meta:
        model = Admin
        fields = (
            'id', 'full_name', 'email', 'is_verified', 'gender', 'image', 'is_superuser', 'roles', 'permissions',
            'actions'
        )

    def get_image(self, obj):
        return self.context['request'].build_absolute_uri(obj.profile_image)

    def get_roles(self, obj):
        return [group.name for group in obj.groups.all()]

    def get_permissions(self, obj):
        return obj.user_permissions.count()

    def get_actions(self, obj):
        request = self.context['request']
        actions = []

        if request.user.pk != obj.pk:
            actions.append({
                'text_action_block': _("Unblock") if obj.is_blocked else _("Block"),
                'url_action_block': reverse('admin-v1:users:actions:toggle-block', args=[
                    'admin', obj.pk, 'block' if not obj.is_blocked else 'unblock',
                ]),
                'text_action_suspend': _("Suspend") if obj.is_active else _("UnSuspend"),
                'url_action_suspend': reverse('admin-v1:users:admins:toggle-suspend', args=[
                    'unsuspend' if not obj.is_active else 'suspend', obj.pk,
                ]),
                'text_action_edit': _('Edit'),
                'url_action_edit': reverse('admin-v1:users:admins:update', args=[obj.pk])
            })

        return actions


class AdminCreateSerializer(serializers.ModelSerializer):
    groups = serializers.PrimaryKeyRelatedField(many=True, queryset=Group.objects.all(), required=False)
    permissions = serializers.PrimaryKeyRelatedField(many=True, queryset=Permission.objects.all(), required=False)
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    confirm_password = serializers.CharField(write_only=True, required=True)

    class Meta:
        model = User
        fields = (
            'id', 'username', 'first_name', 'last_name', 'email', 'phone', 'gender', 'is_superuser',
            'password', 'confirm_password', 'groups', 'permissions'
        )

    def validate(self, data):
        if data['password'] != data['confirm_password']:
            raise serializers.ValidationError({"password": "Password fields didn't match."})
        return data

    def create(self, validated_data):
        groups = validated_data.pop('groups', [])
        permissions = validated_data.pop('permissions', [])
        password = validated_data.pop('password')
        validated_data.pop('confirm_password')

        user = User.objects.create(
            **validated_data,
            is_staff=True,
        )
        user.set_password(password)
        user.save()

        for group in groups:
            user.groups.add(group)

        for permission in permissions:
            user.user_permissions.add(permission)

        return user


class AdminEditSerializer(serializers.ModelSerializer):
    groups = serializers.PrimaryKeyRelatedField(many=True, queryset=Group.objects.all(), required=False)
    permissions = serializers.PrimaryKeyRelatedField(many=True, queryset=Permission.objects.all(), required=False)

    class Meta:
        model = User
        fields = (
            'id', 'username', 'first_name', 'last_name', 'email', 'phone', 'is_superuser',
            'groups', 'permissions'
        )

    def update(self, instance, validated_data):
        groups = validated_data.pop('groups', [])
        permissions = validated_data.pop('permissions', [])

        instance = super().update(instance, validated_data)

        instance.groups.set(groups)
        instance.user_permissions.set(permissions)

        return instance
