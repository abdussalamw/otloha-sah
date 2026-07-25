from django.db.models import Count, Q
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.recitations import config
from apps.recitations.api.v2.serializers import StatisticSerializer, RecitationProgressSerializer
from apps.recitations.models import Recitation


class UserStatisticAPIView(APIView):
    permission_classes = [IsAuthenticated]
    serializer_class = StatisticSerializer

    @swagger_auto_schema(
        operation_description="Return Recitations Statistics by narration for user.",
        responses={
            200: "Successful response.",
            401: "Unauthorized - The user is not authorized.",
            403: "Forbidden - The user does not have permission.",
        }
    )
    def get(self, request, narration_id):
        recitations = Recitation.objects.filter(narration_id=narration_id, owner=request.user)
        stats = recitations.aggregate(
            accepted_count=Count('id', filter=Q(result=config.RECITATIONS_RESULT_ACCEPTED)),
            rejected_count=Count('id', filter=Q(result=config.RECITATIONS_RESULT_REJECTED)),
            pending_count=Count('id', filter=Q(result=config.RECITATIONS_RESULT_PENDING)),
            total_count=Count('id')
        )

        data = {
            "narration_id": narration_id,
            "accepted_recitations": stats['accepted_count'],
            "rejected_recitations": stats['rejected_count'],
            "pending_recitations": stats['pending_count'],
            "number_of_recitations": stats['total_count'],
            "percentage": (stats['accepted_count'] / 6236) * 100,
        }

        serializer = self.serializer_class(data=data)
        if serializer.is_valid():
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class RecitationProgressAPIView(APIView):
    permission_classes = [IsAuthenticated]
    serializer_class = RecitationProgressSerializer

    @swagger_auto_schema(
        operation_description="Return Recitations progress by narration and chapter for user.",
        responses={
            200: "Successful response.",
            401: "Unauthorized - The user is not authorized.",
            403: "Forbidden - The user does not have permission.",
        }
    )
    def get(self, request, narration_id, chapter_id):
        user = request.user

        recitations = Recitation.objects.filter(
            narration_id=narration_id,
            chapter_id=chapter_id,
            owner=user
        )

        accepted_verses = recitations.filter(result=config.RECITATIONS_RESULT_ACCEPTED).values_list('verses__id',
                                                                                                    flat=True)
        rejected_verses = recitations.filter(result=config.RECITATIONS_RESULT_REJECTED).values_list('verses__id',
                                                                                                    flat=True)
        pending_verses = recitations.filter(result=config.RECITATIONS_RESULT_PENDING).values_list('verses__id',
                                                                                                  flat=True)

        data = {
            "pending": {
                chapter_id: list(pending_verses)
            },
            "accepted": {
                chapter_id: list(accepted_verses)
            },
            "rejected": {
                chapter_id: list(rejected_verses)
            }
        }

        serializer = self.serializer_class(data=data)
        if serializer.is_valid():
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
