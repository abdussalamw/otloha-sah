import django_filters
from django import forms

from apps.main.services.service_search.search import SearchProvider
from apps.narrations.models import Narration
from apps.tajweed.models import Book


class BookFilter(django_filters.FilterSet):
    narration = django_filters.filters.ModelChoiceFilter(queryset=Narration.objects.all(),
                                                         widget=forms.RadioSelect())

    class Meta:
        model = Book
        fields = ['narration']


class BookAdminSearch(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    def search(self, queryset, name, value):
        return SearchProvider().search(queryset=queryset, columns=['name', 'author'],
                                       value=value)


class BookAPISearch(django_filters.FilterSet):
    class Meta:
        model = Book
        fields = ['narration']

    q = django_filters.CharFilter(method='search')

    def search(self, queryset, name, value):
        return SearchProvider().search(queryset=queryset, columns=['name', 'author'],
                                       value=value)
