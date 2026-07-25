from django.db.models import Sum, Count, Case, When
from django.db.models.functions import Coalesce
from django.utils.timezone import now
from django.utils.translation import gettext_lazy as _
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import status
from rest_framework.generics import get_object_or_404, RetrieveAPIView
from rest_framework.permissions import IsAdminUser
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.users import config
from apps.users.models import Student, TeacherNarration, USER_MODELS, User
from apps.users.models import Teacher
from apps.users.notifications import (
    AccountBlockedNotification,
    CertificationGrantedOrRevokedNotification,
    TeacherApprovedNotification,
    TeacherPrivilegeGrantedOrRevokedNotification,
    TeacherRejectedNotification,
    TeacherVerseLevelEngagementNotification,
)
from apps.users.serializers import TeacherNarrationSerializer, TeacherSerializer, StudentSerializer, \
    TeacherRecitationPricingSerializer, RecitationSerializer
from apps.users_profiles.filters.filters_api_v2 import UserFilter


# class StudentsListView(ListAPIView):
#     serializer_class = UserSerializer
#     permission_classes = [IsAdminUser]
#     filter_backends = [DjangoFilterBackend]
#     filterset_class = UserFilter
#
#     def get_queryset(self):
#         return Student.objects.all()
#
#     def get_serializer_context(self):
#         return {'user': self.request.user}
#
#
# class TeachersListView(ListAPIView):
#     serializer_class = UserSerializer
#     permission_classes = [IsAdminUser]
#     filter_backends = [DjangoFilterBackend]
#     filterset_class = UserFilter
#
#     def get_queryset(self):
#         return Teacher.objects.all()
#
#     def get_serializer_context(self):
#         return {'user': self.request.user}

class UserListingAPIView(APIView):
    permission_classes = [IsAdminUser]
    filter_backends = [DjangoFilterBackend]
    filterset_class = UserFilter

    def get_statistics(self, user_type):
        statistics = {}

        if user_type == config.USER_TYPE_STUDENT:
            statistics = User.objects.aggregate(
                students_count=Count('id'),
                active_students_count=Sum(Case(When(is_active=True, then=1), default=0)),
                blocked_students_count=Sum(Case(When(is_active=False, then=1), default=0)),
            )

        elif user_type == config.USER_TYPE_TEACHER:
            statistics = User.objects.aggregate(
                teachers_count=Count('id'),
                approved_teachers_count=Sum(Case(When(teacherprofile__status='approved', then=1), default=0)),
                pending_teachers_count=Sum(Case(When(teacherprofile__status='pending', then=1), default=0)),
                rejected_teachers_count=Sum(Case(When(teacherprofile__status='rejected', then=1), default=0)),
                paid_teachers_count=Sum(Case(When(teacherprofile__teacher_type='paid', then=1), default=0)),
                volunteer_teachers_count=Sum(Case(When(teacherprofile__teacher_type='volunteer', then=1), default=0)))

        return statistics

    def get(self, request, user_type):
        statistics = self.get_statistics(user_type)
        response_data = {**statistics}
        return Response(response_data)


class ToggleTeacherNarrationCertificationAPIView(APIView):
    permission_classes = [IsAdminUser]

    def post(self, request, pk, narration_id, suspend_type, *args, **kwargs):
        teacher_narration = get_object_or_404(TeacherNarration, teacher_id=pk, narration_id=narration_id)

        if teacher_narration.is_certified and suspend_type == 'suspend':
            teacher_narration.is_certified = False
            teacher_narration.certified_at = None
            message = _("Certification revoked successfully")

        elif not teacher_narration.is_certified and suspend_type == 'unsuspend':
            teacher_narration.is_certified = True
            teacher_narration.certified_at = now()
            message = _("Certification granted successfully")

        else:
            message = _("Invalid operation: This Certification Already {}").format(suspend_type)
            return Response({"message": message}, status=status.HTTP_400_BAD_REQUEST)

        teacher_narration.save()
        teacher_narration.notify(CertificationGrantedOrRevokedNotification, sender=request.user,
                                 receivers=teacher_narration.teacher)

        return Response({"message": message}, status=status.HTTP_200_OK)


