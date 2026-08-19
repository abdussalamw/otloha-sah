from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.chapters.filters import ChapterAPISearch
from apps.chapters.models import Chapter
from apps.chapters.serializers import ChapterSerializer


class ChaptersListAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        chapters = ChapterAPISearch(request.GET, Chapter.objects.filter(is_active=True)).qs
        serializer = ChapterSerializer(chapters, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class ChaptersDetailAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, chapter_id):
        chapter = get_object_or_404(Chapter, pk=chapter_id)
        serializer = ChapterSerializer(instance=chapter)
        return Response(serializer.data, status=status.HTTP_200_OK)
