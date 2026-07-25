from django.shortcuts import get_object_or_404
from django.utils.translation import gettext as _
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.generics import ListAPIView, UpdateAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.authz.permissions import AdminPermissionRequired, DynamicPermissionRequiredMixin
from apps.settings.models import Setting
from apps.settings.serializers.serializers_admin_api_v1.serializers import SettingSerializer


class SettingsListAPIView(ListAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    permission_required = ("settings.view_setting",)
    serializer_class = SettingSerializer

    @swagger_auto_schema(
        operation_description="List settings for a specific group.",
        responses={
            200: "A list of settings for the specified group.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user does not have permission to access the settings.",
            404: "Not Found - The specified group does not exist.",
        },
    )
    def get_queryset(self):
        group = self.kwargs.get('group')
        if group:
            return Setting.objects.filter(group=group)
        return Setting.objects.all()


class SettingsDetailAPIView(UpdateAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    permission_required = ("settings.change_setting",)
    serializer_class = SettingSerializer

    @swagger_auto_schema(
        operation_description="Partially update a specific setting by ID.",
        request_body=SettingSerializer,
        responses={
            200: "The partially updated setting instance.",
            204: "No content - The setting was partially updated successfully.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user does not have permission to partially update the setting.",
            404: "Not Found - The specified setting ID does not exist.",
        },
    )
    def get_queryset(self):
        group = self.kwargs.get('group')
        if group:
            return Setting.objects.filter(group=group)
        return Setting.objects.all()

    def get_object(self):
        queryset = self.get_queryset()
        obj = get_object_or_404(queryset, pk=self.kwargs['id'])
        self.check_object_permissions(self.request, obj)
        return obj


class CollectMissingSettingsAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    permission_required = "settings.change_setting"

    @swagger_auto_schema(
        operation_description="Collect missing settings and add them to the database.",
        responses={
            200: "Missing Settings Collected Successfully!",
            401: "Unauthorized - The user is not authenticated.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The requested resource was not found.",
        },
    )
    def post(self, request, *args, **kwargs):
        Setting.objects.collect_missing_settings()
        message = _("Missing Settings Collected Successfully!")
        return Response({"message": message}, status=status.HTTP_200_OK)


class SettingResetAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    permission_required = "settings.change_setting"

    @swagger_auto_schema(
        operation_description="Reset all settings to their default values.",
        responses={
            200: "Settings Reset Successfully!",
            401: "Unauthorized - The user is not authenticated.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The requested resource was not found.",
        },
    )
    def post(self, request):
        Setting.objects.reset()
        return Response({"message": f"Settings reset successfully"}, status=status.HTTP_200_OK)
