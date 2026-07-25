from django.shortcuts import get_object_or_404
from django.utils.translation import gettext as _
from rest_framework import permissions

from apps.recitations import config
from apps.recitations.models import Recitation


class IsATeacherPermission(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user.is_a_teacher if request.user.is_authenticated else False


class CheckGenderPermission(permissions.BasePermission):
    message = _("This profile is private due to user's gender control")

    def has_object_permission(self, request, view, obj):
        from apps.settings.utils import get_user_setting

        if request.user == obj:
            return True

        return any([
            request.user.gender == obj.gender,
            get_user_setting(obj, 'display_profile_to_opposite_gender'),
            request.user.favorite_teacher == obj,
            request.user == obj.favorite_teacher
        ])


