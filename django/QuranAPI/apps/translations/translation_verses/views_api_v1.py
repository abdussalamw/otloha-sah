from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.translations.filters import TranslationVerseAPISearch
from apps.translations.models import TranslationVerse, Translation
from apps.translations.serializers import TranslationVerseSerializer


class TranslationVersesListAPIView(APIView):
    permission_classes = [TokenHasReadWriteScope]

    def get(self, request, translation_id, *args, **kwargs):
        translation = get_object_or_404(Translation, pk=translation_id)
        translation_verse = TranslationVerseAPISearch(request.GET, translation.translationverse_set.all())
        serializer = TranslationVerseSerializer(translation_verse.qs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class TranslationVersesDetailsAPIView(APIView):
    permission_classes = [TokenHasReadWriteScope]

    def get(self, request, translation_id, translation_verse_id, *args, **kwargs):
        get_object_or_404(Translation, pk=translation_id)
        translation_verse = get_object_or_404(TranslationVerse, pk=translation_verse_id)
        serializer = TranslationVerseSerializer(translation_verse)
        return Response(serializer.data, status=status.HTTP_200_OK)
