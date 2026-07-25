import django_filters

from apps.main.services.service_search.search import SearchProvider
from apps.tajweed.models import Character


# class VerseFilter(django_filters.FilterSet):
#     class Meta:
#         model = Character
#         fields = [
#             'verse_number',
#             'chapter_number',
#             'chapter',
#             'tajweed_book'
#         ]


# class VerseAdminSearch(django_filters.FilterSet):
#     q = django_filters.CharFilter(method='search')
#
#     def search(self, queryset, name, value):
#         return SearchProvider().search(queryset=queryset, columns=['verse_text'],
#                                        value=value)


class CharacterAPIFilterAndSearch(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    class Meta:
        model = Character
        fields = [
            'q',
            'character_text',
            'rule_text',
            'word_text',
            'character_number',
            'word_number',
            'verse_number',
            'chapter_number',
            'word',
            'verse',
            'chapter',
        ]

    def search(self, queryset, name, value):
        return SearchProvider().search(
            queryset=queryset, columns=[
                'verse_text',
                'character_text',
                'rule_text',
                'word_text',
            ],
            value=value)
