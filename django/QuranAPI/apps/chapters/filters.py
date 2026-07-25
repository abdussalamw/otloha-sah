import django_filters

from apps.chapters.models import Chapter
from apps.main.services.service_search.search import SearchProvider


class ChapterFilter(django_filters.FilterSet):
    class Meta:
        model = Chapter
        fields = ['origin']


class ChapterAdminSearch(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    def search(self, queryset, name, value):
        return SearchProvider().search(queryset=queryset, columns=['name', 'chapter_number'],
                                       value=value)


class ChapterAPISearch(django_filters.FilterSet):
    class Meta:
        model = Chapter
        fields = ['origin', 'chapter_number']

    q = django_filters.CharFilter(method='search')

    def search(self, queryset, name, value):
        return SearchProvider().search(queryset=queryset, columns=['name', 'chapter_number'],
                                       value=value)
