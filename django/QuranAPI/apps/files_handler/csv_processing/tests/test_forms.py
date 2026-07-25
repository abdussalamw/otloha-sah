import os
import shutil

from apps.quran.csv_processing.forms import ProcessBookCSVForm
from django import forms
from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import TestCase
from django.test import override_settings
from django.utils.translation import gettext as _

from apps.files_handler.csv_processing.forms import CSVUploadForm
from apps.files_handler.models import File
from apps.quran.factories import BookFactory, NarrationFactory, BookCSVFactory
from apps.quran.models import BookCSVUpload

TEST_DIR = 'test_data'


class CSVUploadFormStructureTestCase(TestCase):
    def test_it_extends_django_model_form(self):
        self.assertTrue(issubclass(CSVUploadForm, forms.ModelForm))

    def test_it_has_meta_class(self):
        self.assertIn('Meta', CSVUploadForm.__dict__)

    def test_it_uses_book_csv_uploads_model_in_meta(self):
        self.assertEquals(CSVUploadForm.Meta.model, File)

    def test_form_fields(self):
        self.assertEqual(CSVUploadForm.Meta.fields, ['file'])

    def test_it_takes_book_instance_as_parameter(self):
        with self.assertRaises(TypeError) as context:
            CSVUploadForm()
            self.assertEquals(_("__init__() missing 1 required positional argument: 'book'"), context.exception)


class CSVUploadFormValidationTestCase(TestCase):
    def setUp(self):
        self.book = BookFactory(narration=NarrationFactory())
        self.data = {
            "file": SimpleUploadedFile("file.csv", b"a,b,c", content_type="text/csv")
        }

    def tearDown(self):
        try:
            shutil.rmtree(TEST_DIR)
        except OSError:
            pass

    def test_file_field_is_required(self):
        self.data.pop('file')
        form = CSVUploadForm(model=self.book, data=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['file'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['file'][0].message, _('This field is required.'))

    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def test_file_field_must_be_csv_file(self):
        self.data.update({'file': SimpleUploadedFile("file.txt", b"file_content")})
        form = CSVUploadForm(model=self.book, files=self.data)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['file'][0].code, 'invalid_file')
        self.assertEquals(form.errors.as_data()['file'][0].message, _('file must be of type csv'))

    def test_it_passes_if_file_is_csv(self):
        print(self.data)
        form = CSVUploadForm(model=self.book, files=self.data)
        print(form.errors.as_data())
        self.assertTrue(form.is_valid())


class CSVUploadFormSaveTestCase(TestCase):
    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def setUp(self):
        base_path = os.path.dirname(os.path.realpath(__file__))
        data = open(base_path + '/sample.csv', 'rb')
        self.file = SimpleUploadedFile(content=data.read(), name=data.name, content_type='text/csv')
        self.book = BookFactory(narration=NarrationFactory())
        self.form = CSVUploadForm(model=self.book, files={"file": self.file})
        self.form.is_valid()
        self.form.save()

    def test_it_saves_passed_book_as_model_book(self):
        self.assertEquals(self.book, self.form.instance.content_object)

    def test_it_saves_file_in_database(self):
        self.assertIsNotNone(self.form.instance.file)

    def test_it_saves_user_choice_column_name_to_its_index(self):
        self.assertDictEqual(self.form.instance.user_choice_columns, {
            "id": 0,
            "jozz": 1,
            "sora": 2,
            "sora_name_en": 3,
            "sora_name_ar": 4,
            "page": 5,
            "line_start": 6,
            "line_end": 7,
            "aya_no": 8,
            "aya_text": 9,
            "aya_text_emlaey": 10,
        })
        # id,jozz,sora,sora_name_en,sora_name_ar,page,line_start,line_end,aya_no,aya_text,aya_text_emlaey

    def test_it_saves_initial_value_for_columns(self):
        self.assertEquals(self.form.instance.columns, {
            "line_start": None,
            "line_end": None,
            "part": None,
            "text": None,
            "uthmanic_text": None,
            "verse_number": None,
            "chapter": None,
            "page": None,
        })

    def test_it_sets_is_processed_to_false(self):
        self.assertFalse(self.form.instance.is_processed)


