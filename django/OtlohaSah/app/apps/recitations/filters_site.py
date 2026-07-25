import django_filters
from django import forms
from django.utils.translation import gettext_lazy as _
from dynamic_listing.filters import FilterSet, RateFilter

from apps.main.services.service_search.search import SearchProvider
from apps.recitations import config
from apps.recitations.models import Recitation


class DateFromToFilter(django_filters.DateFromToRangeFilter):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.field.widget.attrs.update({
            'class': 'form-control datepicker',
            'autocomplete': 'off',
            'placeholder': _('From - To')
        })


class RecitationFilter(FilterSet):
    filterset_types = {
        "q": "search",
    }
    fields_map = {
        "top_left": ['q'],
        "top_right": ['created_at'],
        "top_body": [],
        "side": []
    }

    force_visibility = [
        'is_remarkable', "is_closed", "show_in_general", 'is_general_recitation', "is_teacher_recitation", 'reported',
        "show_in_remarkable",
        'is_evaluated', 'is_reviewed'
    ]

    BOOL_CHOICES = (
        (True, _("Yes")),
        (False, _("No")),
    )

    q = django_filters.CharFilter(
        widget=forms.TextInput(attrs={
            "placeholder": _("Search Recitations")
        }),
        method='search', label=_("Search"))

    result = django_filters.ChoiceFilter(
        empty_label=_("All"),
        choices=config.RECITATIONS_RESULT)

    closed_at = django_filters.DateFromToRangeFilter()
    evaluated_at = django_filters.DateFromToRangeFilter()
    created_at = django_filters.DateFromToRangeFilter()

    is_remarkable = django_filters.ChoiceFilter(
        choices=BOOL_CHOICES,
        label=_('Is Remarkable'),
        widget=forms.RadioSelect)

    is_closed = django_filters.ChoiceFilter(
        choices=BOOL_CHOICES,
        label=_('Is Closed'),
        widget=forms.RadioSelect)

    show_in_general = django_filters.ChoiceFilter(
        choices=BOOL_CHOICES,
        label=_('In General Box'),
        widget=forms.RadioSelect)

    show_in_remarkable = django_filters.ChoiceFilter(
        choices=BOOL_CHOICES,
        label=_('In Remarkable Box'),
        widget=forms.RadioSelect)

    is_evaluated = django_filters.ChoiceFilter(
        label=_('Is Evaluated'),
        choices=BOOL_CHOICES,
        widget=forms.RadioSelect,
        method="filter_is_evaluated")

    is_reviewed = django_filters.ChoiceFilter(
        label=_('Is Reviewed'),
        choices=BOOL_CHOICES,
        widget=forms.RadioSelect,
        method="filter_is_reviewed")

    reported = django_filters.ChoiceFilter(
        label=_('Reported Recitations'),
        choices=BOOL_CHOICES,
        widget=forms.RadioSelect,
        method="filter_reported")

    is_teacher_recitation = django_filters.ChoiceFilter(
        label=_('Is Teacher Recitations'),
        choices=BOOL_CHOICES,
        widget=forms.RadioSelect,
        method="filter_is_teacher_recitation")

    is_general_recitation = django_filters.ChoiceFilter(
        label=_('General Recitations'),
        choices=BOOL_CHOICES,
        widget=forms.RadioSelect,
        method="filter_is_general_recitation")

    teacher_rate = RateFilter(field_name='teacher_rate', label=_('Teacher Rate'))

    owner_rate = RateFilter(field_name='owner_rate', label=_('Owner Rate'))

    class Meta:
        model = Recitation
        fields = (
            'q', 'closed_at', 'evaluated_at', 'created_at', 'result', 'reported', 'is_teacher_recitation',
            'is_general_recitation', 'is_remarkable', 'show_in_remarkable', 'is_closed', 'is_evaluated', 'is_reviewed',
            'show_in_general', 'teacher_rate',
            'owner_rate'
        )

    def filter_is_general_recitation(self, queryset, name, value):
        if value is not None:
            value = value == 'True'
            return queryset.filter(
                evaluating=not value,
                evaluated_at=None,
                khatma__isnull=value,
                owner__is_a_teacher=not value
            )
        return queryset

    def filter_is_teacher_recitation(self, queryset, name, value):
        if value is not None:
            value = value == 'True'
            return queryset.filter(owner__is_a_teacher=value)
        return queryset

    def filter_is_evaluated(self, queryset, name, value):
        if value is not None:
            value = value == 'True'
            return queryset.filter(evaluated_at__isnull=not value)
        return queryset

    def filter_reported(self, queryset, name, value):
        if value is not None:
            value = value == 'True'
            return queryset.filter(userrecitationreport__isnull=not value)
        return queryset

    def filter_is_reviewed(self, queryset, name, value):
        if value is not None:
            value = value == 'True'
            return queryset.filter(evaluated_at__isnull=False, owner_review__isnull=not value)
        return queryset

    def search(self, queryset, name, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=Recitation.SEARCH_INDEX,
            value=value)
