from django import forms
from django.test import TestCase
from django.utils.translation import gettext_lazy as _
from translation.forms import TranslatableModelForm

from app import settings
from apps.chapters.factories import ChapterFactory
from apps.narrations.factories import NarrationFactory
from apps.translations.factories import TranslationFactory
from apps.translations.forms import TranslationForm, TranslationVerseForm
from apps.translations.models import Translation, TranslationVerse


class TranslationFormStructureTestCase(TestCase):
    def test_it_extends_django_Form(self):
        self.assertTrue(issubclass(TranslationForm, TranslatableModelForm))

    def test_form_class_has_meta_class_on_it(self):
        self.assertIn('Meta', TranslationForm.__dict__)

    def test_form_class_meta_has_model_on_it(self):
        self.assertIn('model', TranslationForm.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_translation_model(self):
        self.assertEquals(Translation, TranslationForm.Meta.model)

    def test_form_class_meta_has_fields_on_it(self):
        self.assertIn('fields', TranslationForm.Meta.__dict__)

    def test_form_class_meta_fields_is_a_list(self):
        self.assertEquals(type(TranslationForm.Meta.fields), list)

    def test_class_meta_fields_has_name(self):
        self.assertIn('name', TranslationForm.Meta.fields)

    def test_class_meta_fields_has_author(self):
        self.assertIn('author', TranslationForm.Meta.fields)

    def test_class_meta_fields_has_language(self):
        self.assertIn('language', TranslationForm.Meta.fields)

    def test_it_has_language_field(self):
        self.assertIn("language", TranslationForm().fields)

    def test_language_field_is_instance_of_choice_field(self):
        self.assertIsInstance(TranslationForm().fields['language'], forms.ChoiceField)

    def test_language_field_has_choices_parameter(self):
        self.assertIsNotNone(TranslationForm().fields['language'].choices)

    def test_language_field_value_is_languages_choices_variable(self):
        self.assertEquals(list(settings.LANGUAGES), TranslationForm().fields['language'].choices)

    def test_class_meta_fields_has_narration(self):
        self.assertIn('narration', TranslationForm.Meta.fields)


class TranslationFormValidationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'name': 'english translation',
            'author': 'suleiman',
            'language': 'en'
        }

    def test_it_throws_error_if_name_has_no_value(self):
        self.data.pop('name')
        form = TranslationForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['name'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['name'][0].message, _('This field is required.'))

    def test_it_throws_error_if_language_has_no_value(self):
        self.data.pop('language')
        form = TranslationForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['language'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['language'][0].message, _('This field is required.'))

    def test_if_language_value_was_not_one_of_choices(self):
        self.data.update({'language': 'mn'})
        form = TranslationForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['language'][0].code, 'invalid_choice')
        self.assertEquals(form.errors.as_data()['language'][0].message,
                          _('Select a valid choice. %(value)s is not one of the available choices.'))

    def test_it_throws_error_if_author_has_no_value(self):
        self.data.pop('author')
        form = TranslationForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['author'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['author'][0].message, _('This field is required.'))


class TranslationVerseFormStructureTestCase(TestCase):

    def test_it_extends_django_Form(self):
        self.assertTrue(issubclass(TranslationVerseForm, forms.ModelForm))

    def test_form_class_has_meta_class_on_it(self):
        self.assertIn('Meta', TranslationVerseForm.__dict__)

    def test_form_class_meta_has_model_on_it(self):
        self.assertIn('model', TranslationVerseForm.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_translation_verse_model(self):
        self.assertEquals(TranslationVerse, TranslationVerseForm.Meta.model)

    def test_form_class_meta_has_fields_on_it(self):
        self.assertIn('fields', TranslationVerseForm.Meta.__dict__)

    def test_form_class_meta_fields_is_a_list(self):
        self.assertEquals(type(TranslationVerseForm.Meta.fields), list)

    def test_class_meta_fields_has_text(self):
        self.assertIn('text', TranslationVerseForm.Meta.fields)

    def test_class_meta_fields_has_translation(self):
        self.assertIn('translation', TranslationVerseForm.Meta.fields)

    def test_class_meta_fields_has_chapter(self):
        self.assertIn('chapter', TranslationVerseForm.Meta.fields)

    def test_class_meta_fields_has_chapter_number(self):
        self.assertIn('chapter_number', TranslationVerseForm.Meta.fields)

    def test_class_meta_fields_has_verse_number(self):
        self.assertIn('verse_number', TranslationVerseForm.Meta.fields)


class TranslationVerseFormValidationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'text': 'translated verses',
            'translation': TranslationFactory(),
            'narrations': NarrationFactory(),
            'chapter': ChapterFactory(),
            'chapter_number': 2,
            'verse_number': 3,
        }

    def test_it_throws_error_if_text_has_no_value(self):
        self.data.pop('text')
        form = TranslationVerseForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['text'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['text'][0].message, _('This field is required.'))

    def test_it_throws_error_if_translation_has_no_value(self):
        self.data.pop('translation')
        form = TranslationVerseForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['translation'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['translation'][0].message, _('This field is required.'))

    def test_it_throws_error_if_chapter_number_has_no_value(self):
        self.data.pop('chapter_number')
        form = TranslationVerseForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_chapter_number_value_is_negative(self):
        self.data.update({'chapter_number': -1})
        form = TranslationVerseForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_verse_number_has_no_value(self):
        self.data.pop('verse_number')
        form = TranslationVerseForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_verse_number_value_is_negative(self):
        self.data.update({'verse_number': -1})
        form = TranslationVerseForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))
