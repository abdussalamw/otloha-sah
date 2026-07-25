from rest_framework import permissions
from django.contrib.auth import get_user_model

User = get_user_model()


class DynamicPermissionRequiredMixin:
    required_permissions = []
    any_permissions = False

    def get_required_permissions(self, request):
        return self.required_permissions

    def check_permissions(self, request):
        required_permissions = self.get_permission_required()
        for permission in required_permissions:
            if not request.user.has_perm(permission):
                self.permission_denied(
                    request,
                    message=f"You should have permission: {permission}",
                    code='permission_denied'
                )


class DynamicPermissionRequired(permissions.BasePermission):

    def get_required_permissions(self, request, view):
        return view.get_required_permissions(request)

    def has_permission(self, request, view):
        user = request.user
        if not user or not user.is_authenticated:
            return False
        required_permissions = self.get_required_permissions(request, view)
        if view.any_permissions:
            return any(user.has_perm(perm) for perm in required_permissions)
        return all(user.has_perm(perm) for perm in required_permissions)


class AdminPermissionRequired(DynamicPermissionRequired):

    def has_permission(self, request, view):
        return super().has_permission(request, view) and bool(request.user and request.user.is_staff)
