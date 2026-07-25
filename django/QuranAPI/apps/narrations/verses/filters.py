from itertools import chain

import django_filters
from django import forms
from django.db.models import Q

from apps.chapters.models import Chapter
from apps.main.services.service_search.search import SearchProvider
from apps.narrations.models import Verse
from apps.parts.models import Part


class VerseAPIFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')
    part = django_filters.filters.ModelChoiceFilter(queryset=Part.objects.all())
    chapter = django_filters.filters.ModelChoiceFilter(queryset=Chapter.objects.all())

    class Meta:
        model = Verse
        fields = ["q", 'chapter', 'part', 'verse_number', 'page_number', 'chapter_number', 'part_number']

    def search(self, queryset, name, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=Verse.SEARCH_INDEX,
            value=value)


class VerseFilter(django_filters.FilterSet):
    part = django_filters.filters.ModelChoiceFilter(queryset=Part.objects.all(), widget=forms.RadioSelect())
    chapter = django_filters.filters.ModelChoiceFilter(queryset=Chapter.objects.all(), widget=forms.RadioSelect())

    class Meta:
        model = Verse
        fields = ['chapter', 'part', 'verse_number', 'page_number', 'chapter_number', 'part_number']


class VerseSearch(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    class Meta:
        model = Verse
        fields = ["q"]
