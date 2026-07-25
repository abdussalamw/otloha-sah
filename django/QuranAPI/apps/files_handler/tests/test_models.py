import os
import shutil

from django.contrib.contenttypes.models import ContentType
from django.core.files.uploadedfile import SimpleUploadedFile
from django.db import models
from django.test import TestCase, override_settings
from django.utils.translation import gettext_lazy as _

from apps.files_handler.custom_model_fields import GenericFileField
from apps.files_handler.models import File
from apps.quran.factories import BookFactory, NarrationFactory
from apps.quran.models import Book

TEST_DIR = 'test_data'


class FileModelTestCase(TestCase):
    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def setUp(self):
        base_path = os.path.dirname(os.path.realpath(__file__))

        book = BookFactory(narration=NarrationFactory())
        file = open(base_path + '/files/recitations.zip', 'rb')
        self.file_upload = File.objects.create(content_type=ContentType.objects.get_for_model(Book)
                                               , object_id=book.pk,
                                               file=SimpleUploadedFile(content=file.read(), name=file.name,
                                                                       content_type='multipart/form-data'),
                                               file_name='file')

    def tearDown(self):
        try:
            shutil.rmtree(TEST_DIR)
        except OSError:
            pass

    def test_it_extends_models_Model(self):
        self.assertTrue(issubclass(File, models.Model))

    def test_if_it_has_file_field(self):
        self.assertTrue(hasattr(File, 'file'))

    def test_file_extends_generic_file_field(self):
        field = File._meta.get_field('file')
        self.assertIsInstance(field, GenericFileField)

    def test_meta_verbose_name_of_file_field(self):
        field = File._meta.get_field('file')
        self.assertEquals(field.verbose_name, _('file'))

    def test_value_of_the_max_upload_size(self):
        field = File._meta.get_field('file')
        self.assertEquals(field.max_upload_size, 429916160)

    def test_value_of_the_content_types(self):
        field = File._meta.get_field('file')
        self.assertEquals(field.content_types,
                          ['application/vnd.ms-excel', 'text/csv', 'application/zip',
                           'application/x-7z-compressed', 'application/vnd.rar'])

    def test_if_it_has_file_name_field(self):
        self.assertTrue(hasattr(File, 'file_name'))

    def test_file_name_extends_CharField(self):
        field = File._meta.get_field('file_name')
        self.assertIsInstance(field, models.CharField)

    def test_meta_verbose_name_of_file_name_field(self):
        field = File._meta.get_field('file_name')
        self.assertEquals(field.verbose_name, _('File Name'))

    def test_value_of_the_max_length_in_file_name_field(self):
        field = File._meta.get_field('file_name')
        self.assertEquals(field.max_length, 200)

    def test_file_name_field_set_to_null_equal_true(self):
        field = File._meta.get_field('file_name')
        self.assertTrue(field.null)

    def test_file_name_field_set_to_blank_equal_true(self):
        field = File._meta.get_field('file_name')
        self.assertTrue(field.blank)

    def test_if_it_has_is_processed_field(self):
        self.assertTrue(hasattr(File, 'is_processed'))

    def test_is_processed_extends_CharField(self):
        field = File._meta.get_field('is_processed')
        self.assertIsInstance(field, models.BooleanField)

    def test_meta_verbose_name_of_is_processed_field(self):
        field = File._meta.get_field('is_processed')
        self.assertEquals(field.verbose_name, _('Is Processed'))

    def test_value_of_the_default_in_is_processed_field(self):
        field = File._meta.get_field('is_processed')
        self.assertFalse(field.default)

    def test_if_it_has_columns_field(self):
        self.assertTrue(hasattr(File, 'columns'))

    def test_columns_attribute_is_instance_of_JSONField(self):
        field = File._meta.get_field('columns')
        self.assertIsInstance(field, models.JSONField)

    def test_columns_field_set_null_to_false(self):
        field = File._meta.get_field('columns')
        self.assertTrue(field.null)

    def test_columns_field_set_blank_to_false(self):
        field = File._meta.get_field('columns')
        self.assertTrue(field.blank)

    def test_if_it_has_created_at_field(self):
        self.assertTrue(hasattr(File, 'created_at'))

    def test_created_at_field_has_auto_now_add_method(self):
        field = File._meta.get_field('created_at')
        self.assertIn('auto_now_add', field.__dict__)

    def test_if_it_has_content_type_field(self):
        self.assertTrue(hasattr(File, 'content_type'))

    def test_if_it_has_object_id_field(self):
        self.assertTrue(hasattr(File, 'object_id'))

    def test_if_it_has_content_object_field(self):
        self.assertTrue(hasattr(File, 'content_object'))

    def test_narration_has__str__attribute(self):
        self.assertTrue(hasattr(File, '__str__'))

    def test__str__is_callable(self):
        self.assertTrue(callable(getattr(File, '__str__')))

    def test__str__returns_field_if_available(self):
        self.assertEqual('file', str(self.file_upload))
