from django.db.models import Count, When, Case, Sum, Subquery, FloatField, OuterRef
from django.db.models.functions import Coalesce
from rest_framework.generics import ListAPIView, RetrieveAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from apps.authz.permissions import AdminPermissionRequired, DynamicPermissionRequiredMixin
from apps.recitation.models import Recitation
from apps.users.models import Student, Teacher, TeacherRecitationPricing, TeacherNarration
from apps.users_profiles.filters.filters_admin_api_v1 import TeacherFilter, StudentFilter
from apps.users_profiles.serializers.serializers_admin_v1 import TeacherListSerializer, TeacherDetailSerializer, \
    TeacherNarrationSerializer, TeacherAccountingSerializer, TeacherRecitationsSerializer
from apps.users_profiles.serializers.serializers_admin_v1.students import StudentListSerializer
from drf_yasg.utils import swagger_auto_schema


class AdminTeachersListAPIView(ListAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    model = Teacher
    serializer_class = TeacherListSerializer
    filterset_class = TeacherFilter

    def get_required_permissions(self, request):
        if request.method == 'GET':
            return ["users.view_teacher"]

    def get_queryset(self):
        earnings_subquery = TeacherRecitationPricing.objects.filter(
            teacher=OuterRef('pk'),
            is_paid=True
        ).values('teacher').annotate(
            total_earnings=Coalesce(Sum('price'), 0.0)
        ).values('total_earnings')

        dues_subquery = TeacherRecitationPricing.objects.filter(
            teacher=OuterRef('pk'),
            is_paid=False
        ).values('teacher').annotate(
            total_dues=Coalesce(Sum('price'), 0.0)
        ).values('total_dues')

        queryset = self.model.objects.annotate(
            total_recitations=Count('recitations_teacher'),
            accepted_recitations=Coalesce(
                Sum(Case(When(recitations_teacher__result='accepted', then=1), default=0)), 0),
            rejected_recitations=Coalesce(
                Sum(Case(When(recitations_teacher__result='rejected', then=1), default=0)), 0),
            reported_recitations=Coalesce(
                Sum(Case(When(recitations_teacher__result='reported', then=1), default=0)), 0),
            pending_recitations=Coalesce(
                Sum(Case(When(recitations_teacher__result__isnull=True, then=1), default=0)), 0),

            earnings=Subquery(earnings_subquery, output_field=FloatField()),
            dues=Subquery(dues_subquery, output_field=FloatField()),
        ).prefetch_related('teachernarration_set', 'teacherprofile')

        return queryset

    @swagger_auto_schema(
        operation_description="List all teachers.",
        responses={
            200: "Successful response with a list of teachers.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view teachers",
            404: "Not Found - teachers do not exist",
            "response_body": TeacherListSerializer
        },
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)


class AdminTeacherDetailAPIView(RetrieveAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    queryset = Teacher.objects.all()
    serializer_class = TeacherDetailSerializer
    filterset_class = TeacherFilter

    def get_required_permissions(self, request):
        if request.method == 'GET':
            return ["users.view_teacherprofile"]

    def get_queryset(self):
        earnings_subquery = TeacherRecitationPricing.objects.filter(
            teacher=OuterRef('pk'),
            is_paid=True
        ).values('teacher').annotate(
            total_earnings=Coalesce(Sum('price'), 0.0)
        ).values('total_earnings')

        dues_subquery = TeacherRecitationPricing.objects.filter(
            teacher=OuterRef('pk'),
            is_paid=False
        ).values('teacher').annotate(
            total_dues=Coalesce(Sum('price'), 0.0)
        ).values('total_dues')

        queryset = Teacher.objects.annotate(
            total_recitations=Count('recitations_teacher'),
            accepted_recitations=Coalesce(
                Sum(Case(When(recitations_teacher__result='accepted', then=1), default=0)), 0),
            rejected_recitations=Coalesce(
                Sum(Case(When(recitations_teacher__result='rejected', then=1), default=0)), 0),
            reported_recitations=Coalesce(
                Sum(Case(When(recitations_teacher__result='reported', then=1), default=0)), 0),
            pending_recitations=Coalesce(
                Sum(Case(When(recitations_teacher__result__isnull=True, then=1), default=0)), 0),

            earnings=Subquery(earnings_subquery, output_field=FloatField()),
            dues=Subquery(dues_subquery, output_field=FloatField()),
        ).prefetch_related('teachernarration_set', 'teacherprofile')

        return queryset

    @swagger_auto_schema(
        operation_description="List details of a specific teacher.",
        responses={
            200: "Successful response with a specific teacher.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view this teacher",
            404: "Not Found - teacher do not exist",
            "response_body": TeacherDetailSerializer
        },
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)


class AdminTeacherStudentsView(ListAPIView, DynamicPermissionRequiredMixin):
    serializer_class = StudentListSerializer
    filterset_class = StudentFilter
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_required_permissions(self, request):
        if request.method == 'GET':
            return ["users.view_teacherprofile"]

    def get_serializer_context(self):
        return {'request': self.request}

    def get_queryset(self):
        return Student.objects.filter(favorite_teacher_id=self.kwargs['teacher_id']).annotate(
            total_recitations=Count('id'),
            accepted_recitations=Coalesce(Sum(Case(When(recitations__result='accepted', then=1), default=0)), 0),
            rejected_recitations=Coalesce(Sum(Case(When(recitations__result='rejected', then=1), default=0)), 0),
            reported_recitations=Coalesce(Sum(Case(When(recitations__result='reported', then=1), default=0)), 0),
            pending_recitations=Coalesce(Sum(Case(When(recitations__result__isnull=True, then=1), default=0)), 0)
        )

    @swagger_auto_schema(
        operation_description="List students of a specific teacher.",
        responses={
            200: "Successful response with a List of students of specific teacher.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The admin is not authorized to view this teacher's student",
            404: "Not Found - teacher do not exist",
            "response_body": StudentListSerializer
        },
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)


class AdminTeacherAccountingView(ListAPIView, DynamicPermissionRequiredMixin):
    serializer_class = TeacherAccountingSerializer
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_required_permissions(self, request):
        if request.method == 'GET':
            return ["users.view_teacherprofile"]

    def get_queryset(self):
        queryset = TeacherRecitationPricing.objects.filter(teacher=self.kwargs.get("teacher_id"))
        return queryset

    @swagger_auto_schema(
        operation_description="List accounting of a specific teacher.",
        responses={
            200: "Successful response with accounting of a specific teacher.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The admin is not authorized to view this teacher's accounting",
            404: "Not Found - teacher do not exist",
            "response_body": TeacherAccountingSerializer
        },
    )
    def list(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        earnings = queryset.filter(is_paid=True).aggregate(total_earnings=Coalesce(Sum('price'), 0.0))['total_earnings']
        dues = queryset.filter(is_paid=False).aggregate(total_dues=Coalesce(Sum('price'), 0.0))['total_dues']
        queryset = self.filter_queryset(queryset)

        paginator = self.pagination_class()
        paginated_queryset = paginator.paginate_queryset(queryset, request)

        serializer = self.get_serializer(paginated_queryset, many=True)
        response_data = {
            'earnings': earnings,
            'dues': dues,
            'recitations': serializer.data
        }
        return paginator.get_paginated_response(response_data)


class AdminTeacherNarrationsView(ListAPIView, DynamicPermissionRequiredMixin):
    serializer_class = TeacherNarrationSerializer
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_queryset(self):
        return TeacherNarration.objects.filter(teacher_id=self.kwargs['teacher_id'])

    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)


class AdminTeacherRecitationsView(ListAPIView, DynamicPermissionRequiredMixin):
    serializer_class = TeacherRecitationsSerializer
    permission_classes = [IsAuthenticated, AdminPermissionRequired]

    def get_required_permissions(self, request):
        if request.method == 'GET':
            return ["users.view_teacherprofile"]

    def get_queryset(self):
        if self.kwargs.get("recitations") == "corrected_recitation":
            return Recitation.objects.filter(teacher_id=self.kwargs['teacher_id'])
        if self.kwargs.get("recitations") == "teacher_recitation":
            return Recitation.objects.filter(is_teacher_recitation=True, owner=self.kwargs['teacher_id'])
        if self.kwargs.get("recitations") == "recitation":
            return Recitation.objects.filter(is_teacher_recitation=False, owner=self.kwargs['teacher_id'])
        else:
            return Recitation.objects.none()

    @swagger_auto_schema(
        operation_description="List recitations of a specific teacher.",
        responses={
            200: "Successful response with a List of recitations of specific teacher.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view this teacher's recitations",
            404: "Not Found - teacher do not exist",
            "response_body": TeacherRecitationsSerializer,
        },
    )
    def get(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if queryset:

            total_recitations = queryset.aggregate(total_recitations=Count('id'))
            accepted_recitations = queryset.aggregate(accepted_recitations=Coalesce(
                Sum(Case(When(result='accepted', then=1), default=0)), 0))
            rejected_recitations = queryset.aggregate(rejected_recitations=Coalesce(
                Sum(Case(When(result='rejected', then=1), default=0)), 0))
            reported_recitations = queryset.aggregate(reported_recitations=Coalesce(
                Sum(Case(When(result='reported', then=1), default=0)), 0))
            pending_recitations = queryset.aggregate(pending_recitations=Coalesce(
                Sum(Case(When(result__isnull=True, then=1), default=0)), 0))

            queryset = self.filter_queryset(queryset)

            paginator = self.pagination_class()
            paginated_queryset = paginator.paginate_queryset(queryset, request)

            serializer = self.get_serializer(paginated_queryset, many=True)

            response_data = {
                'total_recitations': total_recitations['total_recitations'],
                'pending_recitations': pending_recitations['pending_recitations'],
                'accepted_recitations': accepted_recitations['accepted_recitations'],
                'rejected_recitations': rejected_recitations['rejected_recitations'],
                'reported_recitations': reported_recitations['reported_recitations'],
                'recitations': serializer.data
            }
            return paginator.get_paginated_response(response_data)
        else:
            return Response({'message': 'No recitations found for the given parameters'}, status=404)
