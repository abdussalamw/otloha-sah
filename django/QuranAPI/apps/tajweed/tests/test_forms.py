from django import forms
from django.forms import ModelForm
from django.test import TestCase
from django.utils.translation import gettext_lazy as _
from translation.forms import TranslatableModelForm

from apps.chapters.factories import ChapterFactory
from apps.files_handler.csv_processing.forms import ProcessCSVForm
from apps.narrations.factories import NarrationFactory
from apps.quran.factories import BookFactory
from apps.tajweed.factories import TajweedBookFactory, VerseFactory, RuleFactory
from apps.tajweed.forms import BookForm, RuleForm, VerseForm, CharacterForm, ValidationRuleCSVForm, TajweedCSVForm, \
    ValidationTajweedCSVForm
from apps.tajweed.models import Book, Rule, Verse, Character


class BookFormStructureTestCase(TestCase):
    def test_it_extends_django_Form(self):
        self.assertTrue(issubclass(BookForm, TranslatableModelForm))

    def test_form_class_has_meta_class_on_it(self):
        self.assertIn('Meta', BookForm.__dict__)

    def test_form_class_meta_has_model_on_it(self):
        self.assertIn('model', BookForm.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Book_model(self):
        self.assertEquals(Book, BookForm.Meta.model)

    def test_form_class_meta_has_fields_on_it(self):
        self.assertIn('fields', BookForm.Meta.__dict__)

    def test_form_class_meta_fields_is_a_list(self):
        self.assertEquals(type(BookForm.Meta.fields), list)

    def test_class_meta_fields_has_name(self):
        self.assertIn('name', BookForm.Meta.fields)

    def test_class_meta_fields_has_narration(self):
        self.assertIn('narrations', BookForm.Meta.fields)

    def test_class_meta_fields_has_author(self):
        self.assertIn('author', BookForm.Meta.fields)


class BookFormValidationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'name': 'Bokhari Tajweed Book',
            'narrations': NarrationFactory(),
            'author': 'Bokhari',
        }

    def test_it_throws_error_if_name_has_no_value(self):
        self.data.pop('name')
        form = BookForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['name'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['name'][0].message, _('This field is required.'))

    def test_it_throws_error_if_author_has_no_value(self):
        self.data.pop('author')
        form = BookForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['author'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['author'][0].message, _('This field is required.'))


