from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from django.utils.timezone import now
from django.utils.translation import gettext as _
from django.views import View

from apps.users.models import TeacherNarration
from apps.users.notifications import CertificationGrantedOrRevokedNotification


class ToggleTeacherNarrationCertificationView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = "users.toggle_certification_teachernarration"

    def post(self, request, pk, narration_id, *args, **kwargs):
        teacher_narration = get_object_or_404(TeacherNarration, teacher_id=pk, narration_id=narration_id)

        if teacher_narration.is_certified:
            teacher_narration.is_certified = False
            teacher_narration.certified_at = None
            message = _("Certification revoked successfully")
        else:
            teacher_narration.is_certified = True
            teacher_narration.certified_at = now()
            message = _("Certification Granted Successfully")

        teacher_narration.save()
        teacher_narration.notify(CertificationGrantedOrRevokedNotification, sender=request.user,
                                 receivers=teacher_narration.teacher)
        messages.success(request, message)

        return JsonResponse({
            "message": message
        })
