from django.utils.timezone import now
from django.utils.translation import gettext as _
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.exceptions import PermissionDenied
from rest_framework.generics import get_object_or_404
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.recitations import config
from apps.recitations.api.v2.utils import update_user_recitation_progress
from apps.recitations.models import Recitation, Evaluation
from apps.recitations.notifications import RecitationRoomCreatedNotification
from apps.recitations.api.v2.serializers import EvaluationSerializer, RecitationRateSerializer, \
    RecitationAssignSerializer, FinishEvaluationSerializer

from apps.users.permissions import IsATeacherPermission


class FinishEvaluationAPIView(APIView):
    permission_classes = [IsAuthenticated, IsATeacherPermission]

    @swagger_auto_schema(
        operation_description="Finish Evaluation.",
        request_body=openapi.Schema(
            type=openapi.TYPE_OBJECT,
            required=['result'],
            properties={
                'result': openapi.Schema(type=openapi.TYPE_STRING),
                'teacher_rate': openapi.Schema(type=openapi.TYPE_INTEGER),
                'is_remarkable': openapi.Schema(type=openapi.TYPE_BOOLEAN),
            },
        ),
        responses={
            200: "Successful response with a EvaluationSerializer object.",
            422: "Unprocessable Entity  - The request data is invalid.",
        }
    )
    def post(self, request, pk):
        recitation = get_object_or_404(Recitation, pk=pk)
        serializer = FinishEvaluationSerializer(
            data=request.data,
            context={'recitation': recitation, 'user': request.user},

        )
        if serializer.is_valid():
            self.update_recitation(recitation, serializer.validated_data)
            return Response({"message": _("Recitation evaluated successfully")}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)

    def update_recitation(self, recitation, validated_data):
        recitation.evaluating = True
        recitation.evaluated_at = now()
        recitation.result = validated_data['result']
        teacher_rate = validated_data.get('teacher_rate')
        if teacher_rate is not None:
            recitation.teacher_rate = teacher_rate
        update_user_recitation_progress(
            user_id=recitation.owner.pk,
            narration_id=recitation.narration.pk)
        recitation.save()


class RateTeacherResponseAPIView(APIView):
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(
        operation_description="Rate Teacher Response.",
        request_body=openapi.Schema(
            type=openapi.TYPE_OBJECT,
            required=['owner_rate'],
            properties={
                'owner_rate': openapi.Schema(type=openapi.TYPE_NUMBER),
                'owner_review': openapi.Schema(type=openapi.TYPE_STRING),
            },
        ),
        responses={
            200: "Successful response, Rated Successfully.",
            422: "Unprocessable Entity - The request data is invalid.",
        }
    )
    def post(self, request, recitation_id, *args, **kwargs):
        recitation = get_object_or_404(Recitation, pk=recitation_id)
        serializer = RecitationRateSerializer(data=request.data, instance=recitation, user=request.user)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": _("Conversation Rated Successfully!")}, status=status.HTTP_200_OK)

        return Response({"errors": serializer.errors}, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class CreateEvaluationAPIView(APIView):
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(
        operation_description="Create a new evaluation.",
        request_body=EvaluationSerializer,
        responses={
            201: EvaluationSerializer,
            400: "Bad Request - Invalid input data.",
            401: "Unauthorized - The user is not authorized.",
            404: "Not Found - The resource does not exist.",
        }
    )
    def post(self, request, pk, *args, **kwargs):
        recitation = get_object_or_404(Recitation, id=pk)
        serializer = EvaluationSerializer(data=request.data,
                                          context={'recitation': recitation, 'user': request.user})

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class EditEvaluationAPIView(APIView):
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(
        operation_description="Edit an evaluation by recitation_id.",
        request_body=EvaluationSerializer,
        responses={
            200: EvaluationSerializer,
            401: "Unauthorized - The user is not authorized.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The resource does not exist.",
        }
    )
    def put(self, request, pk, *args, **kwargs):
        recitation = get_object_or_404(Recitation, id=pk)
        evaluation = get_object_or_404(Evaluation, recitation=recitation)
        serializer = EvaluationSerializer(
            evaluation,
            data=request.data,
            partial=True,
            context={'user': request.user, 'recitation': recitation}
        )

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class DeleteEvaluationAPIView(APIView):
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(
        operation_description="Delete an evaluation by recitation_id.",
        responses={
            200: "Evaluation successfully deleted.",
            401: "Unauthorized - The user is not authorized.",
            403: "Forbidden - The user does not have permission.",
            404: "Not Found - The resource does not exist.",
        }
    )
    def delete(self, request, pk, *args, **kwargs):
        recitation = get_object_or_404(Recitation, id=pk)
        evaluation = get_object_or_404(Evaluation, recitation=recitation)

        if request.user != recitation.teacher:
            return Response({'error': "You are not authorized to perform this action"},
                            status=status.HTTP_403_FORBIDDEN)
        if recitation.is_closed:
            return Response({'error': "Recitation Is Closed"}, status=status.HTTP_400_BAD_REQUEST)

        evaluation.delete()
        return Response({'message': "Evaluation successfully deleted"}, status=status.HTTP_200_OK)


class RecitationAssignAPIView(APIView):
    permission_classes = (IsAuthenticated, IsATeacherPermission)

    @swagger_auto_schema(
        operation_description="Assign a recitation to a teacher.",
        responses={
            201: "Assign a recitation to a teacher successfully.",
            401: "Unauthorized - The user is not authorized.",
            422: "Unprocessable Entity - Invalid data provided."
        }
    )
    def post(self, request, pk, *args, **kwargs):
        recitation = get_object_or_404(Recitation, pk=pk)
        serializer = RecitationAssignSerializer(data=request.data,
                                                context={'user': request.user, 'recitation': recitation})
        if serializer.is_valid():
            serializer.update(recitation, serializer.validated_data)

            notification_class = RecitationRoomCreatedNotification
            recitation.notify(notification_class, sender=request.user, receivers=[recitation.owner])

            response_data = serializer.data
            response_data['message'] = _(
                "Recitation has been successfully assigned to you for evaluation.")

            return Response(response_data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)


class EvaluationListAPIView(APIView):
    permission_classes = [IsAuthenticated]

    @swagger_auto_schema(
        operation_description="Retrieve a list of evaluations.",
        responses={
            200: EvaluationSerializer(many=True),
            403: "Forbidden - You do not have permissions to view evaluations.",
            404: "Not Found - The resource does not exist.",
        }
    )
    def get(self, request, pk, *args, **kwargs):
        recitation = get_object_or_404(
            Recitation.objects.prefetch_related('evaluation_set', 'owner', 'owner__connections', ),
            id=pk)

        if (
                not request.user == recitation.owner.favorite_teacher_id
                and not request.user in recitation.owner.connections.all()
                and not Recitation.objects.filter(owner=recitation.owner, teacher=request.user,
                                                  result=config.RECITATIONS_RESULT_PENDING).exists()
        ):
            raise PermissionDenied()

        serializer = EvaluationSerializer(recitation.evaluation_set.all(), many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
