# from django.db import models
# from django.test import TestCase
# from django.utils.translation import gettext as _
#
# from apps.quran.models import Book, BookImagePatterns
#
#
# class BookModelTestCase(TestCase):
#     def test_it_extends_models_Model(self):
#         self.assertIsInstance(Book(), models.Model)
#
#     def test_narration_has__str__attribute(self):
#         self.assertTrue(hasattr(Book, '__str__'))
#
#     def test__str__is_callable(self):
#         self.assertTrue(callable(getattr(Book, '__str__')))
#
#     def test_meta_verbose_name_is_book(self):
#         self.assertEquals(Book._meta.verbose_name, _('Book'))
#
#     def test_meta_verbose_name_plural_is_book(self):
#         self.assertEquals(Book._meta.verbose_name_plural, _('Books'))
#
#     def test_if_it_has_id_field(self):
#         self.assertTrue(hasattr(Book, 'id'))
#
#     def test_id_extends_BigAutoField(self):
#         id_field = Book._meta.get_field('id')
#         self.assertIsInstance(id_field, models.BigAutoField)
#
#     def test_if_id_field_extends_primary_key(self):
#         id_field = Book._meta.get_field('id')
#         self.assertTrue(id_field.primary_key)
#
#     def test_if_it_has_name_field(self):
#         self.assertTrue(hasattr(Book, 'name'))
#
#     def test_name_attribute_is_instance_of_charField(self):
#         name = Book._meta.get_field('name')
#         self.assertIsInstance(name, models.JSONField)
#
#     def test_name_verbose_name_value_is_Name(self):
#         name = Book._meta.get_field('name')
#         self.assertEquals(name.verbose_name, _('Name'))
#
#     def test_if_it_has_narration_field(self):
#         self.assertTrue(hasattr(Book, 'narration'))
#
#     def test_if_narration_field_is_foreign_key_to_Narration_model(self):
#         narration = Book._meta.get_field('narration')
#         self.assertIsInstance(narration, models.ForeignKey)
#
#     def test_if_narration_foreign_key_has_on_delete_parameter(self):
#         narration = Book._meta.get_field('narration')
#         self.assertEqual(narration.remote_field.related_name, "book_narration")
#
#     def test_if_narration_foreign_key_has_on_null_parameter_set_to_true(self):
#         narration = Book._meta.get_field('narration')
#         self.assertTrue(narration.remote_field.null)
#
#     def test_if_created_at_field_exists(self):
#         self.assertTrue(hasattr(Book, 'created_at'))
#
#     def test_created_at_field_has_auto_now_add_set_to_true(self):
#         field = Book._meta.get_field('created_at')
#         self.assertTrue(field.auto_now_add)
#
#     def test_created_at_field_has_blank_set_to_true(self):
#         field = Book._meta.get_field('created_at')
#         self.assertTrue(field.blank)
#
#     def test_if_updated_at_field_exists(self):
#         self.assertTrue(hasattr(Book, 'updated_at'))
#
#     def test_updated_at_field_has_auto_now_set_to_true(self):
#         field = Book._meta.get_field('updated_at')
#         self.assertTrue(field.auto_now)
#
#     def test_updated_at_field_has_null_set_to_true(self):
#         field = Book._meta.get_field('updated_at')
#         self.assertTrue(field.null)
#
#     def test_updated_at_field_has_blank_set_to_true(self):
#         field = Book._meta.get_field('updated_at')
#         self.assertTrue(field.blank)
#
#
# class BookCSVUploadsTestCase(TestCase):
#     def test_it_extends_models_Model(self):
#         self.assertIsInstance(BookCSVUpload(), models.Model)
#
#     def test_meta_verbose_name(self):
#         self.assertEquals(BookCSVUpload._meta.verbose_name, _('Book CSV Uploads'))
#
#     def test_meta_verbose_name_plural(self):
#         self.assertEquals(BookCSVUpload._meta.verbose_name_plural, _('Book CSV Uploads'))
#
#     def test_if_it_has_file_field(self):
#         self.assertTrue(hasattr(BookCSVUpload, 'file'))
#
#     def test_file_attribute_is_instance_of_FileField(self):
#         field = BookCSVUpload._meta.get_field('file')
#         self.assertIsInstance(field, models.FileField)
#
#     def test_file_field_has_upload_to_method(self):
#         field = BookCSVUpload._meta.get_field('file')
#         self.assertIn('upload_to', field.__dict__)
#
#     def test_if_it_has_book_field(self):
#         self.assertTrue(hasattr(BookCSVUpload, 'book'))
#
#     def test_book_attribute_is_instance_of_ForeignKey(self):
#         field = BookCSVUpload._meta.get_field('book')
#         self.assertIsInstance(field, models.ForeignKey)
#
#     def test_book_field_set_null_to_false(self):
#         field = BookCSVUpload._meta.get_field('book')
#         self.assertFalse(field.null)
#
#     def test_book_field_set_blank_to_false(self):
#         field = BookCSVUpload._meta.get_field('book')
#         self.assertFalse(field.blank)
#
#     def test_book_field_has_on_delete_method(self):
#         field = BookCSVUpload._meta.get_field('book')
#         self.assertIn('on_delete', field.remote_field.__dict__)
#
#     def test_book_field_on_delete_set_to_cascade(self):
#         field = BookCSVUpload._meta.get_field('book')
#         self.assertEqual(field.remote_field.on_delete, models.CASCADE)
#
#     def test_book_relation_has_related_with_book_model(self):
#         field = BookCSVUpload._meta.get_field('book')
#         self.assertEqual(field.remote_field.model, Book)
#
#     def test_if_it_has_columns_field(self):
#         self.assertTrue(hasattr(BookCSVUpload, 'columns'))
#
#     def test_columns_attribute_is_instance_of_JSONField(self):
#         field = BookCSVUpload._meta.get_field('columns')
#         self.assertIsInstance(field, models.JSONField)
#
#     def test_columns_field_set_null_to_false(self):
#         field = BookCSVUpload._meta.get_field('columns')
#         self.assertTrue(field.null)
#
#     def test_columns_field_set_blank_to_false(self):
#         field = BookCSVUpload._meta.get_field('columns')
#         self.assertTrue(field.blank)
#
#     def test_if_it_has_created_at_field(self):
#         self.assertTrue(hasattr(BookCSVUpload, 'created_at'))
#
#     def test_created_at_field_has_auto_now_add_method(self):
#         field = BookCSVUpload._meta.get_field('created_at')
#         self.assertIn('auto_now_add', field.__dict__)
#
#     def test_if_it_has_is_active_field(self):
#         self.assertTrue(hasattr(BookCSVUpload, 'is_active'))
#
#     def test_is_active_attribute_is_instance_of_BooleanField(self):
#         field = BookCSVUpload._meta.get_field('is_active')
#         self.assertIsInstance(field, models.BooleanField)
#
#     def test_is_active_attribute_set_default_to_false(self):
#         field = BookCSVUpload._meta.get_field('is_active')
#         self.assertFalse(field.default)
#
#
# class BookImageUploadModelTestCase(TestCase):
#     def test_it_extends_models_Model(self):
#         self.assertIsInstance(BookImageUpload(), models.Model)
#
#     def test_meta_verbose_name(self):
#         self.assertEquals(BookImageUpload._meta.verbose_name, _('Book Images Upload'))
#
#     def test_meta_verbose_name_plural(self):
#         self.assertEquals(BookImageUpload._meta.verbose_name_plural, _('Book Images Uploads'))
#
#     def test_if_it_has_file_field(self):
#         self.assertTrue(hasattr(BookImageUpload, 'file'))
#
#     def test_file_attribute_is_instance_of_FileField(self):
#         field = BookImageUpload._meta.get_field('file')
#         self.assertIsInstance(field, models.FileField)
#
#     def test_file_field_has_upload_to_method(self):
#         field = BookImageUpload._meta.get_field('file')
#         self.assertIn('upload_to', field.__dict__)
#
#     def test_if_it_has_book_field(self):
#         self.assertTrue(hasattr(BookImageUpload, 'book'))
#
#     def test_book_attribute_is_instance_of_ForeignKey(self):
#         field = BookImageUpload._meta.get_field('book')
#         self.assertIsInstance(field, models.ForeignKey)
#
#     def test_book_field_set_null_to_false(self):
#         field = BookImageUpload._meta.get_field('book')
#         self.assertFalse(field.null)
#
#     def test_book_field_set_blank_to_false(self):
#         field = BookImageUpload._meta.get_field('book')
#         self.assertFalse(field.blank)
#
#     def test_book_field_has_on_delete_method(self):
#         field = BookImageUpload._meta.get_field('book')
#         self.assertIn('on_delete', field.remote_field.__dict__)
#
#     def test_book_field_on_delete_set_to_cascade(self):
#         field = BookImageUpload._meta.get_field('book')
#         self.assertEqual(field.remote_field.on_delete, models.CASCADE)
#
#     def test_book_relation_has_related_with_book_model(self):
#         field = BookImageUpload._meta.get_field('book')
#         self.assertEqual(field.remote_field.model, Book)
#
#
# class BookImagePatternsTestCase(TestCase):
#     def test_it_extends_models_Model(self):
#         self.assertIsInstance(BookImagePatterns(), models.Model)
#
#     def test_if_it_has_file_field(self):
#         self.assertTrue(hasattr(BookImagePatterns, 'file'))
#
#     def test_file_attribute_is_instance_of_FileField(self):
#         field = BookImagePatterns._meta.get_field('file')
#         self.assertIsInstance(field, models.FileField)
#
#     def test_file_field_has_upload_to_method(self):
#         field = BookImagePatterns._meta.get_field('file')
#         self.assertIn('upload_to', field.__dict__)
#
#     def test_book_images_uploads_attribute_is_instance_of_ForeignKey(self):
#         field = BookImagePatterns._meta.get_field('book_images_uploads')
#         self.assertIsInstance(field, models.ForeignKey)
#
#     def test_book_images_uploads_field_set_null_to_false(self):
#         field = BookImagePatterns._meta.get_field('book_images_uploads')
#         self.assertFalse(field.null)
#
#     def test_book_images_uploads_field_set_blank_to_false(self):
#         field = BookImagePatterns._meta.get_field('book_images_uploads')
#         self.assertFalse(field.blank)
#
#     def test_book_images_uploads_field_has_on_delete_method(self):
#         field = BookImagePatterns._meta.get_field('book_images_uploads')
#         self.assertIn('on_delete', field.remote_field.__dict__)
#
#     def test_book_images_uploads_field_on_delete_set_to_cascade(self):
#         field = BookImagePatterns._meta.get_field('book_images_uploads')
#         self.assertEqual(field.remote_field.on_delete, models.CASCADE)
#
#     def test_book_images_uploads_relation_has_related_with_book_model(self):
#         field = BookImagePatterns._meta.get_field('book_images_uploads')
#         self.assertEqual(field.remote_field.model, BookImageUpload)
#
#     def test_if_it_has_type_field(self):
#         self.assertTrue(hasattr(BookImagePatterns, 'type'))
#
#     def test_type_attribute_is_instance_of_CharField(self):
#         field = BookImagePatterns._meta.get_field('type')
#         self.assertIsInstance(field, models.CharField)