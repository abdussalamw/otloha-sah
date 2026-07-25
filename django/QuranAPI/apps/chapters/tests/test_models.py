from django import forms
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.db import models
from django.test import TestCase
from django.utils.translation import gettext as _
from translation.models import TranslatableModel

from apps.chapters.factories import ChapterFactory
from apps.chapters.models import Chapter, ChapterModel


class ChapterStructureTestCase(TestCase):
    def test_it_extends_models_model(self):
        self.assertTrue(issubclass(Chapter, TranslatableModel))

    # Test Meta Class for Narration
    def test_meta_verbose_name_equals_narration(self):
        self.assertEqual(Chapter._meta.verbose_name, _("Chapter"))

    def test_meta_verbose_name_plural_equals_narrations(self):
        self.assertEqual(Chapter._meta.verbose_name_plural, _("Chapters"))

    # Test ID field
    def test_if_it_has_id_field(self):
        self.assertTrue(hasattr(Chapter, 'id'))

    def test_id_extends_big_auto_field(self):
        id_field = Chapter._meta.get_field('id')
        self.assertIsInstance(id_field, models.BigAutoField)

    def test_if_id_field_extends_primary_key(self):
        id_field = Chapter._meta.get_field('id')
        self.assertTrue(id_field.primary_key)

    # Test name field
    def test_it_has_name_field(self):
        self.assertTrue(hasattr(Chapter, 'name'))

    def test_name_attribute_is_instance_of_jsonfield(self):
        name = Chapter._meta.get_field('name')
        self.assertIsInstance(name, models.JSONField)

    def test_name_verbose_name_equals_name(self):
        name = Chapter._meta.get_field('name')
        self.assertEqual(name.verbose_name, _('Name'))

    # Test translatable object
    def test_translatable_object_exists(self):
        self.assertTrue(hasattr(Chapter, 'translatable'))

    def test_translatable_object_contains_name(self):
        self.assertIn('name', Chapter.translatable.keys())

    def test_translatable_object_name_equals_object(self):
        self.assertTrue(isinstance(Chapter.translatable.get('name'), dict))

    def test_translatable_object_name_contains_field(self):
        self.assertIn('field', Chapter.translatable.get('name'))

    def test_translatable_object_name_field_equals_charfield(self):
        field = Chapter.translatable.get('name').get('field')
        self.assertEqual(field, forms.CharField)

    # Test origin field
    def test_it_has_origin_field(self):
        self.assertTrue(hasattr(Chapter, 'origin'))

    def test_name_field_has_max_length(self):
        field = Chapter._meta.get_field('origin')
        self.assertTrue(hasattr(field, 'max_length'))

    def test_origin_attribute_is_instance_of_char_field(self):
        field = Chapter._meta.get_field('origin')
        self.assertIsInstance(field, models.CharField)

    def test_origin_attribute_has_max_length_of_50(self):
        field = Chapter._meta.get_field('origin')
        self.assertEqual(field.max_length, 50)

    def test_it_has_origin_makkiah(self):
        self.assertTrue(hasattr(Chapter, 'ORIGIN_MAKKIAH'))

    def test_it_has_origin_madania(self):
        self.assertTrue(hasattr(Chapter, 'ORIGIN_MADANIA'))

    def test_it_has_origins(self):
        self.assertTrue(hasattr(Chapter, 'ORIGINS'))

    def test_if_len_of_origins_is_2(self):
        self.assertEqual(len(Chapter.ORIGINS), 2)

    def test_if_origins_returns_tuple_of_tuples(self):
        self.assertEqual(Chapter.ORIGINS, (('makkiah', _('in Makkah')), ('madania', _('in El Madina'))))

    def test_origin_has_choices_of_origins(self):
        field = Chapter._meta.get_field('origin')
        self.assertEqual(field.choices, Chapter.ORIGINS)

    def test_if_origins_has_maka_value(self):
        self.assertEqual(Chapter.ORIGINS[0][1], _('in Makkah'))

    def test_if_origins_has_el_madina_value(self):
        self.assertEqual(Chapter.ORIGINS[1][1], _('in El Madina'))

    # Test chapter_number field
    def test_it_has_chapter_number(self):
        self.assertTrue(hasattr(Chapter, 'chapter_number'))

    def test_chapter_number_extends_PositiveIntegerField(self):
        chapter_number = Chapter._meta.get_field('chapter_number')
        self.assertIsInstance(chapter_number, models.PositiveIntegerField)

    def test_chapter_number_has_db_index_of_true(self):
        chapter_number = Chapter._meta.get_field('chapter_number')
        self.assertTrue(chapter_number.db_index)

    def test_chapter_number_has_verbose_name_equals_name(self):
        field = Chapter._meta.get_field('chapter_number')
        self.assertEqual(field.verbose_name, _('Chapter Number'))

    # Test is active field
    def test_it_has_is_active_field(self):
        self.assertTrue(hasattr(Chapter, 'is_active'))

    def test_is_active_is_instance_of_boolean_field(self):
        field = Chapter._meta.get_field('is_active')
        self.assertIsInstance(field, models.BooleanField)

    def test_is_active_has_default_attribute_equals_true(self):
        self.assertTrue(Chapter.is_active)

    def test_is_active_has_verbose_name_equals_is_active(self):
        field = Chapter._meta.get_field('is_active')
        self.assertEqual(field.verbose_name, _("Is Active"))

    # Test str function structure
    def test_chapter_has__str__attribute(self):
        self.assertTrue(hasattr(Chapter, '__str__'))

    def test__str__is_callable(self):
        self.assertTrue(callable(getattr(Chapter, '__str__')))


