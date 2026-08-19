from django.db import models
from django.test import TestCase
from django.utils.translation import gettext_lazy as _

from apps.quran.models import Verse, Chapter, Glyph


class GlyphModelTestCase(TestCase):
    def test_Glyph_model_is_instance_of_models_Models(self):
        self.assertTrue(issubclass(Glyph, models.Model))

    def test_if_field_id_in_verse_model(self):
        self.assertTrue(hasattr(Glyph, 'id'))

    def test_id_attribute_is_instance_of_big_auto_field(self):
        field = Glyph._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    def test_field_id_is_primary_key(self):
        field = Glyph._meta.get_field('id')
        self.assertTrue(field.primary_key)

    def test_if_field_chapter_in_verse_model(self):
        self.assertTrue(hasattr(Glyph, 'chapter'))

    def test_chapter_attribute_is_instance_of_model_foreign_key(self):
        field = Glyph._meta.get_field('chapter')
        self.assertIsInstance(field, models.ForeignKey)

    def test_chapter_attribute_model_value_has_many_to_one_relation(self):
        field = Glyph._meta.get_field('chapter')
        self.assertTrue(field.many_to_one)

    def test_chapter_field_is_related_to_chapter_model(self):
        field = Glyph._meta.get_field('chapter')
        self.assertEqual(field.remote_field.model, Chapter)

    def test_chapter_attribute_related_name_value(self):
        field = Glyph._meta.get_field('chapter')
        self.assertEqual(field.remote_field.related_name, "chapter_glyphs")

    def test_chapter_attribute_on_delete_value(self):
        field = Glyph._meta.get_field('chapter')
        self.assertEqual(field.remote_field.on_delete, models.SET_NULL)

    def test_chapter_field_null_is_true(self):
        field = Glyph._meta.get_field('chapter')
        self.assertTrue(field.null)

    def test_chapter_field_blank_is_true(self):
        field = Glyph._meta.get_field('chapter')
        self.assertTrue(field.blank)

    def test_if_field_page_in_Verse_model(self):
        self.assertTrue(hasattr(Glyph, 'page'))

    def test_page_attribute_is_instance_of_model_foreign_key(self):
        field = Glyph._meta.get_field('page')
        self.assertIsInstance(field, models.ForeignKey)

    def test_page_attribute_model_value_has_many_to_one_relation(self):
        field = Glyph._meta.get_field('page')
        self.assertTrue(field.many_to_one)

    def test_page_attribute_related_name_value(self):
        field = Glyph._meta.get_field('page')
        self.assertEqual(field.remote_field.related_name, "page_glyphs")

    def test_page_attribute_on_delete_value(self):
        field = Glyph._meta.get_field('page')
        self.assertEqual(field.remote_field.on_delete, models.SET_NULL)

    def test_page_field_null_is_true(self):
        field = Glyph._meta.get_field('page')
        self.assertTrue(field.null)

    def test_page_field_blank_is_true(self):
        field = Glyph._meta.get_field('page')
        self.assertTrue(field.blank)

    def test_if_field_verse_in_glyph_model(self):
        self.assertTrue(hasattr(Glyph, 'verse'))

    def test_verse_attribute_is_instance_of_model_foreign_key(self):
        field = Glyph._meta.get_field('verse')
        self.assertIsInstance(field, models.ForeignKey)

    def test_verse_attribute_model_value(self):
        field = Glyph._meta.get_field('verse')
        self.assertTrue(field.many_to_one)

    def test_verse_field_is_related_to_chapter_model(self):
        field = Glyph._meta.get_field('verse')
        self.assertEqual(field.remote_field.model, Verse)

    def test_verse_attribute_related_name_value(self):
        field = Glyph._meta.get_field('verse')
        self.assertEqual(field.remote_field.related_name, "glyph_verses")

    def test_verse_attribute_on_delete_value(self):
        field = Glyph._meta.get_field('verse')
        self.assertEqual(field.remote_field.on_delete, models.SET_NULL)

    def test_verse_field_null_is_true(self):
        field = Glyph._meta.get_field('verse')
        self.assertTrue(field.null)

    def test_verse_field_blank_is_true(self):
        field = Glyph._meta.get_field('verse')
        self.assertTrue(field.blank)

    def test_if_field_line_number_in_Glyph_model(self):
        self.assertTrue(hasattr(Glyph, 'line_number'))

    def test_line_number_attribute_is_instance_of_positive_integer_field(self):
        field = Glyph._meta.get_field('line_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_line_number_verbose_field_value_is_Line_Number(self):
        field = Glyph._meta.get_field('line_number')
        self.assertEqual(field.verbose_name, _('Line_Number'))

    def test_if_field_position_in_Glyph_model(self):
        self.assertTrue(hasattr(Glyph, 'position'))

    def test_position_attribute_is_instance_of_positive_integer_field(self):
        field = Glyph._meta.get_field('position')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_position_verbose_field_value_is_position(self):
        field = Glyph._meta.get_field('position')
        self.assertEqual(field.verbose_name, _('Position'))

    def test_position_field_null_is_true(self):
        field = Glyph._meta.get_field('position')
        self.assertTrue(field.null)

    def test_position_field_blank_is_true(self):
        field = Glyph._meta.get_field('position')
        self.assertTrue(field.blank)

    def test_if_field_min_x_in_Glyph_model(self):
        self.assertTrue(hasattr(Glyph, 'min_x'))

    def test_min_x_attribute_is_instance_of_positive_integer_field(self):
        field = Glyph._meta.get_field('min_x')
        self.assertIsInstance(field, models.IntegerField)

    def test_min_x_verbose_field_value_is_min_x(self):
        field = Glyph._meta.get_field('min_x')
        self.assertEqual(field.verbose_name, _('Min_x'))

    def test_if_field_max_x_in_Glyph_model(self):
        self.assertTrue(hasattr(Glyph, 'max_x'))

    def test_max_x_attribute_is_instance_of_positive_integer_field(self):
        field = Glyph._meta.get_field('max_x')
        self.assertIsInstance(field, models.IntegerField)

    def test_max_x_verbose_field_value_is_max_x(self):
        field = Glyph._meta.get_field('max_x')
        self.assertEqual(field.verbose_name, _('Max_x'))

    def test_if_field_min_y_in_Glyph_model(self):
        self.assertTrue(hasattr(Glyph, 'min_y'))

    def test_min_y_attribute_is_instance_of_positive_integer_field(self):
        field = Glyph._meta.get_field('min_y')
        self.assertIsInstance(field, models.IntegerField)

    def test_min_y_verbose_field_value_is_min_y(self):
        field = Glyph._meta.get_field('min_y')
        self.assertEqual(field.verbose_name, _('Min_y'))

    def test_if_field_max_y_in_Glyph_model(self):
        self.assertTrue(hasattr(Glyph, 'max_y'))

    def test_max_y_attribute_is_instance_of_positive_integer_field(self):
        field = Glyph._meta.get_field('max_y')
        self.assertIsInstance(field, models.IntegerField)

    def test_max_y_verbose_field_value_is_max_y(self):
        field = Glyph._meta.get_field('max_y')
        self.assertEqual(field.verbose_name, _('Max_y'))
