from django.contrib.auth import get_user_model
from django.db.models import Count, Sum, Case, When
from django.utils.translation import gettext_lazy as _
from rest_framework import status
from rest_framework.exceptions import PermissionDenied
from rest_framework.generics import get_object_or_404
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.authz.permissions import AdminPermissionRequired, DynamicPermissionRequiredMixin
from apps.recitation.models import Recitation
from apps.users import config
from apps.users.models import Teacher, Student, TeacherNarration, TeacherRecitationPricing
from apps.users.notifications import AccountBlockedNotification, TeacherApprovedNotification, \
    TeacherPrivilegeGrantedOrRevokedNotification, TeacherRejectedNotification, TeacherVerseLevelEngagementNotification, \
    CertificationGrantedOrRevokedNotification
from apps.users.views.mixins import UserTypeValidationMixin
from django.http import JsonResponse
from django.contrib import messages
from django.utils.timezone import now

UserModel = get_user_model()


class UserToggleBlockAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_required_permissions(self, request):
        if self.kwargs.get('user_type') == 'teacher':
            return ('users.toggle_block_teacher',)
        elif self.kwargs.get('user_type') == 'student':
            return ('users.toggle_block_student',)
        elif self.kwargs.get('user_type') == 'admin':
            return ('users.toggle_block_admin',)


    def post(self, request, pk, action, *args, **kwargs):
        user = UserModel.objects.get(pk=pk)
        user.is_blocked = action == 'block'
        user.save()

        message = f"user have been {'blocked' if user.is_blocked else 'unblocked'} successfully"

        user.notify(AccountBlockedNotification, receivers=user)

        return Response({"message": message}, status=status.HTTP_200_OK)


class TeacherToggleActionAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_required_permissions(self, request, action):
        action_permissions = {
            'approve': 'users.suspend_teacherprofile',
            'block': 'users.toggle_block_teacher',
            'suspend': 'users.suspend_teacherprofile',
            'unsuspend': 'users.unsuspend_teacherprofile',
            'reject': 'users.reject_teacherprofile',
            'can_reply_on_every_verse_in_recitation': 'users.toggle_reply_on_every_verse_in_recitation_teacherprofile',
            'can_reply_on_whole_recitation': 'users.toggle_reply_on_every_verse_in_recitation_teacherprofile',
        }

        required_permission = action_permissions.get(action)
        if required_permission and not request.user.has_perm(required_permission):
            raise PermissionDenied(_("You do not have permission to perform this action."))

    def post(self, request, pk, *args, **kwargs):
        action = kwargs.get('action')
        teacher = get_object_or_404(Teacher, pk=pk)

        method = "toggle_" + action
        if hasattr(self, method):
            self.get_required_permissions(request, action)
            message = getattr(self, method)(teacher)
            return Response({"message": message}, status=status.HTTP_200_OK)
        else:
            return Response({"message": _("Invalid action")}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)

    def toggle_approve(self, teacher):
        teacher.teacherprofile.is_active = True
        if teacher.teacherprofile.status in [teacher.teacherprofile.STATUS_PENDING,
                                             teacher.teacherprofile.STATUS_REJECTED]:
            teacher.teacherprofile.status = teacher.teacherprofile.STATUS_APPROVED
        teacher.teacherprofile.save()
        teacher.notify(TeacherApprovedNotification, receivers=teacher)
        return _("User Has Been Approved as a Teacher Successfully")

    def toggle_suspend(self, teacher):
        teacher.teacherprofile.is_active = False
        teacher.teacherprofile.save()
        teacher.notify(TeacherPrivilegeGrantedOrRevokedNotification, receivers=teacher)
        return _("User Has Been Suspended as a Teacher Successfully")

    def toggle_unsuspend(self, teacher):
        teacher.teacherprofile.is_active = True
        teacher.teacherprofile.save()
        teacher.notify(TeacherPrivilegeGrantedOrRevokedNotification, receivers=teacher)
        return _("User Has Been Unsuspended as a Teacher Successfully")

    def toggle_reject(self, teacher):
        if teacher.teacherprofile.status == teacher.teacherprofile.STATUS_PENDING:
            teacher.teacherprofile.is_active = False
            teacher.teacherprofile.status = teacher.teacherprofile.STATUS_REJECTED
            teacher.teacherprofile.save()
            teacher.notify(TeacherRejectedNotification, receivers=teacher)
        return _("User Has Been Rejected as a Teacher Successfully")

    def toggle_can_reply_on_every_verse_in_recitation(self, teacher):
        teacher.teacherprofile.can_reply_on_every_verse_in_recitation = True
        teacher.teacherprofile.save()
        teacher.notify(TeacherVerseLevelEngagementNotification, receivers=teacher)
        return _("Teacher Can Reply on every Verse in Recitation")

    def toggle_can_reply_on_whole_recitation(self, teacher):
        teacher.teacherprofile.can_reply_on_every_verse_in_recitation = False
        teacher.teacherprofile.save()
        teacher.notify(TeacherVerseLevelEngagementNotification, receivers=teacher)
        return _("Teacher Can Reply on all Recitation Only")


