from django import forms
from django.utils.translation import gettext as _
from translation.forms import TranslatableModelForm

from apps.explanations.models import Explanation, ExplanationVerse
from apps.files_handler.csv_processing.forms import ProcessCSVForm


class ExplanationForm(TranslatableModelForm):
    class Meta:
        model = Explanation
        fields = ['name', 'narration']


class ValidationExplanationCSVForm(forms.ModelForm):
    verse_number = forms.IntegerField(required=True, max_value=300, min_value=1)
    chapter_number = forms.IntegerField(required=True, max_value=114, min_value=1)
    page_number = forms.IntegerField(required=True, min_value=1)
    text = forms.CharField(required=True)

    class Meta:
        model = ExplanationVerse
        fields = [
            'verse_number', 'chapter_number', 'page_number', 'text', "chapter", "verse",
            "explanation"]


class ExplanationCSVForm(ProcessCSVForm):
    verse_number = forms.ChoiceField(label=_('Verse Number'))
    chapter_number = forms.ChoiceField(label=_('Chapter Number'))
    page_number = forms.ChoiceField(label=_('Page Number'))
    text = forms.ChoiceField(label=_('Explanation Text'))
