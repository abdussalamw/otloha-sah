import inspect

from django import forms
from django.conf import settings
from django.db import models
from django.test import TestCase
from django.utils import translation
from django.utils.translation import gettext as _
from translation.models import TranslatableModel

from apps.narrations.factories import NarrationFactory
from apps.narrations.models import Narration


class NarrationModelStructureTestCase(TestCase):
    def setUp(self):
        translation.activate(settings.LANGUAGE_CODE)

    def test_narration_model_extends_django_Model(self):
        self.assertTrue(issubclass(Narration, TranslatableModel))

    def test_meta_verbose_name_equals_narration(self):
        self.assertEqual(Narration._meta.verbose_name, _("Narration"))

    def test_meta_verbose_name_plural_equals_narrations(self):
        self.assertEqual(Narration._meta.verbose_name_plural, _("Narrations"))

    def test_it_has_translatable_dict(self):
        self.assertTrue(hasattr(Narration, 'translatable'))

    def test_translatable_object_contains_name(self):
        self.assertIn('name', Narration.translatable.keys())

    def test_translatable_object_name_equals_object(self):
        self.assertTrue(isinstance(Narration.translatable.get('name'), dict))

    def test_translatable_object_name_contains_field(self):
        self.assertIn('field', Narration.translatable.get('name'))

    def test_translatable_object_name_field_equals_charfield(self):
        field = Narration.translatable.get('name').get('field')
        self.assertEqual(field, forms.CharField)

    def test_translatable_object_contains_description(self):
        self.assertIn('description', Narration.translatable.keys())

    def test_translatable_object_description_equals_object(self):
        self.assertTrue(isinstance(Narration.translatable.get('description'), dict))

    def test_translatable_object_description_contains_field(self):
        self.assertIn('field', Narration.translatable.get('description'))

    def test_translatable_object_description_field_equals_charfield(self):
        field = Narration.translatable.get('description').get('field')
        self.assertEqual(field, forms.CharField)

    def test_translatable_object_description_contains_widget(self):
        self.assertIn('widget', Narration.translatable.get('description'))

    def test_translatable_object_description_widget_equals_textarea(self):
        field = Narration.translatable.get('description').get('widget')
        self.assertEqual(field, forms.Textarea)

    # Test ID Attribute
    def test_narration_model_has_id_field(self):
        self.assertTrue(hasattr(Narration, 'id'))

    def test_whether_id_field_is_primary_or_not(self):
        field = Narration._meta.get_field('id')
        self.assertTrue(field.primary_key)

    def test_id_field_is_instance_of_big_auto_field(self):
        field = Narration._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    # Test name attribute
    def test_it_has_name_attribute(self):
        self.assertTrue(hasattr(Narration, 'name'))

    def test_name_attribute_is_instance_of_JSONField(self):
        field = Narration._meta.get_field('name')
        self.assertIsInstance(field, models.JSONField)

    def test_name_verbose_name_is_narration(self):
        field = Narration._meta.get_field('name')
        self.assertEqual(field.verbose_name, _('Name'))

    # test description attribute
    def test_narration_model_has_description_attribute(self):
        self.assertTrue(hasattr(Narration, 'description'))

    def test_description_attribute_is_instance_of_JSONField(self):
        field = Narration._meta.get_field('description')
        self.assertIsInstance(field, models.JSONField)

    def test_description_field_blank_is_true(self):
        field = Narration._meta.get_field('description')
        self.assertTrue(field.blank)

    def test_description_field_null_is_true(self):
        field = Narration._meta.get_field('description')
        self.assertTrue(field.null)

    def test_description_field_verbose_name_is_description(self):
        field = Narration._meta.get_field('description')
        self.assertEqual(field.verbose_name, _('Description'))

    # Test created_at attribute
    def test_narration_model_has_created_at_attribute(self):
        self.assertTrue(hasattr(Narration, 'created_at'))

    def test_created_at_attribute_is_instance_of_DateTimeField(self):
        field = Narration._meta.get_field('created_at')
        self.assertIsInstance(field, models.DateTimeField)

    def test_created_at_field_auto_now_add_is_true(self):
        field = Narration._meta.get_field('created_at')
        self.assertTrue(field.auto_now_add)

    def test_created_at_field_blank_equal_true(self):
        field = Narration._meta.get_field('created_at')
        self.assertTrue(field.blank)

    def test_created_at_field_null_equal_true(self):
        field = Narration._meta.get_field('created_at')
        self.assertTrue(field.null)

    # Test updated_at attribute
    def test_narration_model_has_updated_at_attribute(self):
        self.assertTrue(hasattr(Narration, 'updated_at'))

    def test_updated_at_attribute_is_instance_of_DateTimeField(self):
        field = Narration._meta.get_field('updated_at')
        self.assertIsInstance(field, models.DateTimeField)

    def test_updated_at_field_auto_now_is_true(self):
        field = Narration._meta.get_field('updated_at')
        self.assertTrue(field.auto_now)

    def test_updated_at_field_blank_equals_true(self):
        field = Narration._meta.get_field('updated_at')
        self.assertTrue(field.blank)

    def test_updated_at_field_null_equals_true(self):
        field = Narration._meta.get_field('updated_at')
        self.assertTrue(field.null)

    # Test is active field
    def test_it_has_is_active_field(self):
        self.assertTrue(hasattr(Narration, 'is_active'))

    def test_is_active_is_instance_of_boolean_field(self):
        field = Narration._meta.get_field('is_active')
        self.assertIsInstance(field, models.BooleanField)

    def test_is_active_has_default_attribute_equals_true(self):
        self.assertTrue(Narration.is_active)

    def test_is_active_has_verbose_name_equals_is_active(self):
        field = Narration._meta.get_field('is_active')
        self.assertEqual(field.verbose_name, _("Is Active"))

    # Test __str__    
    def test_narration_has___str___attribute(self):
        self.assertTrue(hasattr(Narration, '__str__'))

    def test___str___is_callable(self):
        self.assertTrue(callable(getattr(Narration, '__str__')))

    def test__str__signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(Narration.__str__)[0]
        self.assertEqual(actual_signature, expected_signature)


class NarrationModelStrTestCase(TestCase):
    def setUp(self):
        translation.activate(settings.LANGUAGE_ENGLISH)
        self.narration = NarrationFactory(name="newNarration", description="narrationDescription")

    def test___str___returns_super___str___if_name_is_available(self):
        self.assertEqual(self.narration.__class__.__str__(self.narration), str(self.narration))
