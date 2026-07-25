from django.shortcuts import get_object_or_404
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.generics import ListAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.authz.permissions import AdminPermissionRequired, DynamicPermissionRequiredMixin
from apps.users.models import Admin
from apps.users_profiles.serializers.serializers_admin_v1.admins import AdminListSerializer, AdminCreateSerializer, \
    AdminEditSerializer


class AdminsListAPIView(ListAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["users.view_admin"]
    serializer_class = AdminListSerializer
    model = Admin

    def get_required_permissions(self, request):
        if request.method == 'GET':
            return ["users.view_admin"]
        return super().get_required_permissions(request)

    @swagger_auto_schema(
        operation_description="List all admins.",
        responses={
            200: "Successful response with a list of Admins.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view students",
            404: "Not Found - admins do not exist",
        },
    )
    def get_queryset(self):
        return Admin.objects.all()

    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)


class AdminCreateAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["users.add_admin"]

    @swagger_auto_schema(
        operation_description="Create an admin.",
        request_body=openapi.Schema(
            type=openapi.TYPE_OBJECT,
            properties={
                'username': openapi.Schema(type=openapi.TYPE_STRING),
                'first_name': openapi.Schema(type=openapi.TYPE_STRING),
                'last_name': openapi.Schema(type=openapi.TYPE_STRING),
                'email': openapi.Schema(type=openapi.TYPE_STRING),
                'phone': openapi.Schema(type=openapi.TYPE_STRING),
                'is_superuser': openapi.Schema(type=openapi.TYPE_BOOLEAN),
                'groups': openapi.Schema(
                    type=openapi.TYPE_ARRAY,
                    items=openapi.Schema(type=openapi.TYPE_INTEGER)
                ),
                'user_permissions': openapi.Schema(
                    type=openapi.TYPE_ARRAY,
                    items=openapi.Schema(type=openapi.TYPE_INTEGER)
                ),
            },
        ),
        responses={
            200: "Successful creation of admin.",
            400: "Bad request - Invalid data provided.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to create admin",
        },
    )
    def post(self, request, *args, **kwargs):
        serializer = AdminCreateSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Admin Created Successfully."}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class AdminUpdateِAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["users.edit_admin"]

    @swagger_auto_schema(
        operation_description="Update Admin's ",
        request_body=openapi.Schema(
            type=openapi.TYPE_OBJECT,
            properties={
                'username': openapi.Schema(type=openapi.TYPE_STRING),
                'first_name': openapi.Schema(type=openapi.TYPE_STRING),
                'last_name': openapi.Schema(type=openapi.TYPE_STRING),
                'email': openapi.Schema(type=openapi.TYPE_STRING),
                'phone': openapi.Schema(type=openapi.TYPE_STRING),
                'is_superuser': openapi.Schema(type=openapi.TYPE_BOOLEAN),
                'groups': openapi.Schema(
                    type=openapi.TYPE_ARRAY,
                    items=openapi.Schema(type=openapi.TYPE_INTEGER)
                ),
                'user_permissions': openapi.Schema(
                    type=openapi.TYPE_ARRAY,
                    items=openapi.Schema(type=openapi.TYPE_INTEGER)
                ),
            },
        ),
        responses={
            200: "Successful update of admin.",
            400: "Bad request - Invalid data provided.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - Cannot edit own profile.",
            404: "Not found - Admin does not exist.",
        },
    )
    def put(self, request, pk, *args, **kwargs):
        if request.user.pk == pk:
            return Response({"detail": "you are not authorized to perform this action."},
                            status=status.HTTP_403_FORBIDDEN)
        admin = get_object_or_404(Admin, pk=pk)
        serializer = AdminEditSerializer(admin, data=request.data, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Admin Updated Successfully."}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class AdminSuspendActionAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_required_permissions(self, request):
        return ('users.toggle_block_admin',)

    def post(self, request, pk, action, *args, **kwargs):
        if request.user.pk == pk:
            return Response({"detail": "you are not authorized to perform this action."},
                            status=status.HTTP_403_FORBIDDEN)
        user = Admin.objects.get(pk=pk)
        user.is_active = action == 'unsuspend'
        user.save()

        message = f"user have been {'unsuspend' if user.is_active else 'suspend'} successfully"

        return Response({"message": message}, status=status.HTTP_200_OK)
