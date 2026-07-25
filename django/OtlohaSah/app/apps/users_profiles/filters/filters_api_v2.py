import django_filters

from apps.main.services.service_search.search import SearchProvider
from apps.users.models import User


class UserFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')
    ordering = django_filters.OrderingFilter(
        fields=(
            ('rate', 'rate'),
        ),
        field_labels={
            'rate': 'Rating',
        },
        label='Order by'
    )

    class Meta:
        model = User
        fields = ('q',)

    def search(self, queryset, name, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=User.SEARCH_INDEX,
            value=value)
