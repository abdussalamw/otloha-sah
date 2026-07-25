from django.utils.translation import gettext as _
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.exceptions import PermissionDenied
from rest_framework.generics import CreateAPIView, UpdateAPIView, get_object_or_404, DestroyAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.recitations import config
from apps.recitations.api.v2.serializers import RecitationCreateSerializer, RecitationUpdateSerializer, \
    RecitationTargetSerializer
from apps.recitations.api.v2.utils import update_user_recitation_progress
from apps.recitations.models import Recitation
from apps.recitations.notifications import UserRecitationDeletedSuccessfullyNotification


class RecitationCreateAPIView(CreateAPIView):
    serializer_class = RecitationCreateSerializer
    permission_classes = [IsAuthenticated, ]

    @swagger_auto_schema(
        operation_summary="Create a new recitation.",
        operation_description="Create a new recitation.",
        request_body=RecitationCreateSerializer,
        tags=["Recitations: Actions"],
        responses={
            201: openapi.Response(description="Successfully created the new recitation."),
            401: openapi.Response(description="Unauthorized - The user is not authorized."),
            422: openapi.Response(description="Unprocessable Entity - Validation errors.")
        }
    )
    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data, context={'request': request})

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class RecitationToggleActionAPIView(APIView):
    permission_classes = [IsAuthenticated, ]

    @swagger_auto_schema(
        operation_summary="Target to be updated (favorite_teacher, box, remarkable).",
        operation_description="Target to be updated (favorite_teacher, box, remarkable).",
        tags=["Recitations: Actions"],
        responses={
            200: openapi.Response(description="Successfully updated the recitation target."),
            401: openapi.Response(description="Unauthorized - The user is not authorized."),
            403: openapi.Response(description="Forbidden - The user does not have permission."),
            404: openapi.Response(description="Recitation not found."),
            422: openapi.Response(description="Unprocessable Entity - Validation errors.")
        }
    )
    def patch(self, request, pk, target):
        recitation = get_object_or_404(Recitation, pk=pk)
        serializer = RecitationTargetSerializer(
            recitation, data={'target': target}, partial=True, context={'request': request}
        )
        if serializer.is_valid():
            data = serializer.save()
            response_data = {
                'message': data['message']
            }
            return Response(response_data)

        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class RecitationUpdateAPIView(UpdateAPIView):
    serializer_class = RecitationUpdateSerializer
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(
        operation_summary="Update the recitation's record field.",
        operation_description="Update the recitation's record field. Only the owner of the recitation can perform this action.",
        tags=["Recitations: Actions"],
        responses={
            200: openapi.Response(description="Successfully updated the recitation record."),
            401: openapi.Response(description="Unauthorized - The user is not authorized."),
            403: openapi.Response(description="Forbidden - The user does not have permission."),
            404: openapi.Response(description="Recitation not found."),
            422: openapi.Response(description="Unprocessable Entity - Validation errors.")
        }
    )
    def update(self, request, *args, **kwargs):
        instance = get_object_or_404(Recitation, pk=kwargs.get('pk'))
        if self.request.user != instance.owner:
            raise PermissionDenied(
                _('You are not the owner of this recitation; you are not allowed to perform this action!'))

        serializer = self.get_serializer(instance, context={'pk': instance}, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class RecitationDeleteAPIView(DestroyAPIView):
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        queryset = Recitation.objects.filter(owner=user)
        return queryset

    @swagger_auto_schema(
        operation_summary="Delete the recitation.",
        operation_description="Delete the recitation. Only the owner of the recitation can perform this action.",
        tags=["Recitations: Actions"],
        responses={
            204: openapi.Response(description="Successfully deleted the recitation."),
            401: openapi.Response(description="Unauthorized - The user is not authorized."),
            403: openapi.Response(description="Forbidden - The user does not have permission."),
            404: openapi.Response(description="Recitation not found."),
        }
    )
    def destroy(self, request, *args, **kwargs):
        instance = get_object_or_404(Recitation, pk=kwargs['pk'])

        if self.has_permission_delete_recitation(instance, request.user):
            data = {
                "user_id": instance.owner.pk,
                "narration_id": instance.narration,
            }
            instance.notify(UserRecitationDeletedSuccessfullyNotification, sender=instance)

            instance.delete()
            update_user_recitation_progress(**data)
            return Response(status=status.HTTP_204_NO_CONTENT)

        return Response({"error": "You are not allowed to delete this recitation."},
                        status=status.HTTP_403_FORBIDDEN)

    def has_permission_delete_recitation(self, instance, user):
        is_owner = instance.owner == user
        is_teacher_recitation = user.is_a_teacher and (
                instance.khatma is None and instance.tajweed_lesson_example is None)

        is_general_recitation = (
                instance.teacher is None
                and instance.result in [config.RECITATIONS_RESULT_PENDING, config.RECITATIONS_RESULT_REJECTED]
        )
        return is_owner and (is_teacher_recitation or is_general_recitation)
