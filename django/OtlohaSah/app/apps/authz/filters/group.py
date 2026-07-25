import django_filters
from django import forms
from django.contrib.auth.models import Group
from dynamic_listing.filters import FilterSet
from django.utils.translation import gettext as _
from apps.users.models import Admin


class GroupFilter(FilterSet):
    filterset_types = {
        "name": "search"
    }
    fields_map = {
        "top_left": ['name'],
        "top_right": [],
        "top_body": [],
        "side": []

    }

    class Meta:
        model = Group
        fields = {
            'name'
        }


class GroupAdminsFilter(FilterSet):
    filterset_types = {
        "q": "search",
    }
    fields_map = {
        "top_left": ['q'],
        "top_right": [],
        "top_body": [],
        "side": []
    }

    q = django_filters.CharFilter(
        widget=forms.TextInput(attrs={
            "placeholder": _("Search Users")
        }),
        method='search', label=_("Search"))

    class Meta:
        model = Admin
        fields = ("q", "is_active", "date_joined")

    def search(self, queryset, name, value):
        pass
