from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.translations.filters import TranslationAPISearch
from apps.translations.models import Translation
from apps.translations.serializers import TranslationSerializer


class TranslationsListAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        translation = TranslationAPISearch(request.GET, Translation.objects.all())
        serializer = TranslationSerializer(translation.qs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class TranslationsDetailsAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, translation_id):
        translation = get_object_or_404(Translation, pk=translation_id)
        serializer = TranslationSerializer(translation)
        return Response(serializer.data, status=status.HTTP_200_OK)
