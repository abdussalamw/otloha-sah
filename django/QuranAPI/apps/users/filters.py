import django_filters

from apps.users.models import User


class UsersAdminFilter(django_filters.FilterSet):
    class Meta:
        model = User
        fields = ['username', 'first_name']
