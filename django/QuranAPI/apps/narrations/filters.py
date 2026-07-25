import django_filters

from apps.main.services.service_search.search import SearchProvider
from apps.narrations.models import Narration


class NarrationFilter(django_filters.FilterSet):
    class Meta:
        model = Narration
        fields = ['name']

    name = django_filters.CharFilter(
        method='name_filter'
    )

    def name_filter(self, queryset, name, value):
        name = "{}__icontains".format(name)
        return queryset.filter(**{name: value})


class NarrationAdminSearch(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    def search(self, queryset, name, value):
        return SearchProvider().search(
            queryset=queryset,
            columns=['name', 'description'],
            value=value)


class NarrationAPIFilter(django_filters.FilterSet):
    class Meta:
        model = Narration
        fields = ['q', 'is_active']

    q = django_filters.CharFilter(method='search')

    def search(self, queryset, name, value):
        return SearchProvider().search(
            queryset=queryset,
            columns=['name', 'description'],
            value=value)
