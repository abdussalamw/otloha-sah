from django.contrib import messages
from django.contrib.auth.mixins import PermissionRequiredMixin, LoginRequiredMixin
from django.http import JsonResponse, Http404
from django.utils.translation import gettext as _
from django.views import View
from dynamic_listing.views import BulkActionMixin

from apps.users import config
from apps.users.models import Teacher


class TeacherToggleActionView(BulkActionMixin, LoginRequiredMixin, PermissionRequiredMixin,
                              View):
    def dispatch(self, request, *args, **kwargs):
        if kwargs.get('user_type') != config.USER_TYPE_TEACHER_PLURAL:
            raise Http404("Invalid parameter.")
        return super().dispatch(request, *args, **kwargs)

    def get_permission_required(self):
        return self.get_action_permission()

    def get_action_permission(self):
        action = self.kwargs.get("action")
        if action == 'suspend':
            return f"users.suspend_teacherprofile",
        elif action == 'unsuspend':
            return f"users.unsuspend_teacherprofile",
        elif action == 'reject':
            return f"users.reject_teacherprofile",
        elif action == 'approve':
            return f"users.approve_teacherprofile",
        elif action == 'can_reply_on_every_verse_in_recitation' or action == 'can_reply_on_whole_recitation':
            return f"users.toggle_reply_on_every_verse_in_recitation_teacherprofile",

    def toggle_approve(self, queryset):
        for teacher in queryset.all():
            teacher.teacherprofile.is_active = True
            if teacher.teacherprofile.status in [
                teacher.teacherprofile.STATUS_PENDING, teacher.teacherprofile.STATUS_REJECTED]:
                teacher.teacherprofile.status = teacher.teacherprofile.STATUS_APPROVED
            teacher.teacherprofile.save()
            from apps.users.notifications import TeacherApprovedNotification
            teacher.notify(TeacherApprovedNotification, receivers=teacher)
        return _("Users Have Been Approved as a Teacher Successfully")

    def toggle_suspend(self, queryset):
        for teacher in queryset.all():
            teacher.teacherprofile.is_active = False
            teacher.teacherprofile.save()
            from apps.users.notifications import TeacherPrivilegeGrantedOrRevokedNotification
            teacher.notify(TeacherPrivilegeGrantedOrRevokedNotification, receivers=teacher)
        return _("Users Have Been Suspended as a Teacher Successfully")

    def toggle_unsuspend(self, queryset):
        for teacher in queryset.all():
            teacher.teacherprofile.is_active = True
            teacher.teacherprofile.save()
            from apps.users.notifications import TeacherPrivilegeGrantedOrRevokedNotification
            teacher.notify(TeacherPrivilegeGrantedOrRevokedNotification, receivers=teacher)
        return _("Users Have Been Unsuspended as a Teacher Successfully")

    def toggle_reject(self, queryset):
        for teacher in queryset.all():
            if teacher.teacherprofile.status == teacher.teacherprofile.STATUS_PENDING:
                teacher.teacherprofile.is_active = False
                teacher.teacherprofile.status = teacher.teacherprofile.STATUS_REJECTED
                teacher.teacherprofile.save()

                from apps.users.notifications import TeacherRejectedNotification
                teacher.notify(TeacherRejectedNotification, receivers=teacher)
        return _("Users Have Been Rejected as a Teacher Successfully")

    def toggle_can_reply_on_every_verse_in_recitation(self, queryset):
        for teacher in queryset.all():
            teacher.teacherprofile.can_reply_on_every_verse_in_recitation = True
            teacher.teacherprofile.save()
            from apps.users.notifications import TeacherVerseLevelEngagementNotification
            teacher.notify(TeacherVerseLevelEngagementNotification, receivers=teacher)
        return _("Teachers Can Reply on every Verse in Recitation")

    def toggle_can_reply_on_whole_recitation(self, queryset):
        for teacher in queryset.all():
            teacher.teacherprofile.can_reply_on_every_verse_in_recitation = False
            teacher.teacherprofile.save()
            from apps.users.notifications import TeacherVerseLevelEngagementNotification
            teacher.notify(TeacherVerseLevelEngagementNotification, receivers=teacher)
        return _("Teachers Can Reply on all Recitation Only")

    def post(self, request, action, *args, **kwargs):
        status = True
        message = None
        queryset = Teacher.objects

        if teacher_id := kwargs.get('pk', None):
            queryset = queryset.filter(pk=teacher_id)
            if not queryset.exists():
                message = _("Invalid teacher id")
                status = False
        else:
            input_type, value = self.get_actions_type_and_value(request.POST)
            if input_type == 'selected':
                queryset = queryset.filter(id__in=value)
                queryset_ids = queryset.values_list('id', flat=True)
                if not all([int(uid) in queryset_ids for uid in value]) or not queryset.exists():
                    message = _("Invalid teacher ids")
                    status = False
            elif input_type == 'queryset':
                queryset = queryset.filter(id__in=value)
            elif input_type == 'none':
                queryset = queryset.all()
            else:
                message = _("No data provided")
                status = False

        if status:
            method = "toggle_" + action
            message = getattr(self, method)(queryset)
        elif not status and not message:
            message = _("Invalid action")

        messages.success(request, message)
        return JsonResponse({"message": message}, status=200 if status else 422)
