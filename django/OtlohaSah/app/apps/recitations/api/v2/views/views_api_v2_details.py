from django.shortcuts import get_object_or_404
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.generics import RetrieveAPIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from apps.recitations.models import Recitation
from apps.recitations.api.v2.serializers import BaseRecitationSerializer


class RecitationDetailAPIView(RetrieveAPIView):
    permission_classes = [IsAuthenticated]
    queryset = Recitation.objects.all()
    serializer_class = BaseRecitationSerializer

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
