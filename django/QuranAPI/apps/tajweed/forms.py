from django import forms
from django.utils.translation import gettext_lazy as _
from translation.forms import TranslatableModelForm

from apps.files_handler.csv_processing.forms import ProcessCSVForm
from apps.tajweed.models import Book, Rule, Character


class BookForm(TranslatableModelForm):
    class Meta:
        model = Book
        fields = ['name', 'narration', 'author']


class RuleForm(TranslatableModelForm):
    color = forms.ChoiceField(choices=Rule.COLORS)

    class Meta:
        model = Rule
        fields = ['rule_number', 'name', 'description', 'tajweed_book', 'color']


#
# class VerseForm(ModelForm):
#     class Meta:
#         model = Verse
#         fields = ['verse_text', 'verse_number', 'chapter_number', 'chapter', 'tajweed_book']


class CharacterForm(forms.ModelForm):
    rule = forms.CharField(widget=forms.Textarea(attrs={"rows": 2}))

    class Meta:
        model = Character
        fields = [
            'character_text',
            'rule_text',
            'word_text',
            'character_number',
            'verse_number',
            'chapter_number',
            'word_number',
            'rule',
            'book',
            'verse',
        ]


class ValidationRuleCSVForm(forms.Form):
    verse_number = forms.IntegerField(required=True, max_value=300, min_value=1)
    chapter_number = forms.IntegerField(required=True, max_value=20, min_value=1)
    page_number = forms.IntegerField(required=True, min_value=1)
    tafseer_text = forms.CharField(required=True)
    verse_text = forms.CharField(required=True)


class TajweedCSVForm(ProcessCSVForm):
    rule_text = forms.ChoiceField(label=_('Rule Text'))
    character_text = forms.ChoiceField(label=_('Character Text'))
    character_number = forms.ChoiceField(label=_('Character Number'))
    verse_number = forms.ChoiceField(label=_('Verse Number'))
    chapter_number = forms.ChoiceField(label=_('Chapter Number'))
    word_number = forms.ChoiceField(label=_('Word Number'))


class ValidationTajweedCSVForm(forms.ModelForm):
    rule_text = forms.CharField(required=True)
    word_text = forms.CharField(required=True)
    character_number = forms.IntegerField(min_value=0)
    character_text = forms.CharField(required=True)
    verse_number = forms.IntegerField(max_value=300, min_value=0)
    chapter_number = forms.IntegerField(min_value=0, max_value=115)
    word_number = forms.IntegerField(min_value=0)

    class Meta:
        model = Character
        fields = [
            'character_text',
            'rule_text',
            'word_text',
            'character_number',
            'word_number',
            'verse_number',
            'chapter_number',
            'word',
            'verse',
            'chapter',
            'book',
        ]
