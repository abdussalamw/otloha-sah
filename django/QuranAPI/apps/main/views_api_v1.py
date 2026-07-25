from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from pyarabic import araby
from pyarabic.normalize import normalize_searchtext
from rest_framework.pagination import PageNumberPagination
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.chapters.models import Chapter
from apps.chapters.serializers import ChapterSearchSerializer
from apps.main.services.service_search.search import SearchProvider
from apps.narrations.models import Verse
from apps.narrations.verses.serializers import VerseSearchSerializer


class Paginator(PageNumberPagination):
    page_size = 10


class SearchAPIView(APIView):
    permission_classes = [TokenHasReadWriteScope]

    def get_searchable(self, narration_id):
        return [
            {
                "result_type": "chapter",
                "queryset": Chapter.objects.filter(is_active=True),
                "search_index": Chapter.SEARCH_INDEX,
                "serializer": ChapterSearchSerializer
            },
            {
                "result_type": "verse",
                "queryset": Verse.objects.filter(narration_id=narration_id),
                "search_index": Verse.SEARCH_INDEX,
                "serializer": VerseSearchSerializer
            },
        ]

    def search(self, searchable, query):
        queryset = SearchProvider().ranked_search(
            queryset=searchable['queryset'],
            search_index=searchable['search_index'],
            value=query)
        return searchable['serializer'](queryset, many=True).data

    def get(self, request, narration_id, *args, **kwargs):
        query = araby.strip_diacritics(normalize_searchtext(request.GET.get('q')))
        result = []
        if query:
            for searchable in self.get_searchable(narration_id):
                result = result + self.search(searchable, query)
            return Response(result)
        return Response([])