class UserToggleBlockAPIView(APIView):
    permission_classes = [IsAdminUser]

    def get_user_type_and_model(self, pk=None, user_ids=None):
        user_type_plural_to_singular = {
            config.USER_TYPE_TEACHER_PLURAL: config.USER_TYPE_TEACHER,
            config.USER_TYPE_STUDENT_PLURAL: config.USER_TYPE_STUDENT,
            config.USER_TYPE_ADMIN_PLURAL: config.USER_TYPE_ADMIN
        }

        for plural, singular in user_type_plural_to_singular.items():
            model = USER_MODELS.get(singular)
            if model:
                if pk:
                    if model.objects.filter(pk=pk).exists():
                        return singular, model
                elif user_ids:
                    queryset = model.objects.filter(pk__in=user_ids)
                    if queryset.exists():
                        return singular, model

        return None, None

    def post(self, request, action, *args, **kwargs):
        pk = kwargs.get('pk')
        user_ids = request.data.get('user_ids', [])
        user_type, model = self.get_user_type_and_model(pk=pk, user_ids=user_ids)

        if not user_type or not model:
            return Response({"error": "Invalid user id(s)."}, status=status.HTTP_404_NOT_FOUND)

        is_blocked = action == 'block'
        queryset = model.objects.filter(pk__in=[pk] if pk else user_ids)
        queryset.update(is_blocked=is_blocked)

        message = f"{config.get_user_type_verbose_name_plural_by_key(user_type)} have been {'blocked' if is_blocked else 'unblocked'} successfully"
        for user in queryset.all():
            user.notify(AccountBlockedNotification, receivers=user)

        return Response({"message": message}, status=status.HTTP_200_OK)


class TeacherToggleActionAPIView(APIView):
    permission_classes = [IsAdminUser]

    def post(self, request, action, *args, **kwargs):
        queryset = Teacher.objects
        teacher_id = kwargs.get('pk')

        if teacher_id:
            queryset = queryset.filter(pk=teacher_id)
            if not queryset.exists():
                return Response({"message": _("Invalid teacher id")}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)
        else:
            queryset = self.get_queryset(request)

        method = "toggle_" + action
        if hasattr(self, method):
            message = getattr(self, method)(queryset)
            return Response({"message": message}, status=status.HTTP_200_OK)
        else:
            return Response({"message": _("Invalid action")}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)

    def get_queryset(self, request):
        queryset = Teacher.objects
        queryset_ids = request.data.get('user_ids', [])

        if queryset_ids:
            queryset = queryset.filter(id__in=queryset_ids)
            if not queryset.exists():
                return Response({"message": _("Invalid teacher ids")}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)

        return queryset

    def toggle_approve(self, queryset):
        for teacher in queryset.all():
            teacher.teacherprofile.is_active = True
            if teacher.teacherprofile.status in [teacher.teacherprofile.STATUS_PENDING,
                                                 teacher.teacherprofile.STATUS_REJECTED]:
                teacher.teacherprofile.status = teacher.teacherprofile.STATUS_APPROVED
            teacher.teacherprofile.save()
            teacher.notify(TeacherApprovedNotification, receivers=teacher)
        return _("Users Have Been Approved as a Teacher Successfully")

    def toggle_suspend(self, queryset):
        for teacher in queryset.all():
            teacher.teacherprofile.is_active = False
            teacher.teacherprofile.save()
            teacher.notify(TeacherPrivilegeGrantedOrRevokedNotification, receivers=teacher)
        return _("Users Have Been Suspended as a Teacher Successfully")

    def toggle_unsuspend(self, queryset):
        for teacher in queryset.all():
            teacher.teacherprofile.is_active = True
            teacher.teacherprofile.save()
            teacher.notify(TeacherPrivilegeGrantedOrRevokedNotification, receivers=teacher)
        return _("Users Have Been Unsuspended as a Teacher Successfully")

    def toggle_reject(self, queryset):
        for teacher in queryset.all():
            if teacher.teacherprofile.status == teacher.teacherprofile.STATUS_PENDING:
                teacher.teacherprofile.is_active = False
                teacher.teacherprofile.status = teacher.teacherprofile.STATUS_REJECTED
                teacher.teacherprofile.save()
                teacher.notify(TeacherRejectedNotification, receivers=teacher)
        return _("Users Have Been Rejected as a Teacher Successfully")

    def toggle_can_reply_on_every_verse_in_recitation(self, queryset):
        for teacher in queryset.all():
            teacher.teacherprofile.can_reply_on_every_verse_in_recitation = True
            teacher.teacherprofile.save()
            teacher.notify(TeacherVerseLevelEngagementNotification, receivers=teacher)
        return _("Teachers Can Reply on every Verse in Recitation")

    def toggle_can_reply_on_whole_recitation(self, queryset):
        for teacher in queryset.all():
            teacher.teacherprofile.can_reply_on_every_verse_in_recitation = False
            teacher.teacherprofile.save()
            teacher.notify(TeacherVerseLevelEngagementNotification, receivers=teacher)
        return _("Teachers Can Reply on all Recitation Only")


