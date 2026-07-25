from django import forms
from django.utils.translation import gettext as _
from translation.forms import TranslatableModelForm

from app import settings
from apps.files_handler.forms import ProcessCSVForm
from apps.translations.models import Translation, TranslationVerse


class TranslationForm(TranslatableModelForm):
    language = forms.ChoiceField(choices=settings.LANGUAGES)

    class Meta:
        model = Translation
        fields = ['name', 'narration', 'language', 'author']


class TranslationVerseForm(forms.ModelForm):
    class Meta:
        model = TranslationVerse
        fields = ['text', 'translation', 'chapter', 'chapter_number', 'verse_number']


class TranslationValidationCSVForm(forms.ModelForm):
    verse_number = forms.IntegerField(required=True, max_value=300, min_value=1)
    chapter_number = forms.IntegerField(required=True, max_value=114, min_value=1)
    page_number = forms.IntegerField(required=True, min_value=1)
    text = forms.CharField(required=True)

    class Meta:
        model = TranslationVerse
        fields = [
            'verse_number',
            'chapter_number',
            'page_number',
            'text',
            "chapter",
            "verse",
            "translation", ]


class TranslationCSVForm(ProcessCSVForm):
    verse_number = forms.ChoiceField(label=_('Verse Number'))
    chapter_number = forms.ChoiceField(label=_('Chapter Number'))
    text = forms.ChoiceField(label=_('Explanation Text'))
