from django import forms
from django.utils.translation import gettext as _
from translation.forms import TranslatableModelForm

from .models import Narration, Verse, Word
from ..files_handler.forms import ProcessCSVForm


class NarrationForm(TranslatableModelForm):
    class Meta:
        model = Narration
        fields = ['name', 'description']


class ProcessNarrationCSVForm(ProcessCSVForm):
    line_start = forms.ChoiceField(label=_("Line Start"))
    line_end = forms.ChoiceField(label=_("Line End"))
    part = forms.ChoiceField(label=_("Part"))
    text = forms.ChoiceField(label=_("Text"))
    verse_number = forms.ChoiceField(label=_("Verse Number"))
    chapter = forms.ChoiceField(label=_("Chapter"))
    page = forms.ChoiceField(label=_("Page"))


class NarrationVerseCSVValidationForm(forms.ModelForm):
    line_start = forms.IntegerField(required=True, max_value=20, min_value=1)
    line_end = forms.IntegerField(required=True, max_value=20, min_value=1)
    verse_number = forms.IntegerField(required=True, min_value=1, max_value=300)
    chapter_number = forms.IntegerField(required=True, min_value=1, max_value=115)
    part_number = forms.IntegerField(required=True, min_value=1, max_value=31)
    text = forms.CharField(required=True)

    class Meta:
        model = Verse
        fields = ('line_start', 'line_end', 'part', 'verse_number', 'chapter_number', 'part_number', 'chapter', 'text',
                  "narration", "page_number")


class ProcessNarrationWordsCSVForm(ProcessCSVForm):
    text = forms.ChoiceField(label=_("Text"))
    verse_number = forms.ChoiceField(label=_("Verse Number"))
    chapter_number = forms.ChoiceField(label=_("Chapter Number"))
    number = forms.ChoiceField(label=_("Number"))
    position_in_line = forms.ChoiceField(label=_("Position in Line"))
    line_number = forms.ChoiceField(label=_("Line Number"))
    page_number = forms.ChoiceField(label=_("Page Number"))


class NarrationWordCSVValidationForm(forms.ModelForm):
    verse_number = forms.IntegerField(required=True, min_value=1, max_value=300)
    chapter_number = forms.IntegerField(required=True, min_value=1, max_value=115)
    number = forms.IntegerField(required=True, min_value=1)
    position_in_line = forms.IntegerField(required=False)
    text = forms.CharField(required=True)

    class Meta:
        model = Word
        fields = ('verse_number', 'chapter_number', 'number', 'text', 'line_number', 'page_number', 'position_in_line',
                  'narration', 'verse')
