from django.db.models import Count, Q
from django.shortcuts import get_object_or_404
from django.utils.translation import gettext as _
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.generics import ListAPIView, DestroyAPIView, RetrieveAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.authz.permissions import DynamicPermissionRequiredMixin, AdminPermissionRequired
from apps.recitations import config
from apps.recitations.api.v2.filters_api_v2 import RecitationFilter
from apps.recitations.api.v2.serializers import AdminReportedRecitationsSerializer
from apps.recitations.models import Recitation
from apps.recitations.models.report import UserRecitationReport
from apps.recitations.serializers.serializers_admin_api_v1.serializers import AdminRecitationSerializer, \
    AdminRecitationDetailsSerializer


class AdminRecitationReportsAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["recitation.view_any_recitation"]

    @swagger_auto_schema(
        operation_description="Return Reported Recitation.",
        tags=["Recitations: Recitations"],
        responses={
            200: "Successful Data Response.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view Reported Recitations",
        }
    )
    def get(self, request):
        reported_recitations = UserRecitationReport.objects.values_list('recitation', flat=True).distinct()
        recitations = Recitation.objects.filter(id__in=reported_recitations)
        serializer = AdminReportedRecitationsSerializer(recitations, many=True, context={'request': request})
        return Response(serializer.data)


class RecitationsListAPIView(ListAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["recitation.view_any_recitation"]
    model = Recitation
    filterset_class = RecitationFilter
    serializer_class = AdminRecitationSerializer

    def get_required_permissions(self, request):
        if request.method == 'GET':
            return ["recitation.view_any_recitation"]
        return super().get_required_permissions(request)

    @swagger_auto_schema(
        operation_description="List all recitations.",
        responses={
            200: "Successful response with a list of Recitations.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view students",
        },
    )
    def get_queryset(self):
        return Recitation.objects.all()

    def list(self, request, *args, **kwargs):
        queryset = self.filter_queryset(self.get_queryset())

        recitations_aggregate = queryset.aggregate(
            total_recitations=Count('id'),
            is_remarkable=Count('id', filter=Q(is_remarkable=True)),
            accepted_recitations=Count('id', filter=Q(result=config.RECITATIONS_RESULT_ACCEPTED)),
            rejected_recitations=Count('id', filter=Q(result=config.RECITATIONS_RESULT_REJECTED)),
            pending_recitations=Count('id', filter=Q(result=config.RECITATIONS_RESULT_PENDING)),
            tajweed_recitations=Count('id', filter=Q(tajweed_lesson_example__isnull=False)),
            khatma_recitations=Count('id', filter=Q(khatma__isnull=False)),
        )
        serializer = self.get_serializer(queryset, many=True)

        response_data = {
            'Total Recitations': recitations_aggregate['total_recitations'],
            'Corrected Recitations': recitations_aggregate['accepted_recitations'],
            'Rejected Recitations': recitations_aggregate['rejected_recitations'],
            'Pending Recitations': recitations_aggregate['pending_recitations'],
            'Is Remarkable Recitations': recitations_aggregate['is_remarkable'],
            'Tajweed Recitations': recitations_aggregate['tajweed_recitations'],
            'Khatma Recitations': recitations_aggregate['khatma_recitations'],
            'results': serializer.data
        }

        return Response(response_data)

    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)


class RecitationDeleteAPIView(DestroyAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["recitation.delete_recitation"]
    queryset = Recitation.objects.all()

    def get_required_permissions(self, request):
        if request.method == 'GET':
            return ["recitation.delete_recitation"]
        return super().get_required_permissions(request)

    @swagger_auto_schema(
        operation_description="Delete a recitation.",
        responses={
            200: "Recitation deleted successfully.",
            401: "Unauthorized - The user is Unauthorized.",
            403: "Forbidden: Can't delete student recitation.",
            404: "Recitation Not Found"
        },
    )
    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        if not instance.owner.is_a_teacher:
            return Response({"detail": _("Can't delete student recitation!")}, status=status.HTTP_403_FORBIDDEN)
        self.perform_destroy(instance)
        return Response({"detail": _("Teacher recitation deleted successfully!")}, status=status.HTTP_200_OK)


class RecitationDetailAPIView(RetrieveAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["recitation.view_any_recitation"]
    queryset = Recitation.objects.all()
    serializer_class = AdminRecitationDetailsSerializer

    def get_required_permissions(self, request):
        if request.method == 'GET':
            return ["recitation.view_any_recitation"]
        return super().get_required_permissions(request)

    @swagger_auto_schema(
        operation_description="Retrieve recitation details by ID.",
        responses={
            200: "Successful response with recitation details.",
            401: "Unauthorized - The user is not authorized",
            403: "Forbidden - The user is not authorized to view this recitation",
            404: "Not Found - The recitation does not exist",
        },
    )
    def get(self, request, pk):
        recitation = get_object_or_404(Recitation, pk=pk)
        serializer = self.get_serializer(recitation)
        return Response(serializer.data, status=status.HTTP_200_OK)