class ProcessBookCSVFormStructureTestCase(TestCase):
    def setUp(self):
        self.book = BookFactory(narration=NarrationFactory())
        self.book_csv = BookCSVFactory(book=self.book)
        self.form = ProcessBookCSVForm(book_csv=self.book_csv)
        self.user_choices = [(value, key) for key, value in self.book_csv.user_choice_columns.items()]

    def test_it_extends_django_form(self):
        self.assertTrue(issubclass(ProcessBookCSVForm, forms.Form))

    def test_it_takes_book_csv_upload_instance_as_parameter(self):
        with self.assertRaises(TypeError) as context:
            ProcessBookCSVForm()
            self.assertEquals(_("__init__() missing 1 required positional argument: 'book_csv'"), context.exception)

    def test_it_has_book_attribute(self):
        self.assertTrue(hasattr(self.form, 'book'))

    def test_book_attribute_is_equal_to_csv_book(self):
        self.assertEquals(self.form.book, self.book)

    def test_it_has_user_choices_attribute(self):
        self.assertTrue(hasattr(self.form, 'user_choices'))

    def test_user_choices_attribute_is_equal_to_csv_user_choices(self):
        self.assertEquals(self.form.user_choices, self.user_choices)

    def test_it_has_line_start_attribute(self):
        self.assertIn('line_start', self.form.fields)

    def test_line_start_is_instance_of_choice_field(self):
        self.assertIsInstance(self.form.fields['line_start'], forms.ChoiceField)

    def test_line_start_choices_is_equal_to_form_user_choice_columns(self):
        self.assertListEqual(self.form.fields['line_start'].choices, self.user_choices)

    def test_line_start_field_has_label(self):
        self.assertEquals(self.form.fields['line_start'].label, _("Line Start"))

    def test_it_has_line_end_attribute(self):
        self.assertIn('line_end', self.form.fields)

    def test_line_end_is_instance_of_choice_field(self):
        self.assertIsInstance(self.form.fields['line_end'], forms.ChoiceField)

    def test_line_end_choices_is_equal_to_form_user_choice_columns(self):
        self.assertListEqual(self.form.fields['line_end'].choices, self.user_choices)

    def test_line_end_field_has_label(self):
        self.assertEquals(self.form.fields['line_end'].label, _("Line End"))

    def test_it_has_part_attribute(self):
        self.assertIn('part', self.form.fields)

    def test_part_is_instance_of_choice_field(self):
        self.assertIsInstance(self.form.fields['part'], forms.ChoiceField)

    def test_part_choices_is_equal_to_form_user_choice_columns(self):
        self.assertListEqual(self.form.fields['part'].choices, self.user_choices)

    def test_part_field_has_label(self):
        self.assertEquals(self.form.fields['part'].label, _("Part"))

    def test_it_has_text_attribute(self):
        self.assertIn('text', self.form.fields)

    def test_text_is_instance_of_choice_field(self):
        self.assertIsInstance(self.form.fields['text'], forms.ChoiceField)

    def test_text_choices_is_equal_to_form_user_choice_columns(self):
        self.assertListEqual(self.form.fields['text'].choices, self.user_choices)

    def test_text_field_has_label(self):
        self.assertEquals(self.form.fields['text'].label, _("Text"))

    def test_it_has_uthmanic_text_attribute(self):
        self.assertIn('uthmanic_text', self.form.fields)

    def test_uthmanic_text_is_instance_of_choice_field(self):
        self.assertIsInstance(self.form.fields['uthmanic_text'], forms.ChoiceField)

    def test_uthmanic_text_choices_is_equal_to_form_user_choice_columns(self):
        self.assertListEqual(self.form.fields['uthmanic_text'].choices, self.user_choices)

    def test_uthmanic_text_field_has_label(self):
        self.assertEquals(self.form.fields['uthmanic_text'].label, _("Uthmanic Text"))

    def test_it_has_verse_number_attribute(self):
        self.assertIn('verse_number', self.form.fields)

    def test_verse_number_is_instance_of_choice_field(self):
        self.assertIsInstance(self.form.fields['verse_number'], forms.ChoiceField)

    def test_verse_number_choices_is_equal_to_form_user_choice_columns(self):
        self.assertListEqual(self.form.fields['verse_number'].choices, self.user_choices)

    def test_verse_number_field_has_label(self):
        self.assertEquals(self.form.fields['verse_number'].label, _("Verse Number"))

    def test_it_has_chapter_attribute(self):
        self.assertIn('chapter', self.form.fields)

    def test_chapter_is_instance_of_choice_field(self):
        self.assertIsInstance(self.form.fields['chapter'], forms.ChoiceField)

    def test_chapter_choices_is_equal_to_form_user_choice_columns(self):
        self.assertListEqual(self.form.fields['chapter'].choices, self.user_choices)

    def test_chapter_field_has_label(self):
        self.assertEquals(self.form.fields['chapter'].label, _("Chapter"))

    def test_it_has_page_attribute(self):
        self.assertIn('page', self.form.fields)

    def test_page_is_instance_of_choice_field(self):
        self.assertIsInstance(self.form.fields['page'], forms.ChoiceField)

    def test_page_choices_is_equal_to_form_user_choice_columns(self):
        self.assertListEqual(self.form.fields['page'].choices, self.user_choices)

    def test_page_field_has_label(self):
        self.assertEquals(self.form.fields['page'].label, _("Page"))


