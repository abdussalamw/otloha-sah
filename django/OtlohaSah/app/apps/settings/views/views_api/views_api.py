from rest_framework import status
from rest_framework.decorators import action
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.viewsets import ViewSet

from apps.settings.models import UserSetting
from apps.settings.serializers.serializers_api.serializers import BaseUserSettingsSerializer


class UserSettingsViewSet(ViewSet):
    permission_classes = [IsAuthenticated]
    lookup_field = 'key'

    def list(self, request, settings_group):
        user_settings = request.user.settings.filter(group=settings_group)
        serializer = BaseUserSettingsSerializer(user_settings, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['post'])
    def reset(self, request, settings_group):
        UserSetting.objects.reset(group=settings_group, user=request.user)
        return Response({"message": "Settings reset successfully"})

    def update(self, request, settings_group, key):
        instance = request.user.settings.get(key=key)
        serializer = BaseUserSettingsSerializer(data=request.data, instance=instance)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)
