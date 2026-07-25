import django_filters
from django import forms
from django.utils.translation import gettext_lazy as _
from dynamic_listing.filters import FilterSet

from apps.main.services.service_search.search import SearchProvider
from apps.users.models import Teacher, TeacherProfile


class TeacherFilter(FilterSet):
    filterset_types = {
        "q": "search",
    }
    force_visibility = [
        'is_active', 'is_verified', 'teacherprofile__status',
        'teacherprofile__teacher_type', 'teacherprofile__is_active'
    ]

    BOOL_CHOICES = (
        (True, _("Yes")),
        (False, _("No")),
    )

    q = django_filters.CharFilter(
        widget=forms.TextInput(attrs={
            "placeholder": _("Search Teachers")
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

    birthdate = django_filters.DateFromToRangeFilter()
    date_joined = django_filters.DateFromToRangeFilter()

    rate = django_filters.ChoiceFilter(
        choices=

        FilterSet.RATE_CHOICES,
        method="filter_rate"
    )

    language = django_filters.ChoiceFilter()

    teacherprofile__teacher_type = django_filters.ChoiceFilter(
        label=_("Teacher Type"),
        choices=TeacherProfile.TEACHER_TYPE
    )

    teacherprofile__status = django_filters.ChoiceFilter(
        label=_("Teacher Profile Status"),
        choices=TeacherProfile.STATUS_CHOICES
    )


    teacherprofile__is_active = django_filters.ChoiceFilter(
        label=_('Is Profile Active'),
        choices=BOOL_CHOICES,
        widget=forms.RadioSelect)

    class Meta:
        model = Teacher
        fields = (
            'q', 'is_verified', 'is_active', 'gender', 'language', 'level', 'teacherprofile__is_active',
            'teacherprofile__status', 'teacherprofile__teacher_type', 'rate',
            'birthdate', 'date_joined')

    def search(self, queryset, name, value):
        return SearchProvider().ranked_search(
            queryset=queryset,
            search_index=Teacher.SEARCH_INDEX,
            value=value)

    def filter_is_verified(self, queryset, name, value):
        if value is not None:
            value = value == 'True'
            return queryset.filter(email_verified_at__isnull=not value, phone_verified_at__isnull=not value)
        return queryset
