from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.generics import RetrieveAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.authz.permissions import DynamicPermissionRequiredMixin, AdminPermissionRequired
from apps.khatma.models import Khatma, KhatmaUsers
from apps.khatma.serializers.serializers_admin_api_v1.serializers import KhatmaDetailsSerializer, \
    UserProgresskhatmaSerializer, UserProgressKhatamatSerializer


class KhatmaDetailAPIView(RetrieveAPIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["khatma.view_khatma"]

    @swagger_auto_schema(
        operation_description="Return Khatma Details.",
        responses={
            200: "Successful response.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view Khatma Details",
            404: "Not Found - Khatma does not exist",
        }
    )
    def get_required_permissions(self, request):
        if request.method == 'GET':
            return ["khatma.view_khatma"]
        return super().get_required_permissions(request)

    queryset = Khatma.objects.all()
    serializer_class = KhatmaDetailsSerializer
    lookup_field = 'id'


class UserProgressKhatamatAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["khatma.view_khatma"]

    @swagger_auto_schema(
        operation_description="Return Progress Khatma Result for user.",
        responses={
            200: "Successful response.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view students",
            404: "Not Found - Students or progress does not exist",
        }
    )
    def get(self, request, user_id):
        queryset = KhatmaUsers.objects.filter(user_id=user_id)
        queryset = UserProgressKhatamatSerializer.setup_eager_loading(queryset)
        queryset = UserProgressKhatamatSerializer.annotate_progress(queryset)

        serializer = UserProgressKhatamatSerializer(queryset, many=True)

        data = {
            'khatma_count': Khatma.objects.count(),
            'total_khatma_user': queryset.count(),
            'khatma_progress': serializer.data,
        }

        return Response(data)


class UserProgresskhatmaAPIView(APIView, DynamicPermissionRequiredMixin):
    permission_classes = [IsAuthenticated, AdminPermissionRequired]
    required_permissions = ["khatma.view_khatma"]

    @swagger_auto_schema(
        operation_description="Return Progress Khatma Result for user and khatma.",
        responses={
            200: "Successful response.",
            401: "Unauthorized - The user is Unauthorized",
            403: "Forbidden - The user is not authorized to view progress Khatma Result",
            404: "Not Found - Students or progress does not exist",
        }
    )
    def get(self, request, user_id, khatma_id):
        queryset = KhatmaUsers.objects.filter(user_id=user_id, khatma_id=khatma_id)

        if not queryset.exists():
            return Response(
                {"error": f"This user (ID: {user_id}) does not have progress for khatma (ID: {khatma_id})."},
                status=status.HTTP_404_NOT_FOUND)
        queryset = UserProgresskhatmaSerializer.setup_eager_loading(queryset)
        queryset = UserProgresskhatmaSerializer.annotate_progress(queryset)

        serializer = UserProgresskhatmaSerializer(queryset, many=True)
        return Response(serializer.data)
