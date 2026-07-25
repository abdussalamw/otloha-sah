import django_filters

from apps.main.services.service_search.search import SearchProvider
from apps.tajweed.models import Rule, Character


class RuleFilter(django_filters.FilterSet):
    class Meta:
        model = Rule
        fields = ['rule_number', 'tajweed_book', 'color']


class RuleAdminSearch(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    def search(self, queryset, name, value):
        return SearchProvider().search(queryset=queryset, columns=['name', 'description'],
                                       value=value)


class RuleAPISearch(django_filters.FilterSet):
    class Meta:
        model = Rule
        fields = ['rule_number', 'tajweed_book', 'color']

    q = django_filters.CharFilter(method='search')

    def search(self, queryset, name, value):
        return SearchProvider().search(queryset=queryset, columns=['name', 'description'],
                                       value=value)


class CharacterFilter(django_filters.FilterSet):
    class Meta:
        model = Character
        fields = [
            'character_number',
            'word_number',
            'verse_number',
            'chapter_number',
            'book',
            'rule',
            'verse',
            'chapter',
            'word'
        ]


class CharacterAdminSearch(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    def search(self, queryset, name, value):
        return SearchProvider().search(queryset=queryset, columns=['character_text', 'word_text', 'rule'],
                                       value=value)


class CharacterAPISearch(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    class Meta:
        model = Character
        fields = [
            'character_number',
            'word_number',
            'verse_number',
            'chapter_number',
            'book',
            'rule',
            'verse',
            'chapter',
            'word',
            'q'
        ]

    def search(self, queryset, name, value):
        return SearchProvider().search(
            queryset=queryset,
            columns=[
                'character_text',
                'rule_text',
                'word_text'],
            value=value)