class ProcessBookCSVFormValidationTestCase(TestCase):
    def setUp(self):
        self.book = BookFactory(narration=NarrationFactory())
        self.book_csv = BookCSVFactory(book=self.book)
        self.data = {
            "line_start": 0,
            "line_end": 1,
            "part": 2,
            "text": 3,
            "uthmanic_text": 4,
            "verse_number": 5,
            "narrations": 6,
            "chapter": 7,
            "page": 8,
        }

    def test_it_throws_error_if_line_start_has_no_value(self):
        self.data.pop('line_start')
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['line_start'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['line_start'][0].message, _('This field is required.'))

    def test_it_throws_error_if_line_start_has_the_same_value_with_any_field(self):
        self.data.update({'line_start': 1})
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['line_start'][0].code, 'duplicated_value')
        self.assertEquals(form.errors.as_data()['line_start'][0].message,
                          _('You selected this value for another field.'))

    def test_it_throws_error_if_line_end_has_no_value(self):
        self.data.pop('line_end')
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['line_end'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['line_end'][0].message, _('This field is required.'))

    def test_it_throws_error_if_line_end_has_the_same_value_with_any_field(self):
        self.data.update({'line_end': 0})
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['line_end'][0].code, 'duplicated_value')
        self.assertEquals(form.errors.as_data()['line_end'][0].message,
                          _('You selected this value for another field.'))

    def test_it_throws_error_if_part_has_no_value(self):
        self.data.pop('part')
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['part'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['part'][0].message, _('This field is required.'))

    def test_it_throws_error_if_part_has_the_same_value_with_any_field(self):
        self.data.update({'part': 0})
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['part'][0].code, 'duplicated_value')
        self.assertEquals(form.errors.as_data()['part'][0].message,
                          _('You selected this value for another field.'))

    def test_it_throws_error_if_text_has_no_value(self):
        self.data.pop('text')
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['text'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['text'][0].message, _('This field is required.'))

    def test_it_throws_error_if_text_has_the_same_value_with_any_field(self):
        self.data.update({'text': 0})
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['text'][0].code, 'duplicated_value')
        self.assertEquals(form.errors.as_data()['text'][0].message,
                          _('You selected this value for another field.'))

    def test_it_throws_error_if_uthmanic_text_has_no_value(self):
        self.data.pop('uthmanic_text')
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['uthmanic_text'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['uthmanic_text'][0].message, _('This field is required.'))

    def test_it_throws_error_if_uthmanic_text_has_the_same_value_with_any_field(self):
        self.data.update({'uthmanic_text': 0})
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['uthmanic_text'][0].code, 'duplicated_value')
        self.assertEquals(form.errors.as_data()['uthmanic_text'][0].message,
                          _('You selected this value for another field.'))

    def test_it_throws_error_if_verse_number_has_no_value(self):
        self.data.pop('verse_number')
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message, _('This field is required.'))

    def test_it_throws_error_if_verse_number_has_the_same_value_with_any_field(self):
        self.data.update({'verse_number': 0})
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['verse_number'][0].code, 'duplicated_value')
        self.assertEquals(form.errors.as_data()['verse_number'][0].message,
                          _('You selected this value for another field.'))

    def test_it_throws_error_if_chapter_has_no_value(self):
        self.data.pop('chapter')
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['chapter'][0].message, _('This field is required.'))

    def test_it_throws_error_if_chapter_has_the_same_value_with_any_field(self):
        self.data.update({'chapter': 0})
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter'][0].code, 'duplicated_value')
        self.assertEquals(form.errors.as_data()['chapter'][0].message,
                          _('You selected this value for another field.'))

    def test_it_throws_error_if_page_has_no_value(self):
        self.data.pop('page')
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['page'][0].code, 'required')
        self.assertEquals(form.errors.as_data()['page'][0].message, _('This field is required.'))

    def test_it_throws_error_if_page_has_the_same_value_with_any_field(self):
        self.data.update({'page': 0})
        form = ProcessBookCSVForm(data=self.data, book_csv=self.book_csv)
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['page'][0].code, 'duplicated_value')
        self.assertEquals(form.errors.as_data()['page'][0].message,
                          _('You selected this value for another field.'))


class ProcessBookCSVFormSaveTestCase(TestCase):
    maxDiff = None

    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def setUp(self):
        base_path = os.path.dirname(os.path.realpath(__file__))
        data = open(base_path + '/sample.csv', 'rb')
        self.file = SimpleUploadedFile(content=data.read(), name=data.name, content_type='multipart/form-data')
        self.book = BookFactory(narration=NarrationFactory())
        self.book_csv = BookCSVFactory(book=self.book, file=self.file)
        self.book_csv_upload = BookCSVUpload.objects.first()
        self.data = {
            "line_start": 0,
            "line_end": 1,
            "part": 2,
            "text": 3,
            "uthmanic_text": 4,
            "verse_number": 5,
            "chapter": 7,
            "page": 8,
        }
        self.form = ProcessBookCSVForm(book_csv=self.book_csv, data=self.data)
        self.form.is_valid()
        self.form.save()

    def test_it_saves_columns_values_to_book_csv(self):
        self.assertDictEqual(self.book_csv.columns, self.data)
