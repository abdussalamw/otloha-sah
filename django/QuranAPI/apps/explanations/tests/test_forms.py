from django import forms
from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import TestCase
from django.test import override_settings
from django.utils.translation import gettext as _
from translation.forms import TranslatableModelForm

from apps.explanations.factories import ExplanationFactory
from apps.explanations.forms import ExplanationForm, ExplanationCSVForm, ValidationExplanationCSVForm
from apps.explanations.models import Explanation
from apps.files_handler.csv_processing.forms import ProcessCSVForm
from apps.files_handler.models import File
from apps.narrations.factories import NarrationFactory

TEST_DIR = 'test_data'


class ExplanationFormStructureTestCase(TestCase):
    def test_it_extends_django_Form(self):
        self.assertTrue(issubclass(ExplanationForm, TranslatableModelForm))

    def test_form_class_has_meta_class_on_it(self):
        self.assertIn('Meta', ExplanationForm.__dict__)

    def test_form_class_meta_has_model_on_it(self):
        self.assertIn('model', ExplanationForm.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Explanation_model(self):
        self.assertEquals(Explanation, ExplanationForm.Meta.model)

    def test_form_class_meta_has_fields_on_it(self):
        self.assertIn('fields', ExplanationForm.Meta.__dict__)

    def test_form_class_meta_fields_is_a_list(self):
        self.assertEquals(type(ExplanationForm.Meta.fields), list)

    def test_class_meta_fields_has_name(self):
        self.assertIn('name', ExplanationForm.Meta.fields)

    def test_class_meta_fields_has_narration(self):
        self.assertIn('narration', ExplanationForm.Meta.fields)


class ExplanationFormValidationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'name': "it's an explanations",
            'narration': NarrationFactory(),
        }

    def test_it_throws_error_if_name_has_no_value(self):
        self.data.pop('name')
        form = ExplanationForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['name'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['name'][0].message, _('This field is required.'))


class ExplanationCSVFormStructureTestCase(TestCase):
    def test_it_extends_django_Form(self):
        self.assertTrue(issubclass(ExplanationCSVForm, ProcessCSVForm))

    # Test Verse_number

    def test_it_has_verse_number_field(self):
        self.assertIn("verse_number", ExplanationCSVForm.base_fields)

    def test_verse_number_field_is_instance_of_choice_field(self):
        self.assertIsInstance(ExplanationCSVForm.base_fields['verse_number'], forms.ChoiceField)

    def test_verse_number_field_has_label_parameter(self):
        self.assertIsNotNone(ExplanationCSVForm.base_fields['verse_number'].label)

    def test_verse_number_field_label_variable_is_Verse_Number(self):
        self.assertEquals(_('Verse Number'), ExplanationCSVForm.base_fields['verse_number'].label)

    # Test Chapter_number

    def test_it_has_chapter_number_field(self):
        self.assertIn("chapter_number", ExplanationCSVForm.base_fields)

    def test_chapter_number_field_is_instance_of_choice_field(self):
        self.assertIsInstance(ExplanationCSVForm.base_fields['chapter_number'], forms.ChoiceField)

    def test_chapter_number_field_has_label_parameter(self):
        self.assertIsNotNone(ExplanationCSVForm.base_fields['chapter_number'].label)

    def test_chapter_number_field_label_variable_is_Chapter_Number(self):
        self.assertEquals(_('Chapter Number'), ExplanationCSVForm.base_fields['chapter_number'].label)

    # Test Page_number

    def test_it_has_page_number_field(self):
        self.assertIn("page_number", ExplanationCSVForm.base_fields)

    def test_page_number_field_is_instance_of_choice_field(self):
        self.assertIsInstance(ExplanationCSVForm.base_fields['page_number'], forms.ChoiceField)

    def test_page_number_field_has_label_parameter(self):
        self.assertIsNotNone(ExplanationCSVForm.base_fields['page_number'].label)

    def test_page_number_field_label_variable_is_Page_Number(self):
        self.assertEquals(_('Page Number'), ExplanationCSVForm.base_fields['page_number'].label)

    # Test text

    def test_it_has_text_field(self):
        self.assertIn("text", ExplanationCSVForm.base_fields)

    def test_text_field_is_instance_of_choice_field(self):
        self.assertIsInstance(ExplanationCSVForm.base_fields['text'], forms.ChoiceField)

    def test_text_field_has_label_parameter(self):
        self.assertIsNotNone(ExplanationCSVForm.base_fields['text'].label)

    def test_text_field_label_variable_is_explanation_text(self):
        self.assertEquals(_('Explanation Text'), ExplanationCSVForm.base_fields['text'].label)