class RuleFormStructureTestCase(TestCase):
    def test_it_extends_django_Form(self):
        self.assertTrue(issubclass(RuleForm, TranslatableModelForm))

    def test_form_class_has_meta_class_on_it(self):
        self.assertIn('Meta', RuleForm.__dict__)

    def test_form_class_meta_has_model_on_it(self):
        self.assertIn('model', RuleForm.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Rule_model(self):
        self.assertEquals(Rule, RuleForm.Meta.model)

    def test_form_class_meta_has_fields_on_it(self):
        self.assertIn('fields', RuleForm.Meta.__dict__)

    def test_form_class_meta_fields_is_a_list(self):
        self.assertEquals(type(RuleForm.Meta.fields), list)

    def test_class_meta_fields_has_rule_number(self):
        self.assertIn('rule_number', RuleForm.Meta.fields)

    def test_class_meta_fields_has_name(self):
        self.assertIn('name', RuleForm.Meta.fields)

    def test_class_meta_fields_has_description(self):
        self.assertIn('description', RuleForm.Meta.fields)

    def test_class_meta_fields_has_tajweed_book(self):
        self.assertIn('tajweed_book', RuleForm.Meta.fields)

    def test_class_meta_fields_has_colors(self):
        self.assertIn('color', RuleForm.Meta.fields)

    def test_it_has_colors_field(self):
        self.assertIn("color", RuleForm().fields)

    def test_colors_field_is_instance_of_choice_field(self):
        self.assertIsInstance(RuleForm().fields['color'], forms.ChoiceField)

    def test_color_field_has_choices_parameter(self):
        self.assertIsNotNone(RuleForm().fields['color'].choices)

    def test_color_field_value_is_colors_choices_variable(self):
        self.assertEquals(list(Rule.COLORS), RuleForm().fields['color'].choices)


class RuleFormValidationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'rule_number': '120',
            'name': 'edgham Rule',
            'description': 'make the character hidden',
            'tajweed_book': BookFactory(narration=NarrationFactory()),
            'color': 'red'
        }

    def test_it_throws_error_if_rule_number_has_no_value(self):
        self.data.pop('rule_number')
        form = RuleForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['rule_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['rule_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_rule_number_value_is_negative(self):
        self.data.update({'rule_number': -1})
        form = RuleForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['rule_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['rule_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_name_has_no_value(self):
        self.data.pop('name')
        form = RuleForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['name'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['name'][0].message, _('This field is required.'))

    def test_it_throws_error_if_tajweed_book_has_no_value(self):
        self.data.pop('tajweed_book')
        form = RuleForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['tajweed_book'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['tajweed_book'][0].message, _('This field is required.'))

    def test_it_throws_error_if_colors_has_no_value(self):
        self.data.pop('color')
        form = RuleForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['color'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['color'][0].message, _('This field is required.'))

    def test_it_throws_error_if_color_value_is_unknown(self):
        self.data.update({'color': 'lmk'})
        form = RuleForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['color'][0].code, 'invalid_choice')
        self.assertEquals(form.errors.as_data()['color'][0].message,
                          _('Select a valid choice. %(value)s is not one of the available choices.'))


class VerseFormStructureTestCase(TestCase):
    def test_it_extends_django_Form(self):
        self.assertTrue(issubclass(VerseForm, ModelForm))

    def test_form_class_has_meta_class_on_it(self):
        self.assertIn('Meta', VerseForm.__dict__)

    def test_form_class_meta_has_model_on_it(self):
        self.assertIn('model', VerseForm.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Verse_model(self):
        self.assertEquals(Verse, VerseForm.Meta.model)

    def test_form_class_meta_has_fields_on_it(self):
        self.assertIn('fields', VerseForm.Meta.__dict__)

    def test_form_class_meta_fields_is_a_list(self):
        self.assertEquals(type(VerseForm.Meta.fields), list)

    def test_class_meta_fields_has_verse_text(self):
        self.assertIn('verse_text', VerseForm.Meta.fields)

    def test_class_meta_fields_has_verse_number(self):
        self.assertIn('verse_number', VerseForm.Meta.fields)

    def test_class_meta_fields_has_chapter(self):
        self.assertIn('chapter', VerseForm.Meta.fields)

    def test_class_meta_fields_has_chapter_number(self):
        self.assertIn('chapter_number', VerseForm.Meta.fields)

    def test_class_meta_fields_has_tajweed_book(self):
        self.assertIn('tajweed_book', VerseForm.Meta.fields)


class VerseFormValidationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'verse_text': 'bsm ellah elrahman el rahim Verse',
            'verse_number': 1,
            'chapter_number': 1,
            'chapter': ChapterFactory(),
            'tajweed_book': TajweedBookFactory(),
        }

    def test_it_throws_error_if_verse_text_has_no_value(self):
        self.data.pop('verse_text')
        form = VerseForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_text'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['verse_text'][0].message, _('This field is required.'))

    def test_it_throws_error_if_verse_number_has_no_value(self):
        self.data.pop('verse_number')
        form = VerseForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_verse_number_value_is_negative(self):
        self.data.update({'verse_number': -1})
        form = VerseForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_chapter_number_has_no_value(self):
        self.data.pop('chapter_number')
        form = VerseForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_chapter_number_value_is_negative(self):
        self.data.update({'chapter_number': -1})
        form = VerseForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))


