import inspect

from django import forms
from django.db import models
from django.test import TestCase
from django.utils.translation import gettext as _
from translation.models import TranslatableModel

from apps.explanations.factories import ExplanationFactory
from apps.explanations.models import Explanation, ExplanationVerse
from apps.narrations.models import Narration


class ExplanationModelStructureTestCase(TestCase):
    """
    id
    translatable
    name
    narrations
    csv_form
    csv_process_function
    csv_columns_initial_value
    """

    # Test Model

    def test_it_extends_django_model(self):
        self.assertTrue(issubclass(Explanation, TranslatableModel))

    def test_meta_verbose_name_is_explanation(self):
        self.assertEquals(Explanation._meta.verbose_name, _('Explanation'))

    def test_meta_verbose_name_plural_is_explanations(self):
        self.assertEquals(Explanation._meta.verbose_name_plural, _('Explanations'))

    # Test ID

    def test_if_it_has_id_field(self):
        self.assertTrue(hasattr(Explanation, 'id'))

    def test_id_extends_BigAutoField(self):
        id_field = Explanation._meta.get_field('id')
        self.assertIsInstance(id_field, models.BigAutoField)

    def test_if_id_field_extends_primary_key(self):
        id_field = Explanation._meta.get_field('id')
        self.assertTrue(id_field.primary_key)

    # Test Translatable

    def test_explanation_has_translatable_attribute(self):
        self.assertTrue(hasattr(Explanation, 'translatable'))

    def test_if_translatable_has_1_keys(self):
        self.assertEqual(len(Explanation.translatable), 1)

    def test_if_translatable_has_name_key(self):
        self.assertIn('name', Explanation.translatable.keys())

    def test_if_name_key_has_field_key(self):
        self.assertIn('field', Explanation.translatable['name'].keys())

    def test_if_field_key_in_name_key_of_translatable_extends_forms_CharField(self):
        self.assertEquals(Explanation.translatable['name']['field'], forms.CharField)

    # Test Name

    def test_if_it_has_name_field(self):
        self.assertTrue(hasattr(Explanation, 'name'))

    def test_name_attribute_is_instance_of_json_field(self):
        name = Explanation._meta.get_field('name')
        self.assertIsInstance(name, models.JSONField)

    def test_name_field_null_value_is_equal_to_true(self):
        field = Explanation._meta.get_field('name')
        self.assertTrue(field.null)

    def test_name_field_blank_value_is_equal_to_true(self):
        field = Explanation._meta.get_field('name')
        self.assertTrue(field.blank)

    def test_name_verbose_name_value_is_Explanation_Name(self):
        name = Explanation._meta.get_field('name')
        self.assertEquals(name.verbose_name, _('Explanation Name'))

    # Test Narration

    def test_if_it_has_narration_field(self):
        self.assertTrue(hasattr(Explanation, 'narration'))

    def test_if_narration_field_is_foreign(self):
        narration = Explanation._meta.get_field('narration')
        self.assertIsInstance(narration, models.ForeignKey)

    def test_narration_field_is_related_to_narration_model(self):
        field = Explanation._meta.get_field("narration")
        self.assertEquals(field.__dict__['related_model'], Narration)

    def test_narration_field_on_delete_attribute_is_set_null(self):
        field = Explanation._meta.get_field("narration")
        self.assertEquals(field.__dict__['remote_field'].__dict__['on_delete'], models.SET_NULL)

    def test_if_narration_foreign_key_has_on_null_parameter_set_to_true(self):
        narration = Explanation._meta.get_field('narration')
        self.assertTrue(narration.remote_field.null)

    def test_narration_field_null_value_is_equal_to_true(self):
        field = Explanation._meta.get_field('narration')
        self.assertTrue(field.null)

    def test_narration_field_blank_value_is_equal_to_true(self):
        field = Explanation._meta.get_field('narration')
        self.assertTrue(field.blank)

    def test_narration_foreign_key_related_name_is_explanation_narration(self):
        narration = Explanation._meta.get_field('narration')
        self.assertEqual(narration.remote_field.related_name, "explanation_narration")

    def test_narration_field_verbose_name_value_is_Narration(self):
        field = Explanation._meta.get_field('narration')
        self.assertEqual(field.verbose_name, _('Narration'))

    # Test CSV_FORM

    # def test_it_has_csv_form_attribute(self):
    #     self.assertTrue(hasattr(Explanation, 'csv_form'))

    # def test_csv_form_field_value(self):
    #     self.assertEqual(Explanation.csv_form, 'apps.explanations.forms.ExplanationCSVForm')
    #
    # # Test CSV_PROCESS_FUNCTION

    # def test_it_has_csv_process_function_attribute(self):
    #     self.assertTrue(hasattr(Explanation, 'csv_process_function'))

    # def test_csv_process_function_field_value(self):
    #     self.assertEqual(Explanation.csv_process_function, 'apps.explanations.tasks.process_csv')

    # Test CSV_COLUMNS_INITIAL_VALUE

    # def test_it_has_csv_columns_initial_value_attribute(self):
    #     self.assertTrue(hasattr(Explanation, 'csv_columns_initial_value'))
    # #
    # def test_csv_columns_initial_value_field_value(self):
    #     self.assertEqual(Explanation.csv_columns_initial_value,
    #                      {
    #                         'text': None,
    #                         "verse_number": None,
    #                         "chapter_number": None,
    #                         "page_number": None,
    #                      }
    #                      )

    # Test __str__

    def test_explanation_has__str__attribute(self):
        self.assertTrue(hasattr(Explanation, '__str__'))

    def test__str__is_callable(self):
        self.assertTrue(callable(getattr(Explanation, '__str__')))

    def test__str__signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(Explanation.__str__)[0]
        self.assertEquals(actual_signature, expected_signature)


