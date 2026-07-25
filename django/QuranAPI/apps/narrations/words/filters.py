import django_filters

from apps.main.services.service_search.search import SearchProvider
from apps.narrations.models import Verse, Word


class WordAPIFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')
    verse = django_filters.filters.ModelChoiceFilter(queryset=Verse.objects.all())

    class Meta:
        model = Word
        fields = ["q", 'text', 'number', 'verse_number', 'chapter_number', 'verse']

    def search(self, queryset, name, value):
        return SearchProvider().search(
            queryset=queryset,
            columns=['text'],
            value=value)
