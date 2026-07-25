import django_filters
from django import forms

from apps.narrations.models import Narration
from apps.quran.models import Book


class BookFilter(django_filters.FilterSet):
    narration = django_filters.filters.ModelChoiceFilter(queryset=Narration.objects.all(),
                                                         widget=forms.RadioSelect())

    class Meta:
        model = Book
        fields = ['narration']