class CharacterFormStructureTestCase(TestCase):
    def test_it_extends_django_Form(self):
        self.assertTrue(issubclass(CharacterForm, forms.ModelForm))

    def test_form_class_has_meta_class_on_it(self):
        self.assertIn('Meta', CharacterForm.__dict__)

    def test_form_class_meta_has_model_on_it(self):
        self.assertIn('model', CharacterForm.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Character_model(self):
        self.assertEquals(Character, CharacterForm.Meta.model)

    def test_form_class_meta_has_fields_on_it(self):
        self.assertIn('fields', CharacterForm.Meta.__dict__)

    def test_form_class_meta_fields_is_a_list(self):
        self.assertEquals(type(CharacterForm.Meta.fields), list)

    def test_class_meta_fields_has_character_text(self):
        self.assertIn('character_text', CharacterForm.Meta.fields)

    def test_class_meta_fields_has_character_number(self):
        self.assertIn('character_number', CharacterForm.Meta.fields)

    def test_class_meta_fields_has_word_text(self):
        self.assertIn('word_text', CharacterForm.Meta.fields)

    def test_class_meta_fields_has_word_number(self):
        self.assertIn('word_number', CharacterForm.Meta.fields)

    def test_class_meta_fields_has_rule(self):
        self.assertIn('rule', CharacterForm.Meta.fields)

    def test_class_meta_fields_has_verse_number(self):
        self.assertIn('verse_number', CharacterForm.Meta.fields)

    def test_class_meta_fields_has_chapter_number(self):
        self.assertIn('chapter_number', CharacterForm.Meta.fields)

    def test_class_meta_fields_has_tajweed_book(self):
        self.assertIn('tajweed_book', CharacterForm.Meta.fields)

    def test_class_meta_fields_has_tajweed_rule(self):
        self.assertIn('tajweed_rule', CharacterForm.Meta.fields)

    def test_class_meta_fields_has_tajweed_verse(self):
        self.assertIn('tajweed_verse', CharacterForm.Meta.fields)

    def test_it_has_rule_field(self):
        self.assertIn("rule", CharacterForm().fields)

    def test_rule_field_is_instance_of_char_field(self):
        self.assertIsInstance(CharacterForm().fields['rule'], forms.CharField)

    def test_rule_field_has_widget_parameter(self):
        self.assertIsNotNone(CharacterForm().fields['rule'].widget)

    def test_widget_attribute_value_in_rule_field_is_textarea(self):
        self.assertIsInstance(CharacterForm().fields['rule'].widget, forms.Textarea)

    def test_widget_attribute_in_rule_field_has_attr(self):
        self.assertIn('attrs', CharacterForm().fields['rule'].widget.__dict__)

    def test_textarea_in_widget_attribute_in_rule_field_has_rows_parameter(self):
        self.assertIn('rows', CharacterForm().fields['rule'].widget.attrs)

    def test_rows_parameter_value_is_2(self):
        self.assertEqual(2, CharacterForm().fields['rule'].widget.attrs['rows'])


class CharacterFormValidationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'character_text': 's',
            'character_number': 1,
            'word_text': 'bsm ellah',
            'word_number': 3,
            'rule': "it's a rule",
            'verse_number': 3,
            'chapter_number': 5,
            'tajweed_book': TajweedBookFactory(),
            'tajweed_rule': RuleFactory(tajweed_book=TajweedBookFactory()),
            'tajweed_verse': VerseFactory(),
        }

    def test_it_throws_error_if_character_text_has_no_value(self):
        self.data.pop('character_text')
        form = CharacterForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['character_text'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['character_text'][0].message, _('This field is required.'))

    def test_it_throws_error_if_character_number_has_no_value(self):
        self.data.pop('character_number')
        form = CharacterForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['character_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['character_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_character_number_value_is_negative(self):
        self.data.update({'character_number': -1})
        form = CharacterForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['character_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['character_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_word_text_has_no_value(self):
        self.data.pop('word_text')
        form = CharacterForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['word_text'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['word_text'][0].message, _('This field is required.'))

    def test_it_throws_error_if_word_number_has_no_value(self):
        self.data.pop('word_number')
        form = CharacterForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['word_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['word_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_word_number_value_is_negative(self):
        self.data.update({'word_number': -1})
        form = CharacterForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['word_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['word_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_verse_number_has_no_value(self):
        self.data.pop('verse_number')
        form = CharacterForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_verse_number_value_is_negative(self):
        self.data.update({'verse_number': -1})
        form = CharacterForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_chapter_number_has_no_value(self):
        self.data.pop('chapter_number')
        form = CharacterForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_chapter_number_value_is_negative(self):
        self.data.update({'chapter_number': -1})
        form = CharacterForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))


class ValidationRuleCSVFormStructureTestCase(TestCase):

    # Test Form

    def test_it_extends_django_Form(self):
        self.assertTrue(issubclass(ValidationRuleCSVForm, forms.Form))

    # Test Verse_number

    def test_form_has_verse_number(self):
        self.assertIn('verse_number', ValidationRuleCSVForm().fields)

    def test_verse_number_field_is_instance_of_integer_field(self):
        self.assertIsInstance(ValidationRuleCSVForm().fields['verse_number'], forms.IntegerField)

    def test_verse_number_field_has_required(self):
        self.assertIsNotNone(ValidationRuleCSVForm().fields['verse_number'].required)

    def test_verse_number_field_required_is_true(self):
        self.assertTrue(ValidationRuleCSVForm().fields['verse_number'].required)

    def test_verse_number_field_has_max_value(self):
        self.assertIsNotNone(ValidationRuleCSVForm().fields['verse_number'].max_value)

    def test_verse_number_field_max_value_is_300(self):
        self.assertEqual(300, ValidationRuleCSVForm().fields['verse_number'].max_value)

    def test_verse_number_field_has_min_value(self):
        self.assertIsNotNone(ValidationRuleCSVForm().fields['verse_number'].min_value)

    def test_verse_number_field_min_value_is_1(self):
        self.assertEqual(1, ValidationRuleCSVForm().fields['verse_number'].min_value)

    # Test Chapter_number

    def test_form_has_chapter_number(self):
        self.assertIn('chapter_number', ValidationRuleCSVForm().fields)

    def test_chapter_number_field_is_instance_of_integer_field(self):
        self.assertIsInstance(ValidationRuleCSVForm().fields['chapter_number'], forms.IntegerField)

    def test_chapter_number_field_has_required(self):
        self.assertIsNotNone(ValidationRuleCSVForm().fields['chapter_number'].required)

    def test_chapter_number_field_required_is_true(self):
        self.assertTrue(ValidationRuleCSVForm().fields['chapter_number'].required)

    def test_chapter_number_field_has_max_value(self):
        self.assertIsNotNone(ValidationRuleCSVForm().fields['chapter_number'].max_value)

    def test_chapter_number_field_max_value_is_20(self):
        self.assertEqual(20, ValidationRuleCSVForm().fields['chapter_number'].max_value)

    def test_chapter_number_field_has_min_value(self):
        self.assertIsNotNone(ValidationRuleCSVForm().fields['chapter_number'].min_value)

    def test_chapter_number_field_min_value_is_1(self):
        self.assertEqual(1, ValidationRuleCSVForm().fields['chapter_number'].min_value)

    # Test Page_number

    def test_form_has_page_number(self):
        self.assertIn('page_number', ValidationRuleCSVForm().fields)

    def test_page_number_field_is_instance_of_integer_field(self):
        self.assertIsInstance(ValidationRuleCSVForm().fields['page_number'], forms.IntegerField)

    def test_page_number_field_has_required(self):
        self.assertIsNotNone(ValidationRuleCSVForm().fields['page_number'].required)

    def test_page_number_field_required_is_true(self):
        self.assertTrue(ValidationRuleCSVForm().fields['page_number'].required)

    def test_page_number_field_has_min_value(self):
        self.assertIsNotNone(ValidationRuleCSVForm().fields['page_number'].min_value)

    def test_page_number_field_min_value_is_1(self):
        self.assertEqual(1, ValidationRuleCSVForm().fields['page_number'].min_value)

    # Test Tafseer_text

    def test_form_has_tafseer_text(self):
        self.assertIn('tafseer_text', ValidationRuleCSVForm().fields)

    def test_tafseer_text_field_is_instance_of_char_field(self):
        self.assertIsInstance(ValidationRuleCSVForm().fields['tafseer_text'], forms.CharField)

    def test_tafseer_text_field_has_required(self):
        self.assertIsNotNone(ValidationRuleCSVForm().fields['tafseer_text'].required)

    def test_tafseer_text_field_required_is_true(self):
        self.assertTrue(ValidationRuleCSVForm().fields['tafseer_text'].required)

    # Test verse_text

    def test_form_has_verse_text(self):
        self.assertIn('verse_text', ValidationRuleCSVForm().fields)

    def test_verse_text_field_is_instance_of_char_field(self):
        self.assertIsInstance(ValidationRuleCSVForm().fields['verse_text'], forms.CharField)

    def test_verse_text_field_has_required(self):
        self.assertIsNotNone(ValidationRuleCSVForm().fields['verse_text'].required)

    def test_verse_text_field_required_is_true(self):
        self.assertTrue(ValidationRuleCSVForm().fields['verse_text'].required)


class ValidationRuleCSVFormValidationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'verse_number': '150',
            'chapter_number': 10,
            'page_number': 5,
            'tafseer_text': "it's a tafseer",
            'verse_text': "it's a verses",
        }

    # Test Verse_number

    def test_it_throws_error_if_verse_number_has_no_value(self):
        self.data.pop('verse_number')
        form = ValidationRuleCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_verse_number_value_is_less_than_minimum(self):
        self.data.update({'verse_number': 0})
        form = ValidationRuleCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_verse_number_value_is_greater_than_maximum(self):
        self.data.update({'verse_number': 310})
        form = ValidationRuleCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'max_value')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message,
                          _('Ensure this value is less than or equal to %(limit_value)s.'))

    # Test Chapter_number

    def test_it_throws_error_if_chapter_number_has_no_value(self):
        self.data.pop('chapter_number')
        form = ValidationRuleCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_chapter_number_value_is_less_than_minimum(self):
        self.data.update({'chapter_number': 0})
        form = ValidationRuleCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_chapter_number_value_is_greater_than_maximum(self):
        self.data.update({'chapter_number': 30})
        form = ValidationRuleCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'max_value')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message,
                          _('Ensure this value is less than or equal to %(limit_value)s.'))

    # Test Page_number

    def test_it_throws_error_if_page_number_has_no_value(self):
        self.data.pop('page_number')
        form = ValidationRuleCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['page_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['page_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_page_number_value_is_less_than_minimum(self):
        self.data.update({'page_number': 0})
        form = ValidationRuleCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['page_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['page_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    # Test Tafseer_text

    def test_it_throws_error_if_tafseer_text_has_no_value(self):
        self.data.pop('tafseer_text')
        form = ValidationRuleCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['tafseer_text'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['tafseer_text'][0].message, _('This field is required.'))

    # Test Verse_text

    def test_it_throws_error_if_verse_text_has_no_value(self):
        self.data.pop('verse_text')
        form = ValidationRuleCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_text'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['verse_text'][0].message, _('This field is required.'))


class TajweedCSVFormStructureTestCase(TestCase):

    # Test Form

    def test_it_extends_process_csv_form(self):
        self.assertTrue(issubclass(TajweedCSVForm, ProcessCSVForm))

    # Test Word_text

    def test_form_has_word_text(self):
        self.assertIn('word_text', TajweedCSVForm.base_fields)

    def test_word_text_field_is_instance_of_choice_field(self):
        self.assertIsInstance(TajweedCSVForm.base_fields['word_text'], forms.ChoiceField)

    def test_word_text_field_has_label(self):
        self.assertIsNotNone(TajweedCSVForm.base_fields['word_text'].label)

    def test_word_text_field_label_is_word_text(self):
        self.assertEqual(_('Word Text'), TajweedCSVForm.base_fields['word_text'].label)

    # Test Character_number

    def test_form_has_character_number(self):
        self.assertIn('character_number', TajweedCSVForm.base_fields)

    def test_character_number_field_is_instance_of_choice_field(self):
        self.assertIsInstance(TajweedCSVForm.base_fields['character_number'], forms.ChoiceField)

    def test_character_number_field_has_label(self):
        self.assertIsNotNone(TajweedCSVForm.base_fields['character_number'].label)

    def test_character_number_field_label_is_character_number(self):
        self.assertEqual(_('Character Number'), TajweedCSVForm.base_fields['character_number'].label)

    # Test Character_text

    def test_form_has_character_text(self):
        self.assertIn('character_text', TajweedCSVForm.base_fields)

    def test_character_text_field_is_instance_of_choice_field(self):
        self.assertIsInstance(TajweedCSVForm.base_fields['character_text'], forms.ChoiceField)

    def test_character_text_field_has_label(self):
        self.assertIsNotNone(TajweedCSVForm.base_fields['character_text'].label)

    def test_character_text_field_character_text_is_character_text(self):
        self.assertEqual(_('Character Text'), TajweedCSVForm.base_fields['character_text'].label)

    # Test Verse_number

    def test_form_has_verse_number(self):
        self.assertIn('verse_number', TajweedCSVForm.base_fields)

    def test_verse_number_field_is_instance_of_choice_field(self):
        self.assertIsInstance(TajweedCSVForm.base_fields['verse_number'], forms.ChoiceField)

    def test_verse_number_field_has_label(self):
        self.assertIsNotNone(TajweedCSVForm.base_fields['verse_number'].label)

    def test_verse_number_field_label_is_verse_number(self):
        self.assertEqual(_('Verse Number'), TajweedCSVForm.base_fields['verse_number'].label)

    # Test Verse_text

    def test_form_has_verse_text(self):
        self.assertIn('verse_text', TajweedCSVForm.base_fields)

    def test_verse_text_field_is_instance_of_choice_field(self):
        self.assertIsInstance(TajweedCSVForm.base_fields['verse_text'], forms.ChoiceField)

    def test_verse_text_field_has_label(self):
        self.assertIsNotNone(TajweedCSVForm.base_fields['verse_text'].label)

    def test_verse_text_field_label_is_verse_text(self):
        self.assertEqual(_('Verse Text'), TajweedCSVForm.base_fields['verse_text'].label)

    # Test Chapter_number

    def test_form_has_chapter_number(self):
        self.assertIn('chapter_number', TajweedCSVForm.base_fields)

    def test_chapter_number_field_is_instance_of_choice_field(self):
        self.assertIsInstance(TajweedCSVForm.base_fields['chapter_number'], forms.ChoiceField)

    def test_chapter_number_field_has_label(self):
        self.assertIsNotNone(TajweedCSVForm.base_fields['chapter_number'].label)

    def test_chapter_number_field_label_is_chapter_number(self):
        self.assertEqual(_('Chapter Number'), TajweedCSVForm.base_fields['chapter_number'].label)

    # Test Rule

    def test_form_has_rule(self):
        self.assertIn('rule', TajweedCSVForm.base_fields)

    def test_rule_field_is_instance_of_choice_field(self):
        self.assertIsInstance(TajweedCSVForm.base_fields['rule'], forms.ChoiceField)

    def test_rule_field_has_label(self):
        self.assertIsNotNone(TajweedCSVForm.base_fields['rule'].label)

    def test_rule_field_label_is_rule(self):
        self.assertEqual(_('Rule'), TajweedCSVForm.base_fields['rule'].label)

    # Test Word_number

    def test_form_has_word_number(self):
        self.assertIn('word_number', TajweedCSVForm.base_fields)

    def test_word_number_field_is_instance_of_choice_field(self):
        self.assertIsInstance(TajweedCSVForm.base_fields['word_number'], forms.ChoiceField)

    def test_word_number_field_has_label(self):
        self.assertIsNotNone(TajweedCSVForm.base_fields['word_number'].label)

    def test_word_number_field_label_is_word_number(self):
        self.assertEqual(_('Word Number'), TajweedCSVForm.base_fields['word_number'].label)


class ValidationTajweedCSVFormStructureTestCase(TestCase):

    # Test Form

    def test_it_extends_django_model_Form(self):
        self.assertTrue(issubclass(ValidationTajweedCSVForm, forms.ModelForm))

    # Test Meta

    def test_form_class_has_meta_class_on_it(self):
        self.assertIn('Meta', ValidationTajweedCSVForm.__dict__)

    # Test Model

    def test_form_class_meta_has_model_on_it(self):
        self.assertIn('model', ValidationTajweedCSVForm.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Character_model(self):
        self.assertEquals(Character, ValidationTajweedCSVForm.Meta.model)

    # Test Fields

    def test_form_class_meta_has_fields_on_it(self):
        self.assertIn('fields', ValidationTajweedCSVForm.Meta.__dict__)

    def test_form_class_meta_fields_is_a_list(self):
        self.assertEquals(type(ValidationTajweedCSVForm.Meta.fields), list)

    def test_class_meta_fields_has_character_text(self):
        self.assertIn('character_text', ValidationTajweedCSVForm.Meta.fields)

    def test_class_meta_fields_has_character_number(self):
        self.assertIn('character_number', ValidationTajweedCSVForm.Meta.fields)

    def test_class_meta_fields_has_word_text(self):
        self.assertIn('word_text', ValidationTajweedCSVForm.Meta.fields)

    def test_class_meta_fields_has_word_number(self):
        self.assertIn('word_number', ValidationTajweedCSVForm.Meta.fields)

    def test_class_meta_fields_has_rule(self):
        self.assertIn('rule', ValidationTajweedCSVForm.Meta.fields)

    def test_class_meta_fields_has_verse_number(self):
        self.assertIn('verse_number', ValidationTajweedCSVForm.Meta.fields)

    def test_class_meta_fields_has_chapter_number(self):
        self.assertIn('chapter_number', ValidationTajweedCSVForm.Meta.fields)

    def test_class_meta_fields_has_tajweed_book(self):
        self.assertIn('tajweed_book', ValidationTajweedCSVForm.Meta.fields)

    def test_class_meta_fields_has_tajweed_verse(self):
        self.assertIn('tajweed_verse', ValidationTajweedCSVForm.Meta.fields)

    # Test Word_text

    def test_it_has_word_text_field(self):
        self.assertIn("word_text", ValidationTajweedCSVForm.base_fields)

    def test_word_text_field_is_instance_of_char_field(self):
        self.assertIsInstance(ValidationTajweedCSVForm.base_fields['word_text'], forms.CharField)

    def test_word_text_field_has_required(self):
        self.assertIsNotNone(ValidationTajweedCSVForm.base_fields['word_text'].required)

    def test_word_text_field_required_value_is_true(self):
        self.assertTrue(ValidationTajweedCSVForm.base_fields['word_text'].required)

    # Test Character_number

    def test_it_has_character_number_field(self):
        self.assertIn("character_number", ValidationTajweedCSVForm.base_fields)

    def test_character_number_field_is_instance_of_integer_field(self):
        self.assertIsInstance(ValidationTajweedCSVForm.base_fields['character_number'], forms.IntegerField)

    def test_character_number_field_has_min_value(self):
        self.assertIsNotNone(ValidationTajweedCSVForm.base_fields['character_number'].min_value)

    def test_character_number_field_min_value_is_0(self):
        self.assertEqual(0, ValidationTajweedCSVForm.base_fields['character_number'].min_value)

    # Test Character_text

    def test_it_has_character_text_field(self):
        self.assertIn("character_text", ValidationTajweedCSVForm.base_fields)

    def test_character_text_field_is_instance_of_char_field(self):
        self.assertIsInstance(ValidationTajweedCSVForm.base_fields['character_text'], forms.CharField)

    def test_character_text_field_has_required(self):
        self.assertIsNotNone(ValidationTajweedCSVForm.base_fields['character_text'].required)

    def test_character_text_field_required_value_is_true(self):
        self.assertTrue(ValidationTajweedCSVForm.base_fields['character_text'].required)

    # Test Verse_number

    def test_it_has_verse_number_field(self):
        self.assertIn("verse_number", ValidationTajweedCSVForm.base_fields)

    def test_verse_number_field_is_instance_of_integer_field(self):
        self.assertIsInstance(ValidationTajweedCSVForm.base_fields['verse_number'], forms.IntegerField)

    def test_verse_number_field_has_min_value(self):
        self.assertIsNotNone(ValidationTajweedCSVForm.base_fields['verse_number'].min_value)

    def test_verse_number_field_min_value_is_0(self):
        self.assertEqual(0, ValidationTajweedCSVForm.base_fields['verse_number'].min_value)

    def test_verse_number_field_has_max_value(self):
        self.assertIsNotNone(ValidationTajweedCSVForm.base_fields['verse_number'].max_value)

    def test_verse_number_field_max_value_is_300(self):
        self.assertEqual(300, ValidationTajweedCSVForm.base_fields['verse_number'].max_value)

    # Test Verse_text

    def test_it_has_verse_text_field(self):
        self.assertIn("verse_text", ValidationTajweedCSVForm.base_fields)

    def test_verse_text_field_is_instance_of_char_field(self):
        self.assertIsInstance(ValidationTajweedCSVForm.base_fields['verse_text'], forms.CharField)

    def test_verse_text_field_has_required(self):
        self.assertIsNotNone(ValidationTajweedCSVForm.base_fields['verse_text'].required)

    def test_verse_text_field_required_value_is_true(self):
        self.assertTrue(ValidationTajweedCSVForm.base_fields['verse_text'].required)

    # Test Chapter_number

    def test_it_has_chapter_number_field(self):
        self.assertIn("chapter_number", ValidationTajweedCSVForm.base_fields)

    def test_chapter_number_field_is_instance_of_integer_field(self):
        self.assertIsInstance(ValidationTajweedCSVForm.base_fields['chapter_number'], forms.IntegerField)

    def test_chapter_number_field_has_min_value(self):
        self.assertIsNotNone(ValidationTajweedCSVForm.base_fields['chapter_number'].min_value)

    def test_chapter_number_field_min_value_is_0(self):
        self.assertEqual(0, ValidationTajweedCSVForm.base_fields['chapter_number'].min_value)

    def test_chapter_number_field_has_max_value(self):
        self.assertIsNotNone(ValidationTajweedCSVForm.base_fields['chapter_number'].max_value)

    def test_chapter_number_field_max_value_is_115(self):
        self.assertEqual(115, ValidationTajweedCSVForm.base_fields['chapter_number'].max_value)


class ValidationTajweedCSVFormValidationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'word_text': "it's a word",
            'character_number': 6,
            'character_text': "it's a character",
            'verse_number': 2,
            'verse_text': "it's a verses",
            'chapter_number': 1,
            'word_number': 4,
        }

    # Test Word_text

    def test_it_throws_error_if_word_text_has_no_value(self):
        self.data.pop('word_text')
        form = ValidationTajweedCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['word_text'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['word_text'][0].message, _('This field is required.'))

    # Test Character_number

    def test_it_throws_error_if_character_number_has_no_value(self):
        self.data.pop('character_number')
        form = ValidationTajweedCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['character_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['character_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_character_number_value_is_less_than_minimum(self):
        self.data.update({'character_number': -1})
        form = ValidationTajweedCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['character_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['character_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    # Test Character_text

    def test_it_throws_error_if_character_text_has_no_value(self):
        self.data.pop('character_text')
        form = ValidationTajweedCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['character_text'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['character_text'][0].message, _('This field is required.'))

    # Test Verse_number

    def test_it_throws_error_if_verse_number_has_no_value(self):
        self.data.pop('verse_number')
        form = ValidationTajweedCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_verse_number_value_is_less_than_minimum(self):
        self.data.update({'verse_number': -1})
        form = ValidationTajweedCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_verse_number_value_is_greater_than_maximum(self):
        self.data.update({'verse_number': 350})
        form = ValidationTajweedCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'max_value')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message,
                          _('Ensure this value is less than or equal to %(limit_value)s.'))

    # Test verse_text

    def test_it_throws_error_if_verse_text_has_no_value(self):
        self.data.pop('verse_text')
        form = ValidationTajweedCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_text'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['verse_text'][0].message, _('This field is required.'))

    # Test chapter_number

    def test_it_throws_error_if_chapter_number_has_no_value(self):
        self.data.pop('chapter_number')
        form = ValidationTajweedCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_chapter_number_value_is_less_than_minimum(self):
        self.data.update({'chapter_number': -1})
        form = ValidationTajweedCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_chapter_number_value_is_greater_than_maximum(self):
        self.data.update({'chapter_number': 150})
        form = ValidationTajweedCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'max_value')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message,
                          _('Ensure this value is less than or equal to %(limit_value)s.'))

    # Test Word_number

    def test_it_throws_error_if_word_number_has_no_value(self):
        self.data.pop('word_number')
        form = ValidationTajweedCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['word_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['word_number'][0].message, _('This field is required.'))
