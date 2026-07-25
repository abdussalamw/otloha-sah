import django_filters
from django_filters import FilterSet

from apps.main.services.service_search.search import SearchProvider
from apps.recitations import config
from apps.recitations.models import Recitation


class MyEvaluationsFilter(FilterSet):
    q = django_filters.CharFilter(method='search')
    evaluated = django_filters.BooleanFilter(method='filter_evaluated')
    tajweed = django_filters.BooleanFilter(method='filter_tajweed')
    khatma = django_filters.BooleanFilter(method='filter_khatma')

    class Meta:
        model = Recitation
        fields = ['q']

    def filter_tajweed(self, queryset, name, value):
        if value:
            return queryset.filter(tajweed_lesson_example__isnull=False)
        else:
            return queryset.exclude(tajweed_lesson_example__isnull=False)

    def filter_khatma(self, queryset, name, value):
        if value:
            return queryset.filter(khatma__isnull=False)
        else:
            return queryset.exclude(khatma__isnull=False)

    def filter_evaluated(self, queryset, name, value):
        if value:
            return queryset.filter(evaluation__isnull=False)
        else:
            return queryset.exclude(evaluation__isnull=False)

    def search(self, queryset, owner, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=Recitation.SEARCH_INDEX,
            value=value)


class RecitationFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')
    show_in_remarkable = django_filters.BooleanFilter(field_name='show_in_remarkable')
    reported = django_filters.BooleanFilter(method='filter_reported')
    evaluated = django_filters.BooleanFilter(method='filter_evaluated')
    is_remarkable = django_filters.BooleanFilter(field_name='is_remarkable')
    result = django_filters.CharFilter(method='filter_result')
    is_closed = django_filters.BooleanFilter(field_name='is_closed')
    tajweed = django_filters.BooleanFilter(method='filter_tajweed')
    teacher_recitations = django_filters.BooleanFilter(method='filter_teacher_recitations')
    khatma = django_filters.BooleanFilter(method='filter_khatma')

    class Meta:
        model = Recitation
        fields = ('q', 'show_in_remarkable', 'reported', 'evaluated', 'is_remarkable', 'result',
                  'is_closed', 'tajweed', 'khatma', 'teacher_recitations')

    def search(self, queryset, name, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=Recitation.SEARCH_INDEX,
            value=value)

    def filter_reported(self, queryset, name, value):
        if value:
            return queryset.filter(userrecitationreport__isnull=False)
        else:
            return queryset.exclude(userrecitationreport__isnull=False)

    def filter_evaluated(self, queryset, name, value):
        if value:
            return queryset.filter(evaluation__isnull=False)
        else:
            return queryset.exclude(evaluation__isnull=False)

    def filter_result(self, queryset, name, value):
        results = {
            "Pending": config.RECITATIONS_RESULT_PENDING,
            "Accepted": config.RECITATIONS_RESULT_ACCEPTED,
            "Rejected": config.RECITATIONS_RESULT_REJECTED,
        }
        if value in results:
            return queryset.filter(result=results[value])
        return queryset.none()

    def filter_tajweed(self, queryset, name, value):
        if value:
            return queryset.filter(tajweed_lesson_example__isnull=False)
        else:
            return queryset.exclude(tajweed_lesson_example__isnull=False)

    def filter_khatma(self, queryset, name, value):
        if value:
            return queryset.filter(khatma__isnull=False)
        else:
            return queryset.exclude(khatma__isnull=False)

    def filter_teacher_recitations(self, queryset, name, value):
        if value:
            return queryset.filter(owner__is_a_teacher=True)
        else:
            return queryset.exclude(owner__is_a_teacher=True)


class MyRecitationFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')
    tajweed = django_filters.BooleanFilter(method='filter_tajweed')
    khatma = django_filters.BooleanFilter(method='filter_khatma')

    class Meta:
        fields = ('q', 'tajweed', 'khatma')

    def filter_tajweed(self, queryset, name, value):
        if value:
            return queryset.filter(tajweed_lesson_example__isnull=False)
        else:
            return queryset.exclude(tajweed_lesson_example__isnull=False)

    def filter_khatma(self, queryset, name, value):
        if value:
            return queryset.filter(khatma__isnull=False)
        else:
            return queryset.exclude(khatma__isnull=False)

    def search(self, queryset, owner, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=Recitation.SEARCH_INDEX,
            value=value)


class TeacherRecitationFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    class Meta:
        model = Recitation
        fields = ()

    def search(self, queryset, owner, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=Recitation.SEARCH_INDEX,
            value=value)


class KhatmaRecitationFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')
    evaluated = django_filters.BooleanFilter(method='filter_evaluated')
    is_remarkable = django_filters.BooleanFilter(field_name='is_remarkable')
    result = django_filters.CharFilter(method='filter_result')

    class Meta:
        model = Recitation
        fields = ('q', 'evaluated', 'is_remarkable', 'result')

    def filter_evaluated(self, queryset, name, value):
        if value:
            return queryset.filter(evaluation__isnull=False)
        else:
            return queryset.exclude(evaluation__isnull=False)

    def filter_result(self, queryset, name, value):
        results = {
            "Pending": config.RECITATIONS_RESULT_PENDING,
            "Accepted": config.RECITATIONS_RESULT_ACCEPTED,
            "Rejected": config.RECITATIONS_RESULT_REJECTED,
        }
        if value in results:
            return queryset.filter(result=results[value])
        return queryset.none()

    def search(self, queryset, owner, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=Recitation.SEARCH_INDEX,
            value=value)


class GeneralRecitationFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')
    tajweed = django_filters.BooleanFilter(method='filter_tajweed')

    class Meta:
        model = Recitation
        fields = ('q', 'tajweed')

    def filter_tajweed(self, queryset, name, value):
        if value:
            return queryset.filter(tajweed_lesson_example__isnull=False)
        else:
            return queryset.exclude(tajweed_lesson_example__isnull=False)

    def search(self, queryset, owner, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=Recitation.SEARCH_INDEX,
            value=value)


class RemarkableRecitationFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')
    tajweed = django_filters.BooleanFilter(method='filter_tajweed')

    class Meta:
        model = Recitation
        fields = ('q', 'tajweed')

    def filter_tajweed(self, queryset, name, value):
        if value:
            return queryset.filter(tajweed_lesson_example__isnull=False)
        else:
            return queryset.exclude(tajweed_lesson_example__isnull=False)

    def search(self, queryset, owner, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=Recitation.SEARCH_INDEX,
            value=value)


class UserRecitationFilter(RecitationFilter):
    teacher_recitations = None
    reported = None

    class Meta(RecitationFilter.Meta):
        fields = ('q', 'show_in_remarkable', 'khatma', 'tajweed')