class MarkTeacherRecitationPricingAsCompleteAPIView(APIView):
    permission_classes = [IsAdminUser]

    def post(self, request, *args, **kwargs):
        teacher = get_object_or_404(Teacher, pk=kwargs.get('pk'))
        queryset = teacher.teacherrecitationpricing_set

        pricing_id = kwargs.get('pricing_id', None)
        if pricing_id:
            queryset = queryset.filter(pk=pricing_id)
            if not queryset.exists():
                return Response({"message": _("Invalid pricing id")}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)
            elif queryset.filter(is_paid=True).exists():
                return Response({"message": _("The selected pricing is already paid")},
                                status=status.HTTP_422_UNPROCESSABLE_ENTITY)
        else:
            pricing_ids = request.data.get('pricing_ids', [])
            if pricing_ids:
                queryset = queryset.filter(id__in=pricing_ids)
                queryset_ids = queryset.values_list('id', flat=True)
                if not all([int(pid) in queryset_ids for pid in pricing_ids]) or not queryset.exists():
                    return Response({"message": _("Invalid pricing ids")}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)
                elif queryset.filter(is_paid=True).exists():
                    return Response({"message": _("Some of the selected pricing are already paid")},
                                    status=status.HTTP_422_UNPROCESSABLE_ENTITY)
            else:
                queryset = queryset.filter(is_paid=False, paid_at__isnull=True)

        queryset.update(is_paid=True, paid_at=now())
        return Response({"message": _("Successfully marked as complete")}, status=status.HTTP_200_OK)


class UserDetailsAPIView(RetrieveAPIView):
    permission_classes = [IsAdminUser]

    def get_serializer_class(self):
        user_type = self.kwargs.get('user_type')
        return TeacherSerializer if user_type == 'teacher' else StudentSerializer

    def get(self, request, *args, **kwargs):
        user_type = self.kwargs.get('user_type')
        details_type = self.kwargs.get('details_type', 'overview')
        user_model = Teacher if user_type == 'teacher' else Student
        user = get_object_or_404(user_model, pk=self.kwargs['pk'])

        context = {
            'user': self.get_serializer_class()(user).data,
            'details_type': details_type,
        }

        if user_type == 'teacher':
            context.update(self.get_teacher_details(user, details_type))
        elif user_type == 'student':
            context.update(self.get_student_details(user, details_type))

        return Response(context)

    def get_teacher_details(self, teacher, details_type):
        context = {}
        recitations = None

        if details_type == 'corrected-recitations':
            recitations = teacher.recitations_teacher.all()
        elif details_type == 'recitations':
            recitations = teacher.recitations.all()
        elif details_type == 'teacher-recitations':
            recitations = teacher.recitations.filter(is_teacher_recitation=True)
        elif details_type == 'narrations':
            narrations = teacher.teachernarration_set.all()
            context['narrations'] = TeacherNarrationSerializer(narrations, many=True).data
        elif details_type == 'accounting':
            accounting = teacher.teacherrecitationpricing_set.filter(recitation__evaluated_at__isnull=False)
            context['accounting'] = TeacherRecitationPricingSerializer(accounting, many=True).data
            context['teacher_earnings'] = accounting.filter(is_paid=True).aggregate(sum=Coalesce(Sum("price"), 0.0))[
                'sum']
            context['teacher_dues'] = accounting.filter(is_paid=False).aggregate(sum=Coalesce(Sum("price"), 0.0))['sum']
        elif details_type == 'students':
            students = Student.objects.filter(favorite_teacher=teacher)
            context['students_count'] = students.count()
            context['students'] = [
                self.get_student_with_recitation_stats(student)
                for student in students
            ]

        if recitations:
            context['recitations'] = RecitationSerializer(recitations, many=True).data
            context['recitation_stats'] = self.get_recitation_stats(recitations)

        return context

    def get_student_details(self, student, details_type):
        context = {}
        if details_type == 'recitations':
            recitations = student.recitations.all()
            context['recitations'] = RecitationSerializer(recitations, many=True).data
        return context

    def get_student_with_recitation_stats(self, student):
        student_recitations = student.recitations.all()
        recitation_stats = self.get_recitation_stats(student_recitations)
        student_data = StudentSerializer(student).data
        student_data['recitation_stats'] = recitation_stats
        return student_data

    def get_recitation_stats(self, recitations):
        return recitations.aggregate(
            total=Count('id'),
            accepted=Coalesce(Sum(Case(When(result='accepted', then=1), default=0)), 0),
            rejected=Coalesce(Sum(Case(When(result='rejected', then=1), default=0)), 0),
            reported=Coalesce(Sum(Case(When(result='reported', then=1), default=0)), 0),
            pending=Coalesce(Sum(Case(When(result__isnull=True, then=1), default=0)), 0)
        )
