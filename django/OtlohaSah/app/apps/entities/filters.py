import django_filters
from django.contrib.auth import get_user_model

from apps.entities.models import Entity
from apps.main.services.service_search.search import SearchProvider

UserModel = get_user_model()


class EntityFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')

    class Meta:
        model = Entity
        fields = ('q',)

    def search(self, queryset, name, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=Entity.SEARCH_INDEX,
            value=value)


class EntityUserFilter(django_filters.FilterSet):
    q = django_filters.CharFilter(method='search')
    user_type = django_filters.ChoiceFilter(
        field_name='user_type',
        method='filter_user_type',
        choices=(
            ('students', "Students"),
            ('teachers', "Teachers"),
            ('members', "Members"),
        )
    )

    class Meta:
        model = UserModel
        fields = ['q', 'user_type']

    def search(self, queryset, name, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=self._meta.model.SEARCH_INDEX,
            value=value
        )

    def filter_user_type(self, queryset, name, value):
        if value == 'students':
            queryset = queryset.list_student()
        elif value == 'teachers':
            queryset = queryset.list_teacher()
        return queryset