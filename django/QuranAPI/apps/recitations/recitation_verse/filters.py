import django_filters
from django import forms

from apps.chapters.models import Chapter
from apps.recitations.models import Recitation, RecitationVerse


class RecitationVerseFilter(django_filters.FilterSet):
    chapter = django_filters.filters.ModelChoiceFilter(queryset=Chapter.objects.all(),
                                                       widget=forms.RadioSelect())
    recitation = django_filters.filters.ModelChoiceFilter(queryset=Recitation.objects.all(),
                                                          widget=forms.RadioSelect())

    class Meta:
        model = RecitationVerse
        fields = ['chapter', 'recitation', 'verse_number']
