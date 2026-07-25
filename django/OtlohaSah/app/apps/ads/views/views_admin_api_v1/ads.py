from django.shortcuts import get_object_or_404
from django.utils.translation import gettext_lazy as _
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.generics import ListAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.ads.models import Ad
from apps.ads.serializers.serializers_admin_api_v1 import CreateOrUpdateAdSerializer, ListAdSerializer
from apps.authz.permissions import DynamicPermissionRequiredMixin, AdminPermissionRequired


class AdsListAPIView(ListAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    queryset = Ad.objects.all()
    serializer_class = ListAdSerializer
    permission_required = "ads.view_ad"

    @swagger_auto_schema(
        operation_description="Retrieve a list of ads.",
        responses={
            200: "Successful retrieval of ads list.",
            401: "Unauthorized - The user is not authenticated.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The requested resource was not found.",
        },
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)


class CreateOrUpdateAdAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    serializer_class = CreateOrUpdateAdSerializer

    @swagger_auto_schema(
        operation_description="Create or update an ad.",
        request_body=openapi.Schema(
            type=openapi.TYPE_OBJECT,
            properties={
                'title': openapi.Schema(type=openapi.TYPE_STRING),
                'url': openapi.Schema(type=openapi.TYPE_STRING),
                'image': openapi.Schema(type=openapi.TYPE_FILE),
                'is_active': openapi.Schema(type=openapi.TYPE_BOOLEAN)
            },
        ),
        responses={
            200: "Successfully created or updated the ad.",
            400: "Bad Request - Invalid input or missing required fields.",
            401: "Unauthorized - The user is not authenticated.",
            403: "Forbidden - The user does not have permission.",
        },
    )
    def post(self, request, pk=None, *args, **kwargs):
        if pk is not None:
            instance = get_object_or_404(Ad, pk=pk)
            serializer = self.serializer_class(instance, data=request.data)
            message = _("Ad Updated Successfully")
        else:
            serializer = self.serializer_class(data=request.data)
            message = _("Ad Created Successfully")

        if serializer.is_valid():
            serializer.save()
            return Response({"message": message}, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
