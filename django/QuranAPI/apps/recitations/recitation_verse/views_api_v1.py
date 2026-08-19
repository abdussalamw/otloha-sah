from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.recitations.models import RecitationVerse
from apps.recitations.recitation_verse.filters import RecitationVerseFilter
from apps.recitations.recitation_verse.serializers_v1 import RecitationVerseSerializer


class RecitationVerseListingView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        queryset = RecitationVerseFilter(request.GET, RecitationVerse.objects.all()).qs
        serializer = RecitationVerseSerializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class RecitationVerseDetailsView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, recitation_verse_id):
        recitation_verse = get_object_or_404(RecitationVerse, pk=recitation_verse_id)
        serializer = RecitationVerseSerializer(recitation_verse)
        return Response(serializer.data, status=status.HTTP_200_OK)
