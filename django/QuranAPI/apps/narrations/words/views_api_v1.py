from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.narrations.models import Word
from apps.narrations.words.filters import WordAPIFilter
from apps.narrations.words.serializers import WordSerializer


class WordsListingAPIView(APIView):
    permission_classes = [TokenHasReadWriteScope]

    def get(self, request, narration_id, *args, **kwargs):
        verses = WordAPIFilter(request.GET, Word.objects.filter(narration_id=narration_id))
        serializer = WordSerializer(verses.qs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
