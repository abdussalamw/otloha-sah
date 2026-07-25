from django.db import models
from django.test import TestCase
from django.utils.translation import gettext_lazy as _

from apps.chapters.factories import ChapterFactory
from apps.chapters.models import Chapter
from apps.narrations.factories import NarrationFactory, VerseFactory
from apps.narrations.models import Verse
from apps.parts.models import Part


class VerseModelTestCase(TestCase):
    def test_verse_model_is_instance_of_models_Models(self):
        self.assertTrue(issubclass(Verse, models.Model))

    def test_if_field_id_in_verse_model(self):
        self.assertTrue(hasattr(Verse, 'id'))

    def test_id_attribute_is_instance_of_big_auto_field(self):
        field = Verse._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    def test_field_id_is_primary_key(self):
        field = Verse._meta.get_field('id')
        self.assertTrue(field.primary_key)

    def test_if_field_image_in_verse_model(self):
        self.assertTrue(hasattr(Verse, 'image'))

    def test_image_attribute_is_instance_of_image_field(self):
        field = Verse._meta.get_field('image')
        self.assertIsInstance(field, models.ImageField)

    def test_image_field_null_is_true(self):
        field = Verse._meta.get_field('image')
        self.assertTrue(field.null)

    def test_image_field_blank_is_true(self):
        field = Verse._meta.get_field('image')
        self.assertTrue(field.blank)

    def test_image_field_will_upload_images_to_get_upload_to_function(self):
        field = Verse._meta.get_field('image')
        self.assertEquals(field.upload_to, Verse.get_upload_to)

    def test_if_field_line_start_in_verse_model(self):
        self.assertTrue(hasattr(Verse, 'line_start'))

    def test_line_start_attribute_is_instance_of_positive_field(self):
        field = Verse._meta.get_field('line_start')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_line_start_verbose_field_value_is_Line_Start(self):
        field = Verse._meta.get_field('line_start')
        self.assertEquals(field.verbose_name, _('Line Start'))

    def test_if_field_line_end_in_Verse_model(self):
        self.assertTrue(hasattr(Verse, 'line_end'))

    def test_line_end_attribute_is_instance_of_positive_integer_field(self):
        field = Verse._meta.get_field('line_end')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_line_end_verbose_field_value_is_Line_End(self):
        field = Verse._meta.get_field('line_end')
        self.assertEquals(field.verbose_name, _('Line End'))

    def test_if_field_verse_number_in_Verse_model(self):
        self.assertTrue(hasattr(Verse, 'verse_number'))

    def test_verse_number_attribute_is_instance_of_positive_integer_field(self):
        field = Verse._meta.get_field('verse_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_verse_number_attribute_has_db_index_is_true(self):
        field = Verse._meta.get_field('verse_number')
        self.assertTrue(field.db_index)

    def test_verse_number_verbose_field_value_is_verse_number(self):
        field = Verse._meta.get_field('verse_number')
        self.assertEquals(field.verbose_name, _('Verse Number'))

    def test_if_field_text_in_verse_model(self):
        self.assertTrue(hasattr(Verse, 'text'))

    def test_text_attribute_is_instance_of_text_field(self):
        field = Verse._meta.get_field('text')
        self.assertIsInstance(field, models.TextField)

    def test_text_verbose_field_value_is_text(self):
        field = Verse._meta.get_field('text')
        self.assertEquals(field.verbose_name, _('Text'))

    def test_text_field_null_is_true(self):
        field = Verse._meta.get_field('text')
        self.assertTrue(field.null)

    def test_text_field_blank_is_true(self):
        field = Verse._meta.get_field('text')
        self.assertTrue(field.blank)

    def test_if_field_chapter_in_verse_model(self):
        self.assertTrue(hasattr(Verse, 'chapter'))

    def test_chapter_attribute_is_instance_of_model_foreign_key(self):
        field = Verse._meta.get_field('chapter')
        self.assertIsInstance(field, models.ForeignKey)

    def test_chapter_attribute_model_value_has_many_to_one_relation(self):
        field = Verse._meta.get_field('chapter')
        self.assertTrue(field.many_to_one)

    def test_chapter_field_is_related_to_chapter_model(self):
        field = Verse._meta.get_field('chapter')
        self.assertEquals(field.remote_field.model, Chapter)

    def test_chapter_attribute_related_name_value(self):
        field = Verse._meta.get_field('chapter')
        self.assertEquals(field.remote_field.related_name, "chapter_verses")

    def test_chapter_attribute_on_delete_value(self):
        field = Verse._meta.get_field('chapter')
        self.assertEquals(field.remote_field.on_delete, models.SET_NULL)

    def test_chapter_field_null_is_true(self):
        field = Verse._meta.get_field('chapter')
        self.assertTrue(field.null)

    def test_chapter_field_blank_is_true(self):
        field = Verse._meta.get_field('chapter')
        self.assertTrue(field.blank)

    def test_if_field_part_in_verse_model(self):
        self.assertTrue(hasattr(Verse, 'part'))

    def test_part_attribute_is_instance_of_model_foreign_key(self):
        field = Verse._meta.get_field('part')
        self.assertIsInstance(field, models.ForeignKey)

    def test_part_attribute_model_value_has_many_to_one_relation(self):
        field = Verse._meta.get_field('part')
        self.assertTrue(field.many_to_one)

    def test_part_field_is_related_to_part_model(self):
        field = Verse._meta.get_field('part')
        self.assertEquals(field.remote_field.model, Part)

    def test_part_attribute_related_name_value(self):
        field = Verse._meta.get_field('part')
        self.assertEquals(field.remote_field.related_name, "part_verses")

    def test_part_attribute_on_delete_value(self):
        field = Verse._meta.get_field('part')
        self.assertEquals(field.remote_field.on_delete, models.SET_NULL)

    def test_part_field_null_is_true(self):
        field = Verse._meta.get_field('part')
        self.assertTrue(field.null)

    def test_part_field_blank_is_true(self):
        field = Verse._meta.get_field('part')
        self.assertTrue(field.blank)

    def test_if_field_pages_in_verse_model(self):
        self.assertTrue(hasattr(Verse, 'pages'))

    def test_pages_attribute_is_instance_of_model_foreign_key(self):
        field = Verse._meta.get_field('pages')
        self.assertIsInstance(field, models.ManyToManyField)

    def test_pages_attribute_model_value(self):
        field = Verse._meta.get_field('pages')
        self.assertTrue(field.many_to_many)

    def test__str__is_callable(self):
        self.assertTrue(callable(getattr(Verse, '__str__')))

    def test_meta_verbose_name_is_verse(self):
        self.assertEquals(Verse._meta.verbose_name, _('Verse'))

    def test_meta_verbose_name_plural_is_verses(self):
        self.assertEquals(Verse._meta.verbose_name_plural, _('Verses'))

    def test___str___value_is_correct(self):
        verse = VerseFactory(
            line_start=1,
            chapter=ChapterFactory(),
            text='test',
            line_end=2,
            verse_number=3,
            narration=NarrationFactory())
        self.assertEqual(str(verse), _("Verse Number {verse_number}").format(verse_number=verse.verse_number))

        def test_verse_model_has_get_upload_to_attribute(self):
            self.assertTrue(hasattr(Verse, 'get_upload_to'))

        def test_get_upload_to_is_callable(self):
            self.assertTrue(callable(getattr(Verse, 'get_upload_to')))

        def test_get_upload_to_function_verse_model_will_create_file_with_data(self):
            verse = VerseFactory(
                line_start=1,
                chapter=ChapterFactory(),
                text='test',
                line_end=2,
                verse_number=3,
                narration=NarrationFactory())

            filename = "test"
            model_upload_function = Verse.get_upload_to(verse, filename)
            self.assertEquals(model_upload_function, 'narrations/verses/{}/{}'.format(verse.uuid, filename))
