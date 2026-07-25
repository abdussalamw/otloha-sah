from django.contrib.auth import get_user_model
from django.contrib.auth.models import Group, Permission
from django.db.models import Count
from django.shortcuts import get_object_or_404
from django.utils.translation import gettext as _
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.authz.models import PermissionRequest
from apps.authz.permissions import DynamicPermissionRequiredMixin, AdminPermissionRequired
from apps.authz.serializers import GroupCreateUpdateSerializer, PermissionRequestSerializer
from apps.authz.serializers import GroupSerializer
from apps.users.models import User
from django.utils import timezone
from drf_yasg import openapi
from django.contrib import auth

User = get_user_model()


class GroupListAPIView(DynamicPermissionRequiredMixin, APIView):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    serializer_class = GroupSerializer

    def get_permission_required(self):
        return ["auth.view_group"]

    @swagger_auto_schema(
        operation_description="List all groups.",
        responses={
            200: "Successful response with groups list.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view groups",
        },
    )
    def get(self, request, *args, **kwargs):
        self.check_permissions(request)
        groups = Group.objects.all().annotate(
            total_users=Count('user')
        )
        serializer = self.serializer_class(groups, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class GroupDetailsAPIView(DynamicPermissionRequiredMixin, APIView):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    serializer_class = GroupSerializer

    def get_permission_required(self):
        return ["auth.view_group"]

    @swagger_auto_schema(
        operation_description="Get details of a specific group.",
        responses={
            200: "Successful response with group details.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view this group",
            404: "Not Found - Group does not exist",
        },
    )
    def get(self, request, pk, *args, **kwargs):
        self.check_permissions(request)
        group = get_object_or_404(Group, pk=pk)
        serializer = self.serializer_class(group)
        return Response(serializer.data, status=status.HTTP_200_OK)


class GroupCreateAPIView(DynamicPermissionRequiredMixin, APIView):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    serializer_class = GroupCreateUpdateSerializer

    def get_permission_required(self):
        return ["auth.add_group"]

    @swagger_auto_schema(request_body=GroupCreateUpdateSerializer,
                         operation_description="Create a new group.",
                         responses={
                             201: "Successful response with created group details.",
                             401: "Unauthorized - The user is Unauthorized",
                             403: "Forbidden - The user is not authorized to create group",
                             422: "Unprocessable Entity - Invalid data provided",
                         },
                         )
    def post(self, request, *args, **kwargs):
        self.check_permissions(request)
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class GroupUpdateAPIView(DynamicPermissionRequiredMixin, APIView):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    serializer_class = GroupCreateUpdateSerializer

    def get_permission_required(self):
        return ["auth.change_group"]

    @swagger_auto_schema(request_body=GroupCreateUpdateSerializer,
                         operation_description="Update an existing group.",
                         responses={
                             200: "Successful response with updated group details.",
                             401: "Unauthorized - The user is Unauthorized",
                             403: "Forbidden - The user is not authorized to update group",
                             422: "Unprocessable Entity - Invalid data provided",
                         },
                         )
    def put(self, request, pk, *args, **kwargs):
        self.check_permissions(request)
        group = get_object_or_404(Group, pk=pk)
        serializer = self.serializer_class(group, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class GroupDeleteAPIView(DynamicPermissionRequiredMixin, APIView):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_permission_required(self):
        return ["auth.delete_group"]

    @swagger_auto_schema(
        operation_description="Delete a group.",
        responses={
            204: "Successful response - Group deleted",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to delete group",
        },
    )
    def delete(self, request, pk, *args, **kwargs):
        self.check_permissions(request)
        group = get_object_or_404(Group, pk=pk)
        group.delete()
        return Response({"message": _("Group deleted successfully")}, status=status.HTTP_204_NO_CONTENT)


class GrantGroupAccessAPIView(DynamicPermissionRequiredMixin, APIView):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    serializer_class = GroupCreateUpdateSerializer

    def get_permission_required(self):
        return ["auth.change_group"]

    @swagger_auto_schema(request_body=GroupCreateUpdateSerializer,
                         operation_description="Grant access to a group.",
                         responses={
                             200: "Successful response - Access granted",
                             403: "Forbidden - The user is not authorized to access this group",
                             422: "Unprocessable Entity - Invalid Group ID provided",

                         },
                         )
    def post(self, request, pk, *args, **kwargs):
        self.check_permissions(request)
        group = get_object_or_404(Group, pk=pk)
        serializer = self.serializer_class(group, data=request.data, partial=True)

        if serializer.is_valid():
            serializer.save()
            return Response({"message": _("Access granted successfully")}, status=status.HTTP_200_OK)

        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class RevokeGroupAccessAPIView(DynamicPermissionRequiredMixin, APIView):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    serializer_class = GroupCreateUpdateSerializer

    def get_permission_required(self):
        return ["auth.change_group"]

    @swagger_auto_schema(request_body=GroupCreateUpdateSerializer,
                         operation_description="Revoke access from a group for a specific user.",
                         responses={
                             200: "Successful response - Access revoked",
                             403: "Forbidden - The user is not authorized to revoke this group Access",
                             422: "Unprocessable Entity - Invalid user ID provided",
                         },
                         )
    def post(self, request, pk, user_id, *args, **kwargs):
        self.check_permissions(request)
        group = get_object_or_404(Group, pk=pk)
        try:
            user = group.user_set.get(pk=user_id)
            user.groups.remove(group)
            return Response({"message": _("Access revoked successfully")}, status=status.HTTP_200_OK)
        except (Group.DoesNotExist, User.DoesNotExist):
            return Response({"message": _("Invalid user id")}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class PermissionRequestView(DynamicPermissionRequiredMixin, APIView):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_permission_required(self):
        return ["auth.create_permissionrequest"]

    @swagger_auto_schema(
        operation_description="Create a new permission request.",
        responses={
            201: "Successful response with a message indicating the request was created.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view this group",
            404: "Not Found",
            422: "Unprocessable Entity - Invalid data provided",
        },
    )
    def post(self, request, permission_id, *args, **kwargs):
        self.check_permissions(request)
        permission = get_object_or_404(Permission, pk=permission_id)
        PermissionRequest.objects.create(user=request.user, permission=permission)
        return Response({"message": _("Request created successfully.")}, status=status.HTTP_201_CREATED)


class ResponsePermissionRequestView(DynamicPermissionRequiredMixin, APIView):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_required_permissions(self, request):
        return ['auth.response_permissionrequest']

    @swagger_auto_schema(
        operation_description="Respond to a permission request.",
        manual_parameters=[
            openapi.Parameter(
                'action', openapi.IN_PATH, description="Action to perform: 'approve' or 'reject'",
                type=openapi.TYPE_STRING, enum=['approve', 'reject'], required=True
            )
        ],
        responses={
            200: openapi.Response("Permission request updated successfully."),
            401: openapi.Response("Unauthorized - The user is Unauthorized"),
            403: openapi.Response("Forbidden - You do not have permission to perform this action."),
            404: openapi.Response("Not Found"),
            422: openapi.Response("UNPROCESSABLE ENTITY. Use 'approve' or 'reject'."),
        },
    )
    def post(self, request, pk, action, *args, **kwargs):
        self.check_permissions(request)
        permission_request = get_object_or_404(PermissionRequest, pk=pk)

        if action == 'approve':
            permission_request.approved = True
            permission_request.approved_by = request.user
            permission_request.approved_at = timezone.now()
            permission_request.save()
            permission_request.user.user_permissions.add(permission_request.permission)
        elif action == 'reject':
            permission_request.delete()
        else:
            return Response({"message": _("Invalid response. Use 'approve' or 'reject'.")},
                            status=status.HTTP_422_UNPROCESSABLE_ENTITY)

        return Response({"message": _("Permission request updated successfully.")}, status=status.HTTP_200_OK)


class PermissionRequestListAPIView(DynamicPermissionRequiredMixin, APIView):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_required_permissions(self, request):
        return ['auth.view_permissionrequest']

    @swagger_auto_schema(
        operation_description="Retrieve a list of all permission requests.",
        responses={
            200: openapi.Response(
                description="A list of permission requests.",
                examples={
                    "application/json": [
                        {
                            "id": 1,
                            "user": "username",
                            "permission": "permission_codename",
                            "requested_at": "2024-06-09T10:35:29Z",
                            "approved_by": "admin_username",
                            "approved_at": "2024-06-09T11:35:29Z"
                        }
                    ]
                }
            ),
            401: openapi.Response("Unauthorized - The user is Unauthorized"),
            403: openapi.Response("Forbidden - You do not have permission to perform this action."),
            404: openapi.Response("Not Found")
        }
    )
    def get(self, request, *args, **kwargs):
        self.check_permissions(request)
        permission_requests = PermissionRequest.objects.all()
        serializer = PermissionRequestSerializer(permission_requests, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class UsersPermissionsListView(DynamicPermissionRequiredMixin, APIView):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_required_permissions(self, request):
        return ['auth.view_permission']

    @swagger_auto_schema(
        responses={
            200: "List of permission names",
            403: "Forbidden - The user is not authorized to view permissions",
        },
    )
    def get(self, request):
        self.check_permissions(request)
        permissions = set()
        for backend in auth.get_backends():
            if hasattr(backend, "get_all_permissions"):
                permissions.update(backend.get_all_permissions(request.user))
        return Response(permissions)


class UserPermissionsView(DynamicPermissionRequiredMixin, APIView):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_required_permissions(self, request):
        return ['auth.view_permission']

    @swagger_auto_schema(
        responses={
            200: "List of permission names",
            403: "Forbidden - The user is not authorized to view this group",
        },
    )
    def get(self, request, user_id):
        self.check_permissions(request)
        user = get_object_or_404(User, pk=user_id)
        permissions = set()
        for backend in auth.get_backends():
            if hasattr(backend, "get_all_permissions"):
                permissions.update(backend.get_all_permissions(user))

        return Response(permissions)
