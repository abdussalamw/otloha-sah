from django import forms
from django.db import models
from django.test import TestCase
from django.utils.translation import gettext_lazy as _
from translation.models import TranslatableModel

from apps.recitations.factories import ReciterFactory
from apps.recitations.models import Reciter


class ReciterModelTestCase(TestCase):
    def test_model_inherited_modelsModel(self):
        self.assertTrue(issubclass(Reciter, TranslatableModel))

    def test_Reciter_model_has_class_meta(self):
        self.assertIn('_meta', Reciter.__dict__)

    def test_Reciter_model_verbose_field_value_is_reciter(self):
        self.assertEqual(Reciter._meta.verbose_name, _('Reciter'))

    def test_Reciter_model_verbose_name_plural_field_value_is_Reciters(self):
        self.assertEqual(Reciter._meta.verbose_name_plural, _('Reciters'))

    def test_it_contains_translatable_attribute(self):
        self.assertTrue(hasattr(Reciter(), 'translatable'))

    def test_translatable_attribute_has_name_key(self):
        self.assertIn('name', getattr(Reciter, 'translatable'))

    def test_translatable_name_has_field_key(self):
        self.assertIn('field', Reciter.translatable['name'])

    def test_translatable_name_field_value_is_forms_char_field(self):
        self.assertEqual(Reciter.translatable['name']['field'], forms.CharField)

    def test_it_contains_id_attribute(self):
        self.assertTrue(hasattr(Reciter, 'id'))

    def test_id_field_is_instance_of_BigAutoField(self):
        field = Reciter._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    def test_id_field_is_primary_attribute_set_to_true(self):
        field = Reciter._meta.get_field('id')
        self.assertTrue(field.primary_key)

    def test_it_contains_name_attribute(self):
        self.assertTrue(hasattr(Reciter, 'name'))

    def test_name_extends_JSONField(self):
        field = Reciter._meta.get_field('name')
        self.assertIsInstance(field, models.JSONField)

    def test_name_field_is_set_null_to_false(self):
        field = Reciter._meta.get_field('name')
        self.assertFalse(field.null)

    def test_name_field_is_set_blank_to_false(self):
        field = Reciter._meta.get_field('name')
        self.assertFalse(field.blank)

    def test_name_field_verbose_name(self):
        field = Reciter._meta.get_field('name')
        self.assertEqual(field.verbose_name, _('Name'))

    def test_model_has___str___method(self):
        self.assertTrue(hasattr(Reciter(), '__str__'))

    def test___str___is_callable(self):
        self.assertTrue(callable(getattr(Reciter, '__str__')))

    def test_if_created_at_field_exists(self):
        self.assertTrue(hasattr(Reciter, 'created_at'))

    def test_created_at_extends_date_time_field(self):
        field = Reciter._meta.get_field('created_at')
        self.assertIsInstance(field, models.DateField)

    def test_created_at_field_has_auto_created_set_to_false(self):
        field = Reciter._meta.get_field('created_at')
        self.assertFalse(field.auto_created)

    def test_created_at_field_has_blank_set_to_true(self):
        field = Reciter._meta.get_field('created_at')
        self.assertTrue(field.blank)

    def test_if_updated_at_field_exists(self):
        self.assertTrue(hasattr(Reciter, 'updated_at'))

    def test_updated_at_field_has_auto_now_set_to_true(self):
        field = Reciter._meta.get_field('updated_at')
        self.assertTrue(field.auto_now)

    def test_updated_at_field_has_null_set_to_false(self):
        field = Reciter._meta.get_field('updated_at')
        self.assertFalse(field.null)

    def test_updated_at_field_has_blank_set_to_true(self):
        field = Reciter._meta.get_field('updated_at')
        self.assertTrue(field.blank)


class ReciterModelStrTestCase(TestCase):
    def test_it_returns_reciter_name(self):
        reciter = ReciterFactory()
        self.assertEqual(reciter.__class__.__str__(reciter), str(reciter.translated_name))
