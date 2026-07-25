from django.db.models import Count
from django.db.models import When, Case, Sum, Avg, Subquery, OuterRef
from django.db.models.functions import Coalesce
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.generics import ListAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.authz.permissions import AdminPermissionRequired, DynamicPermissionRequiredMixin
from apps.recitations.api.v2.filters_api_v2 import RecitationFilter
from apps.recitations.api.v2.serializers import BaseRecitationSerializer
from apps.recitations.models import Recitation
from apps.tajweed.models import TajweedUserProgress, TajweedLesson, TajweedLevel
from apps.users.models import Student
from apps.users_profiles.filters.filters_admin_api_v1 import StudentFilter
from apps.users_profiles.serializers.serializers_admin_v1.students import StudentListSerializer, \
    RecitationProgressSerializer


class AdminStudentsListAPIView(ListAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["users.view_student"]
    model = Student
    serializer_class = StudentListSerializer
    filterset_class = StudentFilter

    def get_required_permissions(self, request):
        if request.method == 'GET':
            return ["users.view_student"]

    def get_queryset(self):
        return Student.objects.select_related('favorite_teacher').annotate(
            total_recitations=Count('id'),
            accepted_recitations=Coalesce(Sum(Case(When(recitations__result='accepted', then=1), default=0)), 0),
            rejected_recitations=Coalesce(Sum(Case(When(recitations__result='rejected', then=1), default=0)), 0),
            reported_recitations=Coalesce(Sum(Case(When(recitations__result='reported', then=1), default=0)), 0),
            pending_recitations=Coalesce(Sum(Case(When(recitations__result__isnull=True, then=1), default=0)), 0)
        )

    @swagger_auto_schema(
        operation_description="List all students.",
        responses={
            200: "Successful response with a list of students.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view students",
            404: "Not Found - students do not exist",
            "response_body": StudentListSerializer
        },
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)


class UserRecitationProgressAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["users.view_student"]
    serializer_class = RecitationProgressSerializer

    @swagger_auto_schema(
        operation_description="Return Progress Recitations Result by narration for user.",
        responses={
            200: "Successful response.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view students",
            404: "Not Found - Student does not exist",
        }
    )
    def get(self, request, pk, narration_id):
        progress_data = RecitationProgressSerializer.get_progress_data(pk, narration_id)
        serializer = self.serializer_class(data=progress_data)
        serializer.is_valid(raise_exception=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class UserTajweedProgressAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["users.view_student"]

    @swagger_auto_schema(
        operation_description="Return Progress Tajweed Result for user.",
        responses={
            200: "Successful response.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view students",
            404: "Not Found - Students or progress does not exist",
        }
    )
    def get(self, request, pk):
        total_lessons_per_level = TajweedLesson.objects.filter(
            level=OuterRef('level')
        ).values('level').annotate(total_lessons=Count('id')).values('total_lessons')

        user_progress = TajweedUserProgress.objects.filter(user_id=pk).values('level').annotate(
            total_completed=Sum('completed'),
            total_read=Sum('read'),
            average_rate=Avg('rate'),
            completed_lessons=Count('lesson'),
            total_lessons=Subquery(total_lessons_per_level)
        )

        user_levels = set()
        total_completed_percentage = 0

        for progress in user_progress:
            total_lessons = progress['total_lessons']
            if total_lessons > 0:
                progress['completed_percentage'] = (progress.pop('total_completed') / total_lessons) * 100
                progress['read_percentage'] = (progress.pop('total_read') / total_lessons)
                progress['average_rate'] /= total_lessons
                total_completed_percentage += progress['completed_percentage']
            user_levels.add(progress['level'])

        total_levels_count = TajweedLevel.objects.count()

        level_completion_percentage = (
                total_completed_percentage / total_levels_count) if total_levels_count > 0 else 0

        response_data = {
            'total_levels_count': total_levels_count,
            'total_user_levels_count': len(user_levels),
            'level_completion_percentage': f"{level_completion_percentage:.2f}%",
            'user_level_progress_details': list(user_progress),
        }

        return Response(response_data)


class AdminListGeneralRecitation(ListAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["users.view_any_recitation"]
    serializer_class = BaseRecitationSerializer
    filterset_class = RecitationFilter

    @swagger_auto_schema(
        operation_description="Return Genral Recitation for user.",
        responses={
            200: "Successful Data Response.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view Recitations",
        }
    )
    def get_queryset(self):
        return Recitation.objects.filter(owner_id=self.kwargs['pk'], khatmauser__isnull=True,
                                         tajweed_lesson_example__isnull=True)


class AdminListKhatmaRecitation(ListAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["users.view_any_recitation"]
    serializer_class = BaseRecitationSerializer
    filterset_class = RecitationFilter

    @swagger_auto_schema(
        operation_description="Return Khatma Recitation for user.",
        responses={
            200: "Successful Data Response.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view Recitations",
        }
    )
    def get_queryset(self):
        return Recitation.objects.filter(owner_id=self.kwargs['pk'], khatmauser__isnull=False)


class AdminListTajweedRecitation(ListAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["users.view_any_recitation"]
    serializer_class = BaseRecitationSerializer
    filterset_class = RecitationFilter

    @swagger_auto_schema(
        operation_description="Return Tajweed Recitation for user.",
        responses={
            200: "Successful Data Response.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view Recitations",
        }
    )
    def get_queryset(self):
        return Recitation.objects.filter(owner_id=self.kwargs['pk'], tajweed_lesson_example__isnull=False)
