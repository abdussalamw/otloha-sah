import django_filters
from django_filters import rest_framework as filters

from apps.main.services.service_search.search import SearchProvider
from apps.parts.models import Part


class PartFilter(filters.FilterSet):
    class Meta:
        model = Part
        fields = ['part_number', 'name', 'alias']

    name = django_filters.CharFilter(
        method='name_filter'
    )

    alias = django_filters.CharFilter(
        method='alias_filter'
    )

    def name_filter(self, queryset, name, value):
        name = "{}__icontains".format(name)
        return queryset.filter(**{name: value})

    def alias_filter(self, queryset, alias, value):
        alias = "{}__icontains".format(alias)
        return queryset.filter(**{alias: value})


class PartAdminSearch(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    def search(self, queryset, name, value):
        return SearchProvider().search(
            queryset=queryset,
            columns=['name', 'alias'],
            value=value)


class PartAPISearch(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    class Meta:
        model = Part
        fields = ['part_number', 'is_active', 'q']

    def search(self, queryset, name, value):
        return SearchProvider().search(
            queryset=queryset,
            columns=['name', 'alias', 'part_number'],
            value=value)
