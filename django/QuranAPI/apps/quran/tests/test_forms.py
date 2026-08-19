from django.forms import ModelForm
from django import forms
from django.forms import ModelForm
from django.test import TestCase
from django.utils.translation import gettext as _
from translation.forms import TranslatableModelForm

from apps.narrations.factories import NarrationFactory
from apps.quran.forms import BookForm
from apps.quran.models import Book

TEST_DIR = 'test_data'


class BookFormTestCase(TestCase):

    def setUp(self):
        self.narration = NarrationFactory()

    def test_it_extend_TranslatableModelForm(self):
        self.assertTrue(isinstance(BookForm(), TranslatableModelForm))

    def test_it_has_meta_class(self):
        self.assertIn('Meta', BookForm.__dict__)

    def test_it_use_Book_model(self):
        self.assertEqual(Book, BookForm.Meta.model)

    def test_form_fields(self):
        self.assertEqual(BookForm.Meta.fields, ['name', 'narration'])

    def test_name_field_is_instance_of_CharField(self):
        form = BookForm(data={'name': 'name', 'narration': self.narration})
        self.assertIsInstance(form.fields['name'], forms.CharField)

    def test_naration_field_is_instance_of_ForeignKey(self):
        form = BookForm(data={'name': 'name', 'narration': self.narration})
        self.assertIsInstance(form.fields['narration'], forms.ModelChoiceField)

    def test_name_field_is_required(self):
        form = BookForm(data={'name': '', 'narration': self.narration})
        self.assertFalse(form.is_valid())
        self.assertEqual(form.errors.as_data()['name'][0].code, 'required')

    def test_narration_field_is_required(self):
        form = BookForm(data={'name': 'name', 'narration': ''})
        self.assertFalse(form.is_valid())
        self.assertEqual(form.errors.as_data()['narration'][0].code, 'required')

    def test_it_raise_error_message_for_name_field(self):
        form = BookForm(data={'name': '', 'narration': self.narration})
        self.assertFalse(form.is_valid())
        self.assertEqual(form.errors['name'][0], _('This field is required.'))

    def test_it_raise_error_message_for_narration_field(self):
        form = BookForm(data={'name': 'name', 'narration': ''})
        self.assertFalse(form.is_valid())
        self.assertEqual(form.errors['narration'][0], _('This field is required.'))

    def test_it_render_html_field_with_name_name(self):
        form = BookForm()
        self.assertIn('name', form.fields)

    def test_it_render_html_field_with_name_narration(self):
        form = BookForm()
        self.assertIn('narration', form.fields)


# class BookImagesUploadFormStructureTestCase(TestCase):
#     def test_it_extends_model_form(self):
#         self.assertTrue(issubclass(BookImagesUploadForm, ModelForm))
#
#     def test_it_use_BookImagesUploadModel(self):
#         self.assertEqual(BookImagesUploadForm._meta.model, BookImageUpload)
#
#     def test_fields_in_the_form(self):
#         self.assertEqual(BookImagesUploadForm._meta.fields, ['file'])
#