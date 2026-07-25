import django_filters

from apps.explanations.models import ExplanationVerse
from apps.main.services.service_search.search import SearchProvider


class ExplanationVerseAPIFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    class Meta:
        model = ExplanationVerse
        fields = ['q', 'verse_number', 'chapter_number', 'page_number', 'chapter', 'verse']

    def search(self, queryset, name, value):
        return SearchProvider().search(
            queryset=queryset,
            columns=['name', 'text'],
            value=value)