class ToggleTeacherNarrationCertificationView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_required_permissions(self, request):
        return ("users.toggle_certification_teachernarration",)

    def post(self, request, pk, narration_id, action, *args, **kwargs):
        teacher_narration = get_object_or_404(TeacherNarration, teacher_id=pk, narration_id=narration_id)

        if teacher_narration.is_certified and action == 'suspend':
            teacher_narration.is_certified = False
            teacher_narration.certified_at = None
            message = _("Certification revoked successfully")
        elif not teacher_narration.is_certified and action == 'unsuspend':
            teacher_narration.is_certified = True
            teacher_narration.certified_at = now()
            message = _("Certification granted successfully")

        teacher_narration.save()
        teacher_narration.notify(CertificationGrantedOrRevokedNotification, sender=request.user,
                                 receivers=teacher_narration.teacher)
        messages.success(request, message)

        return Response(messages, status=status.HTTP_200_OK)


class ToggleMarkTeacherRecitationPricingAsCompleteView(APIView, DynamicPermissionRequiredMixin):

    def get_required_permissions(self, request):
        return ("users.complete_teacherrecitationpricing",)

    def post(self, request, *args, **kwargs):
        message = _("Successfully marked as complete")
        queryset = get_object_or_404(TeacherRecitationPricing, teacher=kwargs.get('pk'),
                                     pricing_id=kwargs.get('pricing_id', None))

        queryset.update(is_paid=True, paid_at=now())

        return Response(message, status=status.HTTP_200_OK)


class UserStatisticsAPIView(APIView, DynamicPermissionRequiredMixin, UserTypeValidationMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    # def get_required_permissions(self, request):
    #     user_type = self.kwargs.get('user_type')
    #     if user_type == config.USER_TYPE_TEACHER:
    #         return ('users.toggle_block_teacher',)
    #     elif user_type == config.USER_TYPE_STUDENT:
    #         return ('users.toggle_block_student',)
    #     return ()
    def get_permission_required(self):
        return f"users.view_{self.permission_model_name}",

    def get_statistics(self, user_type):
        if user_type == config.USER_TYPE_STUDENT:
            return Student.objects.aggregate(
                students_count=Count('id'),
                active_students_count=Sum(Case(When(is_active=True, then=1), default=0)),
                blocked_students_count=Sum(Case(When(is_active=False, then=1), default=0)),
                female_count=Sum(Case(When(gender=config.GENDER_FEMALE, then=1), default=0)),
                male_count=Sum(Case(When(gender=config.GENDER_MALE, then=1), default=0)),

            )
        elif user_type == config.USER_TYPE_TEACHER:
            return Teacher.objects.aggregate(
                teachers_count=Count('id'),
                approved_teachers_count=Sum(Case(When(teacherprofile__status='approved', then=1), default=0)),
                pending_teachers_count=Sum(Case(When(teacherprofile__status='pending', then=1), default=0)),
                rejected_teachers_count=Sum(Case(When(teacherprofile__status='rejected', then=1), default=0)),
                paid_teachers_count=Sum(Case(When(teacherprofile__teacher_type='paid', then=1), default=0)),
                volunteer_teachers_count=Sum(Case(When(teacherprofile__teacher_type='volunteer', then=1), default=0)),
            )
        return {}

    def get(self, request, user_type):
        statistics = self.get_statistics(user_type)
        return Response(statistics, status=status.HTTP_200_OK)


class TeacherCorrectRecitationToggleActionAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_required_permissions(self, request, action):
        action_permissions = {
            'reject': 'recitations.change_recitation',
            'accept': 'recitations.change_recitation',
            'report': 'recitations.change_recitation',
        }

        required_permission = action_permissions.get(action)
        if required_permission and not request.user.has_perm(required_permission):
            raise PermissionDenied(_("You do not have permission to perform this action."))

    def post(self, request, pk, *args, **kwargs):
        action = kwargs.get('action')
        recitation = get_object_or_404(Recitation, pk=pk)

        method = "toggle_" + action
        if hasattr(self, method):
            self.get_required_permissions(request, action)
            message = getattr(self, method)(recitation)
            return Response({"message": message}, status=status.HTTP_200_OK)
        else:
            return Response({"message": _("Invalid action")}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)

    def toggle_accept(self, recitation):
        recitation.result = "accept"
        recitation.save()
        return _("Recitation result has been accepted successfully")

    def toggle_reject(self, recitation):
        recitation.result = "reject"
        recitation.save()
        return _("Recitation result has been rejected successfully")

    def toggle_report(self, recitation):
        recitation.result = "report"
        recitation.save()
        return _("Recitation result has been reported successfully")
