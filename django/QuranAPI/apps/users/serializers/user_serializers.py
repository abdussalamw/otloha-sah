from rest_framework import serializers

from apps.users.models import User


class ProfileSerializerResponse(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'gender', 'locale', 'first_name', 'last_name', 'email', 'phone',
                  'email_verified_at', '_order',  'last_login',
                  'user_permissions', 'groups')


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'first_name', 'last_name', 'email', 'phone', 'image']
