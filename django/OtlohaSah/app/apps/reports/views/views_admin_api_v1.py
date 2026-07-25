from django.db.models import Count, When, Case, Sum, F, IntegerField, FloatField
from django.db.models.functions import Coalesce
from drf_yasg.utils import swagger_auto_schema
from rest_framework.generics import ListAPIView
from rest_framework.permissions import IsAuthenticated

from apps.authz.permissions import AdminPermissionRequired, DynamicPermissionRequiredMixin
from apps.reports.filters import TeacherAccountingFilterSet
from apps.reports.serializers import TeacherReportListSerializer
from apps.users.models import Teacher, TeacherRecitationPricing


class AdminTeacherAccountingReportsListAPIView(ListAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    serializer_class = TeacherReportListSerializer
    model = Teacher
    filterset_class = TeacherAccountingFilterSet

    def get_required_permissions(self, request):
        if request.method == 'GET':
            return ["users.view_teacher"]

    def get_queryset(self):
        queryset = Teacher.objects.annotate(
            total_earnings=Coalesce(
                Sum(Case(When(
                    teacherrecitationpricing__is_paid=True,
                    then=F('teacherrecitationpricing__price')),
                    default=0.0)), 0.0),
            total_dues=Coalesce(
                Sum(Case(When(
                    teacherrecitationpricing__is_paid=False,
                    then=F('teacherrecitationpricing__price')),
                    default=0.0)), 0.0),
            paid_recitation_count=Count(Case(When(
                teacherrecitationpricing__is_paid=True,
                then=1
            ), output_field=IntegerField())),
            unpaid_recitation_count=Count(Case(When(
                teacherrecitationpricing__is_paid=False,
                then=1
            ), output_field=IntegerField())),
        )
        return queryset

    @swagger_auto_schema(
        operation_description="List all students.",
        responses={
            200: "Successful response with a list of teachers' accounting.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view teachers' accounting",
            404: "Not Found - teachers' accounting do not exist",
            "response_body": TeacherReportListSerializer
        },
    )
    def get(self, request, *args, **kwargs):
        queryset = self.get_queryset()
        if queryset.exists():
            total_earnings = TeacherRecitationPricing.objects.aggregate(
                total_earnings=Coalesce(
                    Sum(Case(When(is_paid=True, then=F('price')),
                             default=0.0,
                             output_field=FloatField())), 0.0))['total_earnings']

            total_dues = TeacherRecitationPricing.objects.aggregate(
                total_dues=Coalesce(
                    Sum(Case(When(is_paid=False, then=F('price')),
                             default=0.0,
                             output_field=FloatField())), 0.0))['total_dues']
        else:
            total_earnings = 0.0
            total_dues = 0.0

        queryset = self.filter_queryset(queryset)

        paginator = self.pagination_class()
        paginated_queryset = paginator.paginate_queryset(queryset, request, view=self)

        serializer = self.get_serializer(paginated_queryset, many=True)

        response_data = {
            'total_earnings': round(total_earnings, 2),
            'total_dues': round(total_dues, 2),
            'recitations': serializer.data
        }

        return paginator.get_paginated_response(response_data)
