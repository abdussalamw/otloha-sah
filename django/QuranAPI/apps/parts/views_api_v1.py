from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.parts.filters import PartAPISearch
from apps.parts.models import Part
from apps.parts.serializers import PartSerializer


class PartsListAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        part = PartAPISearch(request.GET, Part.objects.filter(is_active=True)).qs
        serializer = PartSerializer(part, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class PartDetailAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, part_id):
        part = get_object_or_404(Part, pk=part_id)
        serializer = PartSerializer(part)
        return Response(serializer.data, status=status.HTTP_200_OK)
