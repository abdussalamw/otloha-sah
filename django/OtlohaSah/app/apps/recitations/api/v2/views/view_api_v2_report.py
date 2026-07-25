from django.shortcuts import get_object_or_404
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.generics import ListAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.recitations.api.v2.serializers import UserRecitationReportSerializer, \
    ReportReasonSerializer
from apps.recitations.models import Recitation
from apps.recitations.models.report import ReportReason


class UserRecitationReportAPIView(APIView):
    permission_classes = [IsAuthenticated, ]

    @swagger_auto_schema(
        operation_description="Create Report For User.",
        request_body=openapi.Schema(
            type=openapi.TYPE_OBJECT,
            required=['reason_text'],
            properties={
                'reason_text': openapi.Schema(type=openapi.TYPE_STRING),
            },
        ),
        responses={
            201: "Successful response with a UserRecitationReport object.",
            400: "Bad request - The request data is invalid.",
        }
    )
    def post(self, request, pk, *args, **kwargs):
        recitation = get_object_or_404(Recitation, id=pk)

        serializer = UserRecitationReportSerializer(data=request.data,
                                                    context={'recitation': recitation, 'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ReportReasonListAPIView(ListAPIView):
    queryset = ReportReason.objects.all()
    serializer_class = ReportReasonSerializer
    permission_classes = [IsAuthenticated]
    pagination_class = None
    @swagger_auto_schema(
        operation_description="List all report reasons.",
        responses={
            200: openapi.Response(description="A list of report reasons.", ),
            401: openapi.Response(description="Unauthorized - The user is not authorized.")
        }
    )
    def get(self, request, *args, **kwargs):
        return super().get(request, *args, **kwargs)
