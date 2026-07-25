from django import forms
from django.test import TestCase

from apps.files_handler.forms import FilesForm


class FileFormStructureTestCase(TestCase):
    def test_it_subclass_of_ModelForm(self):
        self.assertTrue(issubclass(FilesForm, forms.Form))

    def test_it_has_file_field(self):
        self.assertIn('file', FilesForm().fields)
