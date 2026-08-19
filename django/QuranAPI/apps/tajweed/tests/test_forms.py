from django import forms
from django.test import SimpleTestCase
from django.utils.translation import gettext_lazy as _
from translation.forms import TranslatableModelForm

from apps.files_handler.csv_processing.forms import ProcessCSVForm
from apps.tajweed.forms import (
    BookForm,
    CharacterForm,
    TajweedCSVForm,
    ValidationRuleCSVForm,
    ValidationTajweedCSVForm,
    RuleForm,
)
from apps.tajweed.models import Book, Character, Rule


class BookFormTestCase(SimpleTestCase):
    def test_uses_the_current_book_model_and_fields(self):
        self.assertTrue(issubclass(BookForm, TranslatableModelForm))
        self.assertEqual(Book, BookForm.Meta.model)
        self.assertEqual(['name', 'narration', 'author'], BookForm.Meta.fields)


class RuleFormTestCase(SimpleTestCase):
    def test_uses_the_current_rule_model_and_fields(self):
        self.assertTrue(issubclass(RuleForm, TranslatableModelForm))
        self.assertEqual(Rule, RuleForm.Meta.model)
        self.assertEqual(
            ['rule_number', 'name', 'description', 'tajweed_book', 'color'],
            RuleForm.Meta.fields,
        )

    def test_color_is_a_choice_field_with_the_model_choices(self):
        form = RuleForm()

        self.assertIsInstance(form.fields['color'], forms.ChoiceField)
        self.assertEqual(list(Rule.COLORS), list(form.fields['color'].choices))


class CharacterFormTestCase(SimpleTestCase):
    def test_uses_the_current_character_model_and_fields(self):
        self.assertTrue(issubclass(CharacterForm, forms.ModelForm))
        self.assertEqual(Character, CharacterForm.Meta.model)
        self.assertEqual(
            [
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
            ],
            CharacterForm.Meta.fields,
        )

    def test_rule_is_rendered_as_a_two_row_textarea(self):
        field = CharacterForm().fields['rule']

        self.assertIsInstance(field, forms.CharField)
        self.assertIsInstance(field.widget, forms.Textarea)
        self.assertEqual(2, field.widget.attrs['rows'])


class ValidationRuleCSVFormTestCase(SimpleTestCase):
    def test_exposes_the_required_validation_fields(self):
        form = ValidationRuleCSVForm()

        self.assertEqual(
            {'verse_number', 'chapter_number', 'page_number', 'tafseer_text', 'verse_text'},
            set(form.fields),
        )
        self.assertFalse(ValidationRuleCSVForm(data={}).is_valid())


class TajweedCSVFormTestCase(SimpleTestCase):
    def test_extends_the_common_csv_processing_form(self):
        self.assertTrue(issubclass(TajweedCSVForm, ProcessCSVForm))

    def test_uses_translated_labels_for_import_columns(self):
        self.assertEqual(_('Rule Text'), TajweedCSVForm.base_fields['rule_text'].label)
        self.assertEqual(_('Character Text'), TajweedCSVForm.base_fields['character_text'].label)
        self.assertEqual(_('Verse Number'), TajweedCSVForm.base_fields['verse_number'].label)
        self.assertEqual(_('Chapter Number'), TajweedCSVForm.base_fields['chapter_number'].label)
        self.assertEqual(_('Word Number'), TajweedCSVForm.base_fields['word_number'].label)


class ValidationTajweedCSVFormTestCase(SimpleTestCase):
    def test_targets_character_and_current_import_fields(self):
        self.assertEqual(Character, ValidationTajweedCSVForm.Meta.model)
        self.assertEqual(
            [
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
            ],
            ValidationTajweedCSVForm.Meta.fields,
        )

    def test_requires_the_core_csv_values(self):
        self.assertFalse(ValidationTajweedCSVForm(data={}).is_valid())
