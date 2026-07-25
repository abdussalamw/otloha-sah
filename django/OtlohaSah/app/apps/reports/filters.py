import django_filters
from django import forms
from django.db.models import Case, When, Sum, F, Q
from django.db.models.functions import Coalesce
from django.utils.translation import gettext_lazy as _
from dynamic_listing.filters import FilterSet, NumberInFilter

from apps.main.services.service_search.search import SearchProvider
from apps.users.models import Teacher, TeacherRecitationPricing


class TeacherAccountingFilterSet(FilterSet):
    filterset_types = {
        "q": "search",
    }
    force_visibility = [
        "has_earnings", "has_dues"
    ]

    fields_map = {
        'top_left': 'q',
        'top_right': 'date'
    }
    q = django_filters.CharFilter(
        widget=forms.TextInput(attrs={
            "placeholder": _("Search Users")
        }),
        method='search', label=_("Search"))

    # total_earnings = django_filters.RangeFilter(
    #     field_name='teacherrecitationpricing__price',
    #     label=_("Total Earnings"))
    #
    # total_dues = django_filters.RangeFilter(
    #     field_name='teacherrecitationpricing__price',
    #     label=_("Total Dues"))

    has_earnings = django_filters.ChoiceFilter(
        label=_("Has Earnings"),
        method='filter_has_earnings_or_dues',
        choices=(
            (True, _("Yes")),
            (False, _("No")),
        ),
    )
    has_dues = django_filters.ChoiceFilter(
        label=_("Has Dues"),
        method='filter_has_earnings_or_dues',
        choices=(
            (True, _("Yes")),
            (False, _("No")),
        ),
    )
    date = django_filters.DateFromToRangeFilter(
        label=_("Date"),
        method='filter_date',
    )

    class Meta:
        model = Teacher
        fields = ('q', 'has_earnings', 'has_dues', 'date')

    #     'total_earnings', 'total_dues'

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.filters['q'].field.widget.attrs.update({
            "placeholder": _("Search Teachers")
        })

    def filter_has_earnings_or_dues(self, queryset, name, value):
        filtered_by = {"has_earnings": "total_earnings", "has_dues": "total_dues"}
        if value:
            attrs = {}
            if value == 'True':
                attrs = {filtered_by[name] + '__gt': 0}
            elif value == 'False':
                attrs = {filtered_by[name] + '': 0}

            return queryset.filter(**attrs)
        return queryset

    def search(self, queryset, name, value):
        return SearchProvider().ranked_search(queryset=queryset, search_index=Teacher.SEARCH_INDEX, value=value)

    def filter_date(self, queryset, name, value):
        if value:
            value = (value.start, value.stop)
            queryset = queryset.annotate(
                total_earnings=Coalesce(
                    Sum(Case(When(
                        Q(teacherrecitationpricing__is_paid=True) & Q(
                            teacherrecitationpricing__created_at__range=value),
                        then=F('teacherrecitationpricing__price')),
                        default=0.0)), 0.0),
                total_dues=Coalesce(
                    Sum(Case(When(
                        Q(teacherrecitationpricing__is_paid=False) & Q(
                            teacherrecitationpricing__created_at__range=value),
                        then=F('teacherrecitationpricing__price')),
                        default=0.0)), 0.0),
            )
        return queryset


class TeacherRecitationPricingFilterSet(FilterSet):
    created_at = django_filters.DateFromToRangeFilter()
    teachers__ids = NumberInFilter(field_name='teacher__id')

    class Meta:
        model = TeacherRecitationPricing
        fields = ('teachers__ids', 'created_at')
