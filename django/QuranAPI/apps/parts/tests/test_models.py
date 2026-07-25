from django import forms
from django.contrib.contenttypes.fields import GenericRelation
from django.db import models
from django.test import TestCase
from django.utils.translation import gettext as _
from translation.models import TranslatableModel

from apps.chapters.models import ChapterModel
from apps.parts.factories import PartFactory
from apps.parts.models import Part


class PartModelTestCase(TestCase):
    def test_it_extends_models_Model(self):
        self.assertTrue(issubclass(Part, TranslatableModel))

    # Test ID field
    def test_if_it_has_id_field(self):
        self.assertTrue(hasattr(Part, 'id'))

    def test_id_extends_BigAutoField(self):
        field = Part._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    def test_if_id_field_extends_primary_key(self):
        field = Part._meta.get_field('id')
        self.assertTrue(field.primary_key)

    # Test name field
    def test_it_has_name_field(self):
        self.assertTrue(hasattr(Part, 'name'))

    def test_name_attribute_is_instance_of_json(self):
        name = Part._meta.get_field('name')
        self.assertIsInstance(name, models.JSONField)

    # Test alias field
    def test_if_it_has_alias_field(self):
        self.assertTrue(hasattr(Part, 'alias'))

    def test_alias_attribute_is_instance_of_json(self):
        name = Part._meta.get_field('alias')
        self.assertIsInstance(name, models.JSONField)

    def test_alias_attribute_has_blank_set_to_true(self):
        name = Part._meta.get_field('alias')
        self.assertTrue(name.blank)

    def test_alias_attribute_has_null_set_to_true(self):
        name = Part._meta.get_field('alias')
        self.assertTrue(name.null)

    # Test translatable object
    def test_it_has_translatable_object(self):
        self.assertTrue(hasattr(Part, 'translatable'))

    def test_translatable_object_is_instance_of_dict(self):
        self.assertIsInstance(Part.translatable, dict)

    def test_translatable_object_contains_name(self):
        self.assertIn('name', Part.translatable.keys())

    def test_translatable_object_name_equals_object(self):
        self.assertTrue(isinstance(Part.translatable.get('name'), dict))

    def test_translatable_object_name_contains_field(self):
        self.assertIn('field', Part.translatable.get('name'))

    def test_translatable_object_name_field_equals_charfield(self):
        field = Part.translatable.get('name').get('field')
        self.assertEqual(field, forms.CharField)

    def test_translatable_object_contains_alias(self):
        self.assertIn('alias', Part.translatable.keys())

    def test_translatable_object_alias_equals_object(self):
        self.assertTrue(isinstance(Part.translatable.get('alias'), dict))

    def test_translatable_object_alias_contains_field(self):
        self.assertIn('field', Part.translatable.get('alias'))

    def test_translatable_object_alias_field_equals_charfield(self):
        field = Part.translatable.get('alias').get('field')
        self.assertEqual(field, forms.CharField)

    # Test part_number field
    def test_it_has_part_number_field(self):
        self.assertTrue(hasattr(Part, 'part_number'))

    def test_part_number_attribute_is_instance_of_positive_integer_field(self):
        name = Part._meta.get_field('part_number')
        self.assertIsInstance(name, models.PositiveIntegerField)

    # Test created_at field
    def test_it_has_created_at_field(self):
        self.assertTrue(hasattr(Part, 'created_at'))

    def test_created_at_is_instance_of_date_time_field(self):
        field = Part._meta.get_field('created_at')
        self.assertIsInstance(field, models.DateTimeField)

    def test_created_at_has_auto_now_add_equals_true(self):
        field = Part._meta.get_field('created_at')
        self.assertTrue(field.auto_now_add)

    def test_created_at_field_has_blank_set_to_true(self):
        field = Part._meta.get_field('created_at')
        self.assertTrue(field.blank)

    def test_create_at_at_verbose_name_equals_created_at(self):
        field = Part._meta.get_field('created_at')
        self.assertEqual(field.verbose_name, _('Created At'))

    # Test updated_at field
    def test_it_has_updated_at_field(self):
        self.assertTrue(hasattr(Part, 'updated_at'))

    def test_updated_at_is_instance_of_date_time_field(self):
        field = Part._meta.get_field('updated_at')
        self.assertIsInstance(field, models.DateTimeField)

    def test_updated_at_field_has_auto_now_set_to_true(self):
        field = Part._meta.get_field('updated_at')
        self.assertTrue(field.auto_now)

    def test_updated_at_field_has_blank_set_to_true(self):
        field = Part._meta.get_field('updated_at')
        self.assertTrue(field.blank)

    def test_updated_at_verbose_name_equals_updated_at(self):
        field = Part._meta.get_field('updated_at')
        self.assertEqual(field.verbose_name, _('Updated At'))

    # Test chapter field
    def test_it_has_chapter_field(self):
        self.assertTrue(hasattr(Part, 'chapter'))

    def test_chapter_is_Generic_relation(self):
        field = Part._meta.get_field('chapter')
        self.assertIsInstance(field, GenericRelation)

    def test_chapter_related_model_equals_chapter_model(self):
        chapter = Part._meta.get_field('chapter')
        self.assertEqual(chapter.related_model, ChapterModel)

    def test_chapter_has_related_query_name(self):
        chapter = Part._meta.get_field('chapter')
        self.assertEqual(chapter.remote_field.related_query_name, "part")

    def test_chapter_has_blank_equals_true(self):
        field = Part._meta.get_field('chapter')
        self.assertTrue(field.blank)

    def test_chapter_has_null_equals_true(self):
        field = Part._meta.get_field('chapter')
        self.assertTrue(field.null)

    # Test is active field
    def test_it_has_is_active_field(self):
        self.assertTrue(hasattr(Part, 'is_active'))

    def test_is_active_is_instance_of_boolean_field(self):
        field = Part._meta.get_field('is_active')
        self.assertIsInstance(field, models.BooleanField)

    def test_is_active_has_default_attribute_equals_true(self):
        self.assertTrue(Part.is_active)

    def test_is_active_has_verbose_name_equals_is_active(self):
        field = Part._meta.get_field('is_active')
        self.assertEqual(field.verbose_name, _("Is Active"))

    # Test str function structure
    def test_chapter_has__str__attribute(self):
        self.assertTrue(hasattr(Part, '__str__'))

    def test__str__is_callable(self):
        self.assertTrue(callable(getattr(Part, '__str__')))


class PartStrTestCase(TestCase):
    def test___str___returns_parent___str___if_name_is_available(self):
        self.part = PartFactory(name="Hello", alias="test", part_number=2)
        self.assertEqual(self.part.__class__.__str__(self.part), str(self.part))
