from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.narrations.models import Verse
from apps.narrations.verses.filters import VerseAPIFilter
from apps.narrations.verses.serializers import VerseSerializer


class VersesListAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, narration_id, *args, **kwargs):
        verses = VerseAPIFilter(request.GET, Verse.objects.filter(narration_id=narration_id))
        serializer = VerseSerializer(verses.qs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
