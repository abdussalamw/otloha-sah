import django_filters

from apps.main.services.service_search.search import SearchProvider
from apps.recitations.models import Reciter


class ReciterAPIFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    class Meta:
        model = Reciter
        fields = ['q']

    def search(self, queryset, name, value):
        return SearchProvider().search(
            queryset=queryset,
            columns=['name'],
            value=value)
