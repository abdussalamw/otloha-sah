from django.shortcuts import get_object_or_404
from django.utils.translation import gettext_lazy as _
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.ads.models import Ad
from apps.authz.permissions import AdminPermissionRequired, DynamicPermissionRequiredMixin


class DeleteAdAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    permission_required = 'ads.delete_ad'

    @swagger_auto_schema(
        operation_description="Delete ad by ID.",
        responses={
            200: "Ad Deleted Successfully.",
            401: "Unauthorized - The user is not authenticated.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The requested resource was not found.",
        }
    )
    def post(self, request, pk, *args, **kwargs):
        ad = get_object_or_404(Ad, pk=pk)
        ad.delete()
        return Response({"message": _("Ad Deleted Successfully")}, status=status.HTTP_200_OK)


class ToggleActionAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    permission_required = 'ads.change_ad'

    @swagger_auto_schema(
        operation_description="Toggle the active status of an ad.",
        responses={
            200: "Success Toggle Action",
            401: "Unauthorized - The user is not authenticated.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The requested resource was not found.",
        }
    )
    def post(self, request, action, *args, **kwargs):
        ad = get_object_or_404(Ad, pk=kwargs['pk'])
        ad.is_active = action == 'unsuspend'
        ad.save()
        message = f"user have been {'Unsuspend' if ad.is_active else 'Suspend'} successfully"
        return Response({"message": message}, status=status.HTTP_200_OK)