class ExplanationCSVFormSaveTestCase(TestCase):
    maxDiff = None

    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def setUp(self):
        data = open('QuranAPI/app/apps/explanations/tests/simple.csv', 'rb')
        self.file = SimpleUploadedFile(content=data.read(), name=data.name, content_type='multipart/form-data')
        self.data = {
            'text': 10,
            "verse_number": 8,
            "chapter_number": 2,
            "page_number": 5,
        }
        empty_data = {
            'text': None,
            "verse_number": None,
            "chapter_number": None,
            "page_number": None,
        }
        self.file_handler = File.objects.create(file=self.file, user_choice_columns=self.data)
        explanation = ExplanationFactory(narration=NarrationFactory())
        self.form = ProcessCSVForm(file_instance=self.file_handler, data=self.data,
                                   columns_interface=explanation.csv_upload_columns)
        self.form.is_valid()
        self.form.save()

    # TODO: solve the error
    # def test_it_saves_columns_values_to_book_csv(self):
    #     self.assertDictEqual(self.file_handler.columns, self.data)


class ValidationExplanationCSVFormStructureTestCase(TestCase):

    # Test Form

    def test_it_extends_django_Form(self):
        self.assertTrue(issubclass(ValidationExplanationCSVForm, forms.ModelForm))

    # Test Verse_number

    def test_form_has_verse_number(self):
        self.assertIn('verse_number', ValidationExplanationCSVForm.base_fields)

    def test_verse_number_field_is_instance_of_integer_field(self):
        self.assertIsInstance(ValidationExplanationCSVForm.base_fields['verse_number'], forms.IntegerField)

    def test_verse_number_field_has_required(self):
        self.assertIsNotNone(ValidationExplanationCSVForm.base_fields['verse_number'].required)

    def test_verse_number_field_required_is_true(self):
        self.assertTrue(ValidationExplanationCSVForm.base_fields['verse_number'].required)

    def test_verse_number_field_has_max_value(self):
        self.assertIsNotNone(ValidationExplanationCSVForm.base_fields['verse_number'].max_value)

    def test_verse_number_field_max_value_is_300(self):
        self.assertEqual(300, ValidationExplanationCSVForm.base_fields['verse_number'].max_value)

    def test_verse_number_field_has_min_value(self):
        self.assertIsNotNone(ValidationExplanationCSVForm.base_fields['verse_number'].min_value)

    def test_verse_number_field_min_value_is_1(self):
        self.assertEqual(1, ValidationExplanationCSVForm.base_fields['verse_number'].min_value)

    # Test Chapter_number

    def test_form_has_chapter_number(self):
        self.assertIn('chapter_number', ValidationExplanationCSVForm.base_fields)

    def test_chapter_number_field_is_instance_of_integer_field(self):
        self.assertIsInstance(ValidationExplanationCSVForm.base_fields['chapter_number'], forms.IntegerField)

    def test_chapter_number_field_has_required(self):
        self.assertIsNotNone(ValidationExplanationCSVForm.base_fields['chapter_number'].required)

    def test_chapter_number_field_required_is_true(self):
        self.assertTrue(ValidationExplanationCSVForm.base_fields['chapter_number'].required)

    def test_chapter_number_field_has_max_value(self):
        self.assertIsNotNone(ValidationExplanationCSVForm.base_fields['chapter_number'].max_value)

    def test_chapter_number_field_max_value_is_20(self):
        self.assertEqual(20, ValidationExplanationCSVForm.base_fields['chapter_number'].max_value)

    def test_chapter_number_field_has_min_value(self):
        self.assertIsNotNone(ValidationExplanationCSVForm.base_fields['chapter_number'].min_value)

    def test_chapter_number_field_min_value_is_1(self):
        self.assertEqual(1, ValidationExplanationCSVForm.base_fields['chapter_number'].min_value)

    # Test Page_number

    def test_form_has_page_number(self):
        self.assertIn('page_number', ValidationExplanationCSVForm.base_fields)

    def test_page_number_field_is_instance_of_integer_field(self):
        self.assertIsInstance(ValidationExplanationCSVForm.base_fields['page_number'], forms.IntegerField)

    def test_page_number_field_has_required(self):
        self.assertIsNotNone(ValidationExplanationCSVForm.base_fields['page_number'].required)

    def test_page_number_field_required_is_true(self):
        self.assertTrue(ValidationExplanationCSVForm.base_fields['page_number'].required)

    def test_page_number_field_has_min_value(self):
        self.assertIsNotNone(ValidationExplanationCSVForm.base_fields['page_number'].min_value)

    def test_page_number_field_min_value_is_1(self):
        self.assertEqual(1, ValidationExplanationCSVForm.base_fields['page_number'].min_value)

    # Test text

    def test_form_has_text(self):
        self.assertIn('text', ValidationExplanationCSVForm.base_fields)

    def test_text_field_is_instance_of_char_field(self):
        self.assertIsInstance(ValidationExplanationCSVForm.base_fields['text'], forms.CharField)

    def test_text_field_has_required(self):
        self.assertIsNotNone(ValidationExplanationCSVForm.base_fields['text'].required)

    def test_text_field_required_is_true(self):
        self.assertTrue(ValidationExplanationCSVForm.base_fields['text'].required)


class ValidationExplanationCSVFormValidationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'verse_number': '150',
            'chapter_number': 10,
            'page_number': 5,
            'text': "it's a tafseer",
            'verse_text': "it's a verses",
        }

    # Test Verse_number

    def test_it_throws_error_if_verse_number_has_no_value(self):
        self.data.pop('verse_number')
        form = ValidationExplanationCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_verse_number_value_is_less_than_minimum(self):
        self.data.update({'verse_number': 0})
        form = ValidationExplanationCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_verse_number_value_is_greater_than_maximum(self):
        self.data.update({'verse_number': 310})
        form = ValidationExplanationCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'max_value')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message,
                          _('Ensure this value is less than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_chapter_number_has_no_value(self):
        self.data.pop('chapter_number')
        form = ValidationExplanationCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_chapter_number_value_is_less_than_minimum(self):
        self.data.update({'chapter_number': 0})
        form = ValidationExplanationCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_chapter_number_value_is_greater_than_maximum(self):
        self.data.update({'chapter_number': 30})
        form = ValidationExplanationCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'max_value')
        self.assertEquals(form.errors.as_data()['chapter_number'][0].message,
                          _('Ensure this value is less than or equal to %(limit_value)s.'))

    # Test Page_number

    def test_it_throws_error_if_page_number_has_no_value(self):
        self.data.pop('page_number')
        form = ValidationExplanationCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['page_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['page_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_page_number_value_is_less_than_minimum(self):
        self.data.update({'page_number': 0})
        form = ValidationExplanationCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['page_number'][0].code, 'min_value')
        self.assertEquals(form.errors.as_data()['page_number'][0].message,
                          _('Ensure this value is greater than or equal to %(limit_value)s.'))

    def test_it_throws_error_if_text_has_no_value(self):
        self.data.pop('text')
        form = ValidationExplanationCSVForm(data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['text'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['text'][0].message, _('This field is required.'))
