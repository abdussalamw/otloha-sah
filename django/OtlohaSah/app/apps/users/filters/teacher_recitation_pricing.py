import django_filters
from django import forms
from django.utils.translation import gettext_lazy as _
from dynamic_listing.filters import FilterSet

from apps.users.models import TeacherRecitationPricing


class BaseTeacherRecitationPricingFilter(FilterSet):
    filterset_types = {
        "is_paid": "switch"
    }
    force_visibility = ["is_paid"]
    fields_map = {
        "top_right": ["created_at"],
        "top_left": ["paid_at"],
        "top_body": [],
        "side": []
    }
    BOOL_CHOICES = (
        (True, _("Yes")),
        (False, _("No")),
    )

    is_paid = django_filters.ChoiceFilter(
        choices=BOOL_CHOICES,
        label=_('Is Paid'),
        widget=forms.RadioSelect)

    created_at = django_filters.DateFromToRangeFilter()
    paid_at = django_filters.DateFromToRangeFilter()

    class Meta:
        model = TeacherRecitationPricing
        fields = ('is_paid', 'created_at', "paid_at")
