import django_filters
from django import forms

from apps.chapters.models import Chapter
from apps.main.services.service_search.search import SearchProvider
from apps.narrations.models import Verse
from apps.parts.models import Part
from apps.quran.models import Page


class PageAPIFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')
    chapters = django_filters.ModelMultipleChoiceFilter(
        queryset=Chapter.objects.all(), field_name="chapter__id")

    class Meta:
        model = Page
        fields = (
            "q",
            'book',
            "narration",
            'chapters',
            'sub_part',
            'part',
            'page_number',
        )

    def search(self, queryset, name, value):
        return SearchProvider().search(
            queryset=queryset,
            columns=['verse__text'],
            value=value)