class ExplanationStrTestCase(TestCase):
    def test__str__returns_name_if_available(self):
        explanation = ExplanationFactory()
        self.assertEquals(str(explanation), explanation.translated_name)

    def test_it_returns_parent_name_does_not_exist(self):
        explanation = ExplanationFactory(name=None)
        self.assertEquals(str(explanation), super(Explanation, explanation).__str__())


class ExplanationVerseModelStructureTestCase(TestCase):
    """
    id
    translatable
    explanations
    verse_number
    chapter_number
    page_number
    text
    """

    # Test Model

    def test_it_extends_django_model(self):
        self.assertTrue(issubclass(ExplanationVerse, TranslatableModel))

    # Test ID

    def test_if_it_has_id_field(self):
        self.assertTrue(hasattr(ExplanationVerse, 'id'))

    def test_id_extends_BigAutoField(self):
        id_field = ExplanationVerse._meta.get_field('id')
        self.assertIsInstance(id_field, models.BigAutoField)

    def test_if_id_field_extends_primary_key(self):
        id_field = ExplanationVerse._meta.get_field('id')
        self.assertTrue(id_field.primary_key)

    # Test Translatable

    def test_explanation_verse_has_translatable_attribute(self):
        self.assertTrue(hasattr(ExplanationVerse, 'translatable'))

    def test_if_translatable_has_1_keys(self):
        self.assertEqual(len(ExplanationVerse.translatable), 1)

    def test_if_translatable_has_text_key(self):
        self.assertIn('text', ExplanationVerse.translatable.keys())

    def test_if_text_key_has_field_key(self):
        self.assertIn('field', ExplanationVerse.translatable['text'].keys())

    def test_if_field_key_in_text_key_of_translatable_extends_forms_CharField(self):
        self.assertEquals(ExplanationVerse.translatable['text']['field'], forms.CharField)

    # Test Explanation

    def test_if_it_has_explanation_field(self):
        self.assertTrue(hasattr(ExplanationVerse, 'explanation'))

    def test_if_explanation_field_is_foreign_key(self):
        explanation = ExplanationVerse._meta.get_field('explanation')
        self.assertIsInstance(explanation, models.ForeignKey)

    def test_explanation_field_is_related_to_explanation_model(self):
        field = ExplanationVerse._meta.get_field("explanation")
        self.assertEquals(field.__dict__['related_model'], Explanation)

    def test_explanation_field_on_delete_attribute_is_cascade(self):
        field = ExplanationVerse._meta.get_field("explanation")
        self.assertEquals(field.__dict__['remote_field'].__dict__['on_delete'], models.CASCADE)

    def test_explanation_field_null_value_is_equal_to_false(self):
        field = ExplanationVerse._meta.get_field('explanation')
        self.assertFalse(field.null)

    def test_explanation_field_blank_value_is_equal_to_false(self):
        field = ExplanationVerse._meta.get_field('explanation')
        self.assertFalse(field.blank)

    # Test Verse_number

    def test_if_it_contains_verse_number(self):
        self.assertTrue(hasattr(ExplanationVerse, 'verse_number'))

    def test_verse_number_field_is_instance_of_PositiveIntegerField(self):
        field = ExplanationVerse._meta.get_field('verse_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_verse_number_field_is_set_blank_to_true(self):
        field = ExplanationVerse._meta.get_field('verse_number')
        self.assertTrue(field.blank)

    def test_verse_number_field_is_set_null_to_true(self):
        field = ExplanationVerse._meta.get_field('verse_number')
        self.assertTrue(field.null)

    def test_verse_number_field_verbose_name_attribute_is_Verse_Number(self):
        field = ExplanationVerse._meta.get_field('verse_number')
        self.assertEqual(field.verbose_name, _('Verse Number'))

    # Test Chapter_number

    def test_if_it_contains_chapter_number(self):
        self.assertTrue(hasattr(ExplanationVerse, 'chapter_number'))

    def test_chapter_number_field_is_instance_of_PositiveIntegerField(self):
        field = ExplanationVerse._meta.get_field('chapter_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_chapter_number_field_is_set_blank_to_true(self):
        field = ExplanationVerse._meta.get_field('chapter_number')
        self.assertTrue(field.blank)

    def test_chapter_number_field_is_set_null_to_true(self):
        field = ExplanationVerse._meta.get_field('chapter_number')
        self.assertTrue(field.null)

    def test_chapter_number_field_verbose_name_attribute_is_Chapter_Number(self):
        field = ExplanationVerse._meta.get_field('chapter_number')
        self.assertEqual(field.verbose_name, _('Chapter Number'))

    # Test Page_number

    def test_if_it_contains_page_number(self):
        self.assertTrue(hasattr(ExplanationVerse, 'page_number'))

    def test_page_number_field_is_instance_of_PositiveIntegerField(self):
        field = ExplanationVerse._meta.get_field('page_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_page_number_field_is_set_blank_to_true(self):
        field = ExplanationVerse._meta.get_field('page_number')
        self.assertTrue(field.blank)

    def test_page_number_field_is_set_null_to_true(self):
        field = ExplanationVerse._meta.get_field('page_number')
        self.assertTrue(field.null)

    def test_page_number_field_verbose_name_attribute_is_Page_Number(self):
        field = ExplanationVerse._meta.get_field('page_number')
        self.assertEqual(field.verbose_name, _('Page Number'))

    # Test text

    def test_if_it_has_text_field(self):
        self.assertTrue(hasattr(ExplanationVerse, 'text'))

    def test_text_is_instance_of_JSONField(self):
        field = ExplanationVerse._meta.get_field('text')
        self.assertIsInstance(field, models.JSONField)

    def test_text_field_verbose_name_attribute_is_text(self):
        field = ExplanationVerse._meta.get_field('text')
        self.assertEquals(field.verbose_name, _('Tafseer Text'))

    def test_page_number_field_is_set_null_to_true(self):
        field = ExplanationVerse._meta.get_field('text')
        self.assertTrue(field.null)

    def test_page_number_field_is_set_blank_to_true(self):
        field = ExplanationVerse._meta.get_field('text')
        self.assertTrue(field.blank)