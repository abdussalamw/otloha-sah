import django_filters
from django import forms
from django.utils.translation import gettext_lazy as _
from dynamic_listing.filters import FilterSet
from dynamic_listing.filters.filters import RateFilter

from apps.main.services.service_search.search import SearchProvider
from apps.users.models import User


class BaseUserFilter(FilterSet):
    filterset_types = {
        "q": "search",
    }
    fields_map = {
        "top_left": ['q'],
        "top_right": [],
    }
    force_visibility = (
        'is_active', 'is_verified'
    )

    BOOL_CHOICES = (
        (True, _("Yes")),
        (False, _("No")),
    )

    q = django_filters.CharFilter(
        widget=forms.TextInput(attrs={
            "placeholder": _("Search Users")
        }),
        method='search', label=_("Search"))

    is_verified = django_filters.ChoiceFilter(
        choices=BOOL_CHOICES,
        label=_('Is Verified'),
        widget=forms.RadioSelect,
        method='filter_is_verified')

    is_active = django_filters.ChoiceFilter(
        choices=BOOL_CHOICES,
        label=_('Is Active'),
        widget=forms.RadioSelect)

    date_joined = django_filters.DateFromToRangeFilter()

    class Meta:
        model = User
        fields = ('q', 'is_verified', 'is_active', 'date_joined')

    def search(self, queryset, name, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=self._meta.model.SEARCH_INDEX,
            value=value)

    def filter_is_verified(self, queryset, name, value):
        if value is not None:
            value = value == 'True'
            return queryset.filter(email_verified_at__isnull=not value, phone_verified_at__isnull=not value)
        return queryset


class NonStuffFilter(BaseUserFilter):
    birthdate = django_filters.DateFromToRangeFilter()

    rate = RateFilter(field_name='rate', label=_('Rate'))

    language = django_filters.ChoiceFilter()

    class Meta(BaseUserFilter.Meta):
        fields = BaseUserFilter.Meta.fields + ('birthdate', 'rate', 'language', 'gender', 'level',)
