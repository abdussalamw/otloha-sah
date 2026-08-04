import django_filters
from django import forms
from django.conf import settings
from django.db.models import Q
from django.forms import Form
from django.utils.translation import gettext_lazy as _

from apps.recitation.models import Recitation
from apps.users import countries_config
from apps.users.models import User


def get_country_name(country_code):
    return dict(countries_config.COUNTRIES).get(country_code)


def get_countries():
    try:
        
        countries = set(
            User.objects.exclude(
                Q(country__isnull=True) | Q(country='') | Q(country=None)).values_list('country', flat=True).distinct())
    except Exception:
        countries = set()
    return [('', '')] + [(country, get_country_name(country)) for country in countries]


GENDERS = (('', ''), ("male", _("Male")), ("female", _("Female")))

LANGUAGES = (('', ''),) + settings.LANGUAGES


class StatisticsForm(Form):
    date_from = forms.DateField(
        required=False,
        label=_("From"),
        widget=forms.DateInput(attrs={
            'type': 'date',
            "data-filter": 'date'
        }))
    date_to = forms.DateField(
        required=False,
        label=_("To"),
        widget=forms.DateInput(attrs={
            'type': 'date',
            "data-filter": 'date'
        }))
    country = forms.ChoiceField(
        required=False,
        label=_("Countries"),
        widget=forms.Select(attrs={
            "data-filter": 'country',
            "data-control": "select2",
            "data-placeholder": _("Select a country"),
            "data-allow-clear": "true",
        }),
    )
    language = forms.ChoiceField(
        required=False,
        label=_("Languages"),
        choices=LANGUAGES,
        widget=forms.Select(attrs={
            "data-filter": 'country',
            "data-control": "select2",
            "data-placeholder": _("Select a Language"),
            "data-allow-clear": "true",
        }),
    )
    gender = forms.ChoiceField(
        required=False,
        label=_("Gender"),
        choices=GENDERS,
        widget=forms.Select(attrs={
            "data-filter": 'country',
            "data-control": "select2",
            "data-placeholder": _("Select a gender"),
            "data-allow-clear": "true",
        })
    )

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.fields['country'].choices = get_countries()


class UserFilterset(django_filters.FilterSet):
    date_from = django_filters.DateFilter(field_name='date_joined', lookup_expr='gte')
    date_to = django_filters.DateFilter(field_name='date_joined', lookup_expr='lte')
    country = django_filters.ChoiceFilter(field_name='country', choices=get_countries())
    language = django_filters.ChoiceFilter(field_name='language', choices=LANGUAGES)
    gender = django_filters.ChoiceFilter(field_name='gender', choices=GENDERS)

    class Meta:
        model = User
        fields = []


class RecitationFilterset(django_filters.FilterSet):
    date_from = django_filters.DateFilter(field_name='created_at', lookup_expr='gte')
    date_to = django_filters.DateFilter(field_name='created_at', lookup_expr='lte')
    country = django_filters.ChoiceFilter(field_name='owner__country', choices=get_countries())
    language = django_filters.ChoiceFilter(field_name='owner__language', choices=LANGUAGES)
    gender = django_filters.ChoiceFilter(field_name='gender', choices=GENDERS)

    class Meta:
        model = Recitation
        fields = []
