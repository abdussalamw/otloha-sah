import django_filters
from django import forms

from apps.explanations.models import Explanation
from apps.main.services.service_search.search import SearchProvider
from apps.narrations.models import Narration


class ExplanationAdminFilter(django_filters.FilterSet):
    narration = django_filters.filters.ModelChoiceFilter(queryset=Narration.objects.all(), widget=forms.RadioSelect())

    class Meta:
        model = Explanation
        fields = ['narration']


class ExplanationAdminSearch(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    def search(self, queryset, name, value):
        return SearchProvider().search(
            queryset=queryset,
            columns=['name'],
            value=value)


class ExplanationAPIFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    class Meta:
        model = Explanation
        fields = ['narration', 'q']

    def search(self, queryset, name, value):
        return SearchProvider().search(
            queryset=queryset,
            columns=['name', 'narration__name'],
            value=value)
