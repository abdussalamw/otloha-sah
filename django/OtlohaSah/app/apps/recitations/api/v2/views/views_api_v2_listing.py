from django.db.models import Q
from django.utils.translation import gettext as _
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.generics import ListAPIView, get_object_or_404
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from apps.recitations.api.v2.filters_api_v2 import (
    MyEvaluationsFilter, MyRecitationFilter,
    TeacherRecitationFilter, KhatmaRecitationFilter,
    GeneralRecitationFilter, RemarkableRecitationFilter,
    UserRecitationFilter
)
from apps.recitations.api.v2.serializers import (
    UserRecitationListSerializer, KhatmaRecitationSerializer,
    BaseRecitationSerializer, GeneralRecitationSerializer,
    TeacherRecitationSerializer
)
from apps.recitations.models import Recitation
from apps.users.models import User
from apps.users.permissions import IsATeacherPermission


class TeachersRecitationsBoxAPIView(ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = TeacherRecitationSerializer
    filterset_class = TeacherRecitationFilter

    @swagger_auto_schema(
        operation_description="Retrieve teachers recitations.",
        responses={
            200: "Successful retrieval of recitations.",
            401: "Unauthorized - The user is not authorized.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The resource does not exist.",
        }
    )
    def get_queryset(self):
        return Recitation.objects.certified_teachers(
            self.request.user
        ).order_by('-created_at').distinct()


class GeneralRecitationsAPIView(ListAPIView):
    permission_classes = [IsAuthenticated, IsATeacherPermission]
    serializer_class = GeneralRecitationSerializer
    filterset_class = GeneralRecitationFilter

    @swagger_auto_schema(
        operation_description="Retrieve general recitations for teachers",
        responses={
            200: "Successful retrieval of recitations.",
            401: "Unauthorized - The user is not authorized.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The resource does not exist.",
        }
    )
    def get_queryset(self):
        return Recitation.objects.general(
            self.request.user
        ).order_by('-created_at').distinct()

    def get_serializer_context(self):
        context = super().get_serializer_context()
        context['user'] = self.request.user
        return context


class RemarkableRecitationsAPIView(ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = BaseRecitationSerializer
    filterset_class = RemarkableRecitationFilter

    @swagger_auto_schema(
        operation_description="Retrieve Remarkable Recitations",
        responses={
            200: "Successful retrieval of recitations.",
            401: "Unauthorized - The user is not authorized.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The resource does not exist.",
        }
    )
    def get_queryset(self):
        return Recitation.objects.user_remarkable(
            self.request.user
        ).order_by('-created_at').distinct()


class KhatmaRecitationsBoxAPIView(ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = KhatmaRecitationSerializer
    filterset_class = KhatmaRecitationFilter

    @swagger_auto_schema(
        operation_description="Retrieve recitations for a specific Khatma, Show only for khatma users ",
        responses={
            200: "Successful retrieval of recitations.",
            401: "Unauthorized - The user is not authorized.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The resource does not exist.",
        }
    )
    def get_queryset(self):
        return Recitation.objects.khatma_users(
            user=self.request.user,
            khatma=self.kwargs.get('khatma_id')
        ).order_by(
            '-created_at').distinct()


class MyRecitationsAPIView(ListAPIView):
    permission_classes = [IsAuthenticated]
    serializer_class = BaseRecitationSerializer
    filterset_class = MyRecitationFilter

    @swagger_auto_schema(
        operation_description="Retrieve recitations owned by the authenticated user",
        responses={
            200: "Successful retrieval of recitations.",
            401: "Unauthorized - The user is not authorized.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The resource does not exist.",
        }
    )
    def get_queryset(self):
        return Recitation.objects.filter(
            owner=self.request.user
        ).order_by('-created_at').distinct()


class MyEvaluationsAPIView(ListAPIView):
    permission_classes = [IsAuthenticated, IsATeacherPermission]
    filterset_class = MyEvaluationsFilter
    serializer_class = BaseRecitationSerializer

    @swagger_auto_schema(
        operation_description="Retrieve evaluations performed by the authenticated teacher",
        responses={
            200: "Successful retrieval of evaluations.",
            401: "Unauthorized - The user is not authorized.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The resource does not exist.",
        }
    )
    def get_queryset(self):
        return Recitation.objects.filter(
            teacher=self.request.user,
        ).distinct()


class RecitationsUserListAPIView(ListAPIView):
    serializer_class = UserRecitationListSerializer
    filterset_class = UserRecitationFilter

    @swagger_auto_schema(
        operation_description="Retrieve recitations for a specific user",
        responses={
            200: "Successful retrieval of recitations.",
            401: "Unauthorized - The user is not authorized.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The resource does not exist.",
        }
    )
    def get_queryset(self):
        user = self.request.user
        owner = get_object_or_404(User, id=self.kwargs.get('user'))
        entity_id = self.request.headers.get('X-Entity-Id')

        recitations = Recitation.objects.filter(
            khatma__isnull=True,
            owner=owner,
        ).distinct().filter_by_gender_settings(
            user, 'display_general_box_recitations_to_opposite_gender'
        )
        if user.gender != owner.gender and not owner.allow_cross_gender_view:
            return Response({
                "message": _("You are not allow to view this section")
            }, status=status.HTTP_403_FORBIDDEN)

        if ((owner.is_a_teacher and user.is_a_teacher) or
                (owner.is_a_teacher) or
                (owner.connections.filter(id=user.id).exists() or
                 user.is_owner_of_entity(entity_id) or
                 user.is_moderator_of_entity(entity_id))):
            return recitations
        if user.is_a_teacher:
            return recitations.filter(
                Q(owner__favorite_teacher=user) |
                Q(teacher=user)
            )
        return Recitation.objects.none()
