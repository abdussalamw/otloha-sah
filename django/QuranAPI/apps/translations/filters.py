import django_filters

from apps.main.services.service_search.search import SearchProvider
from apps.translations.models import Translation, TranslationVerse


class TranslationFilter(django_filters.FilterSet):
    class Meta:
        model = Translation
        fields = ['language', 'narration']


class TranslationVerseFilter(django_filters.FilterSet):
    class Meta:
        model = TranslationVerse
        fields = ['translation', 'chapter', 'chapter_number', 'verse_number']


class TranslationAPISearch(django_filters.FilterSet):
    class Meta:
        model = Translation
        fields = ['q', 'language', 'narration']

    q = django_filters.CharFilter(method='search')

    def search(self, queryset, name, value):
        return SearchProvider().search(queryset=queryset, columns=['name', 'author'],
                                       value=value)


class TranslationVerseAPISearch(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    class Meta:
        model = TranslationVerse
        fields = [
            'q',
            'chapter',
            'page_number',
            'chapter_number',
            'verse_number',
            'verse'
        ]

    def search(self, queryset, name, value):
        return SearchProvider().search(queryset=queryset, columns=['text'],
                                       value=value)
