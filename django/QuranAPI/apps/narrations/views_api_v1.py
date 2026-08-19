from django.http import FileResponse
from django.shortcuts import get_object_or_404
from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.narrations.filters import NarrationAPIFilter
from apps.narrations.models import Narration
from apps.narrations.serializers import NarrationSerializer


class NarrationsListView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        narrations = NarrationAPIFilter(request.GET, Narration.objects.filter(is_active=True))
        serializer = NarrationSerializer(narrations.qs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class NarrationsDetailView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, narration_pk, *args, **kwargs):
        narration = get_object_or_404(Narration, pk=narration_pk)
        serializer = NarrationSerializer(narration)
        return Response(serializer.data, status=status.HTTP_200_OK)


class DownloadNarrationView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, narration_pk, *args, **kwargs):
        narration = get_object_or_404(Narration, pk=narration_pk)

        file_handle = narration.json_file.open()

        response = FileResponse(file_handle, content_type='file/json')
        response['Content-Length'] = narration.json_file.size
        response['Content-Disposition'] = 'attachment; filename="%s"' % narration.json_file.name

        return response