class ChapterStrTestCase(TestCase):
    def test___str___returns_parent___str___if_name_is_available(self):
        self.chapter = ChapterFactory(name="Hello", chapter_number=5, origin="in Makkah")
        self.assertEqual(self.chapter.__class__.__str__(self.chapter), str(self.chapter))


class ChapterModelTestCase(TestCase):
    def test_if_chapter_model_extends_models_Model(self):
        self.assertIsInstance(Chapter(), models.Model)

    # Test ID field
    def test_if_chapter_model_has_id_field(self):
        self.assertTrue(hasattr(Chapter, 'id'))

    def test_if_id_fields_extends_BigAutoField(self):
        id_field = Chapter._meta.get_field('id')
        self.assertIsInstance(id_field, models.BigAutoField)

    def test_if_id_field_also_extends_primary_key(self):
        id_field = Chapter._meta.get_field('id')
        self.assertTrue(id_field.primary_key)

    # Test object_id field
    def test_it_has_object_id_field(self):
        self.assertTrue(hasattr(ChapterModel, 'object_id'))

    def test_if_object_id_of_chapter_model_is_instance_of_PositiveIntegerField(self):
        object_id = ChapterModel._meta.get_field('object_id')
        self.assertIsInstance(object_id, models.PositiveIntegerField)

    def test_object_id_null_equals_true(self):
        self.assertTrue(ChapterModel.object_id)

    # Test content_type field
    def test_whether_content_type_field_foreign_key_has_on_delete_parameter_or_not(self):
        content_type = ChapterModel._meta.get_field('content_type')
        self.assertEqual(content_type.remote_field.on_delete, models.CASCADE)

    def test_whether_content_type_field_foreign_key_has_null_parameter_set_to_true_or_not(self):
        content_type = ChapterModel._meta.get_field('content_type')
        self.assertTrue(content_type.null)

    def test_content_type_has_blank_equals_true(self):
        content_type = ChapterModel._meta.get_field('content_type')
        self.assertTrue(content_type.blank)

    def test_content_type_related_model_equals_content_type_model(self):
        content_type = ChapterModel._meta.get_field('content_type')
        self.assertEqual(content_type.related_model, ContentType)

    # Test content_object field
    def test_it_has_content_object_field(self):
        self.assertTrue(hasattr(ChapterModel, 'content_object'))

    def test_it_has_content_object_and_it_is_Generic_forign_key(self):
        content_object = ChapterModel._meta.get_field('content_object')
        self.assertIsInstance(content_object, GenericForeignKey)

    # Test chapter field
    def test_whether_chapter_field_foreign_key_has_on_delete_parameter_or_not(self):
        chapter = ChapterModel._meta.get_field('chapter')
        self.assertEqual(chapter.remote_field.on_delete, models.CASCADE)

    def test_chapter_related_model_equals_chapter_model(self):
        chapter = ChapterModel._meta.get_field('chapter')
        self.assertEqual(chapter.related_model, Chapter)
