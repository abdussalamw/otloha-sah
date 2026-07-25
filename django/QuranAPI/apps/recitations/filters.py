import django_filters
from django import forms

from apps.narrations.models import Narration
from apps.recitations.models import Reciter, Recitation


class RecitationFilter(django_filters.FilterSet):
    narration = django_filters.filters.ModelChoiceFilter(queryset=Narration.objects.all(),
                                                         widget=forms.RadioSelect())
    reciter = django_filters.filters.ModelChoiceFilter(queryset=Reciter.objects.all(),
                                                       widget=forms.RadioSelect())

    class Meta:
        model = Recitation
        fields = ['narration', 'reciter']
