import operator
from functools import reduce

import django_filters
from dj_translation.models import TranslationField
from django.db.models import Q
from django.utils.translation import gettext_lazy as _
from dynamic_listing import filters
from dynamic_listing.filters import FilterSet

from apps.tajweed.models.calendar import CalendarSlot
from apps.tajweed.models.exams import ExamReservation
from apps.tajweed.models.lessons import TajweedLesson, TajweedLessonExample
from apps.tajweed.models.levels import UserLevelPassed


class TajweedLevelFilter(django_filters.FilterSet):
    fields_map = {
        "top_left": ['q']
    }
    filterset_types = {
        "q": "search"
    }

    q = django_filters.CharFilter(method="search", label=_("Search"))

    def search(self, queryset, name, value):
        columns = ["name", "id"]
        q = [Q(**{f"{column}__icontains": value}) for column in columns]
        return queryset.filter(reduce(operator.or_, q))


class TajweedLessonFilter(django_filters.FilterSet):
    class Meta:
        model = TajweedLesson
        fields = ['lesson_level']

    fields_map = {
        "top_left": ['q']
    }
    filterset_types = {
        "q": "search"
    }
    force_visibility = [
        'lesson_level'
    ]
    q = django_filters.CharFilter(method="search", label=_("Search"))

    def search(self, queryset, name, value):
        columns = ["title"]
        q = [Q(**{f"{column}__icontains": value}) for column in columns]
        return queryset.filter(reduce(operator.or_, q))


class CalendarSlotFilter(filters.FilterSet):
    date = django_filters.filters.DateFromToRangeFilter()

    class Meta:
        model = CalendarSlot
        fields = ['date']


class ExamReservationFilter(FilterSet):
    class Meta:
        model = ExamReservation
        fields = ['status']

    fields_map = {
        "top_left": ['q']
    }


class UserLevelPassedFilter(django_filters.FilterSet):
    class Meta:
        model = UserLevelPassed
        fields = ['level']

    fields_map = {
        "top_left": ['q']
    }


class TajweedLessonExampleFilter(django_filters.FilterSet):
    class Meta:
        model = TajweedLessonExample
        fields = ['narration', 'chapter']

    fields_map = {
        "top_left": ['q']
    }


class TajweedExampleLessonFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method="search", label=_("Search"))

    class Meta:
        model = TajweedLessonExample
        fields = ["verse_number", 'narration', 'chapter', 'verse_text']

    fields_map = {
        "top_left": ['q']
    }
    filterset_types = {
        "q": "search"
    }

    def search(self, queryset, name, value):
        search_fields = [
            'title__icontains',
            'verse_number__icontains',
            'narration__name__icontains',
            'chapter__name__icontains',
            'verse_text__icontains'
        ]
        queries = Q()
        for field in search_fields:
            queries |= Q(**{field: value})

        return queryset.filter(queries).distinct()


class TajweedVideoLessonFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method="search", label=_("Search"))

    class Meta:
        model = TajweedLessonExample
        fields = []

    fields_map = {
        "top_left": ['q']
    }
    filterset_types = {
        "q": "search"
    }

    def search(self, queryset, name, value):
        search_fields = []
        queries = Q()
        for field in search_fields:
            queries |= Q(**{field: value})
        return queryset.filter(queries).distinct()


class TajweedSubLessonFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method="search", label=_("Search"))

    class Meta:
        model = TajweedLesson
        fields = ["id", "lesson_level", "parent"]

        filter_overrides = {
            TranslationField: {
                'filter_class': django_filters.CharFilter,
                'extra': lambda f: {
                    'lookup_expr': 'icontains',
                },
            },
        }
    fields_map = {
        "top_left": ['q']
    }
    filterset_types = {
        "q": "search"
    }

    def search(self, queryset, name, value):
        search_fields = [
            'title__icontains',
            'lesson_level__icontains',
            'narration__name__icontains',
            'parent__icontains',
        ]
        queries = Q()
        for field in search_fields:
            queries |= Q(**{field: value})

        return queryset.filter(queries).distinct()
