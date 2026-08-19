import inspect

from django import forms
from django.db import models
from django.test import TestCase
from django.utils.translation import gettext_lazy as _
from translation.models import TranslatableModel

from apps.chapters.factories import ChapterFactory
from apps.chapters.models import Chapter
from apps.narrations.factories import NarrationFactory
from apps.narrations.models import Narration
from apps.recitations.factories import RecitationFactory, ReciterFactory, RecitationVerseFactory
from apps.recitations.models import Reciter, Recitation, RecitationVerse


class ReciterModelStructureTestCase(TestCase):
    """
    id
    translatable
    name
    created_at
    updated_at
    __str__
    """

    # Test Model
    def test_it_extends_django_model(self):
        self.assertTrue(issubclass(Reciter, TranslatableModel))

    # Test Meta

    def test_Reciter_model_has_class_meta(self):
        self.assertIn('_meta', Reciter.__dict__)

    def test_meta_verbose_name_is_reciter(self):
        self.assertEqual(Reciter._meta.verbose_name, _('Reciter'))

    def test_meta_verbose_name_plural_is_reciters(self):
        self.assertEqual(Reciter._meta.verbose_name_plural, _('Reciters'))

    # Test ID

    def test_it_contains_id_attribute(self):
        self.assertTrue(hasattr(Reciter, 'id'))

    def test_id_field_is_instance_of_BigAutoField(self):
        field = Reciter._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    def test_id_field_is_primary_attribute_set_to_true(self):
        field = Reciter._meta.get_field('id')
        self.assertTrue(field.primary_key)

    # Test translatable

    def test_it_contains_translatable_attribute(self):
        self.assertTrue(hasattr(Reciter(), 'translatable'))

    def test_translatable_attribute_has_name_key(self):
        self.assertIn('name', getattr(Reciter, 'translatable'))

    def test_translatable_name_has_field_key(self):
        self.assertIn('field', Reciter.translatable['name'])

    def test_translatable_name_field_value_is_forms_char_field(self):
        self.assertEqual(Reciter.translatable['name']['field'], forms.CharField)

    # Test name

    def test_if_it_has_name_field(self):
        self.assertTrue(hasattr(Reciter, 'name'))

    def test_name_attribute_is_instance_of_json_field(self):
        name = Reciter._meta.get_field('name')
        self.assertIsInstance(name, models.JSONField)

    def test_name_field_null_value_is_equal_to_false(self):
        field = Reciter._meta.get_field('name')
        self.assertFalse(field.null)

    def test_name_field_blank_value_is_equal_to_false(self):
        field = Reciter._meta.get_field('name')
        self.assertFalse(field.blank)

    def test_name_verbose_name_value_is_Name(self):
        name = Reciter._meta.get_field('name')
        self.assertEqual(name.verbose_name, _('Name'))

    # Test created_at

    def test_if_it_has_created_at_field(self):
        self.assertTrue(hasattr(Reciter, 'created_at'))

    def test_created_at_attribute_is_instance_of_DateField(self):
        created_at = Reciter._meta.get_field('created_at')
        self.assertIsInstance(created_at, models.DateField)

    def test_created_at_field_null_value_is_equal_to_false(self):
        field = Reciter._meta.get_field('created_at')
        self.assertFalse(field.null)

    def test_created_at_field_blank_value_is_equal_to_true(self):
        field = Reciter._meta.get_field('created_at')
        self.assertTrue(field.blank)

    def test_created_at_verbose_created_at_value_is_Created_At(self):
        created_at = Reciter._meta.get_field('created_at')
        self.assertEqual(created_at.verbose_name, _('Created At'))

    # Test updated_at

    def test_if_it_has_updated_at_field(self):
        self.assertTrue(hasattr(Reciter, 'updated_at'))

    def test_updated_at_attribute_is_instance_of_DateTimeField(self):
        updated_at = Reciter._meta.get_field('updated_at')
        self.assertIsInstance(updated_at, models.DateTimeField)

    def test_updated_at_field_null_value_is_equal_to_false(self):
        field = Reciter._meta.get_field('updated_at')
        self.assertFalse(field.null)

    def test_updated_at_field_blank_value_is_equal_to_true(self):
        field = Reciter._meta.get_field('updated_at')
        self.assertTrue(field.blank)

    def test_updated_at_verbose_updated_at_value_is_Updated_At(self):
        updated_at = Reciter._meta.get_field('updated_at')
        self.assertEqual(updated_at.verbose_name, _('Updated At'))

    # Test __str__

    def test_reciter_has__str__attribute(self):
        self.assertTrue(hasattr(Reciter, '__str__'))

    def test__str__is_callable(self):
        self.assertTrue(callable(getattr(Reciter, '__str__')))

    def test__str__signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(Reciter.__str__)[0]
        self.assertEqual(actual_signature, expected_signature)


class ReciterStrTestCase(TestCase):
    def test__str__returns_name_if_available(self):
        reciter = ReciterFactory()
        self.assertEqual(str(reciter), reciter.translated_name)


class RecitationModelStructureTestCase(TestCase):
    """
    id
    translatable
    name
    narrations
    reciter
    __str__
    process_files
    """

    # Test Model
    def test_it_extends_django_model(self):
        self.assertTrue(issubclass(Recitation, TranslatableModel))

    # Test Meta

    def test_Recitation_model_has_class_meta(self):
        self.assertIn('_meta', Recitation.__dict__)

    def test_meta_verbose_name_is_recitation(self):
        self.assertEqual(Recitation._meta.verbose_name, _('Recitation'))

    def test_meta_verbose_name_plural_is_recitations(self):
        self.assertEqual(Recitation._meta.verbose_name_plural, _('Recitations'))

    # Test ID

    def test_it_contains_id_attribute(self):
        self.assertTrue(hasattr(Recitation, 'id'))

    def test_id_field_is_instance_of_BigAutoField(self):
        field = Recitation._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    def test_id_field_is_primary_attribute_set_to_true(self):
        field = Recitation._meta.get_field('id')
        self.assertTrue(field.primary_key)

    # Test translatable

    def test_it_contains_translatable_attribute(self):
        self.assertTrue(hasattr(Recitation(), 'translatable'))

    def test_translatable_attribute_has_name_key(self):
        self.assertIn('name', getattr(Recitation, 'translatable'))

    def test_translatable_name_has_field_key(self):
        self.assertIn('field', Recitation.translatable['name'])

    def test_translatable_name_field_value_is_forms_char_field(self):
        self.assertEqual(Recitation.translatable['name']['field'], forms.CharField)

    # Test name

    def test_if_it_has_name_field(self):
        self.assertTrue(hasattr(Recitation, 'name'))

    def test_name_attribute_is_instance_of_json_field(self):
        name = Recitation._meta.get_field('name')
        self.assertIsInstance(name, models.JSONField)

    def test_name_field_null_value_is_equal_to_true(self):
        field = Recitation._meta.get_field('name')
        self.assertTrue(field.null)

    def test_name_field_blank_value_is_equal_to_true(self):
        field = Recitation._meta.get_field('name')
        self.assertTrue(field.blank)

    def test_name_verbose_name_value_is_Name(self):
        name = Recitation._meta.get_field('name')
        self.assertEqual(name.verbose_name, _('Name'))

    # Test Narration

    def test_it_contains_narration_attribute(self):
        self.assertTrue(hasattr(Recitation(), 'narration'))

    def test_narration_field_is_instance_of_ForeignKey(self):
        field = Recitation._meta.get_field('narration')
        self.assertIsInstance(field, models.ForeignKey)

    def test_narration_field_is_set_blank_to_true(self):
        field = Recitation._meta.get_field('narration')
        self.assertTrue(field.blank)

    def test_narration_field_is_set_null_to_true(self):
        field = Recitation._meta.get_field('narration')
        self.assertTrue(field.null)

    def test_narration_field_is_related_to_narration_model(self):
        field = Recitation._meta.get_field('narration')
        self.assertEqual(field.remote_field.model, Narration)

    def test_narration_field_on_delete_attribute(self):
        field = Recitation._meta.get_field('narration')
        self.assertEqual(field.remote_field.on_delete, models.SET_NULL)

    # Test Reciter

    def test_it_contains_reciter_attribute(self):
        self.assertTrue(hasattr(Recitation, 'reciter'))

    def test_reciter_field_is_instance_of_ForeignKey(self):
        field = Recitation._meta.get_field('reciter')
        self.assertIsInstance(field, models.ForeignKey)

    def test_reciter_field_is_related_to_reciter_model(self):
        field = Recitation._meta.get_field('reciter')
        self.assertEqual(field.remote_field.model, Reciter)

    def test_reciter_field_on_delete_attribute(self):
        field = Recitation._meta.get_field('reciter')
        self.assertEqual(field.remote_field.on_delete, models.CASCADE)

    # Test __str__

    def test_model_has___str___method(self):
        self.assertTrue(hasattr(Recitation(), '__str__'))

    def test___str___is_callable(self):
        self.assertTrue(callable(getattr(Recitation, '__str__')))

    def test__str__signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(Recitation.__str__)[0]
        self.assertEqual(actual_signature, expected_signature)


class RecitationStrTestCase(TestCase):
    def test___str___return_the_object_string_representation(self):
        reciter = ReciterFactory()
        narration = NarrationFactory()
        recitation = RecitationFactory(narration=narration, reciter=reciter)
        self.assertEqual(str(recitation),
                          "{} {} {} {}".format(_("recitation"), narration.translated_name, _('by shaikh'),
                                               reciter.translated_name))

    def test_it_returns_parent_name_does_not_exist(self):
        recitation = RecitationFactory(narration=NarrationFactory(), reciter=ReciterFactory(), name=None)
        self.assertEqual(str(recitation), super(Recitation, recitation).__str__())


class RecitationVerseModelStructureTestCase(TestCase):
    """
    id
    recitation
    record
    verse_number
    chapter
    get_upload_to
    """

    # Test Model

    def test_model_inherited_modelsModel(self):
        self.assertTrue(isinstance(RecitationVerse(), models.Model))

    # Test ID

    def test_it_contains_id_attribute(self):
        self.assertTrue(hasattr(RecitationVerse, 'id'))

    def test_id_field_is_instance_of_BigAutoField(self):
        field = RecitationVerse._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    def test_id_field_is_primary_attribute_set_to_true(self):
        field = RecitationVerse._meta.get_field('id')
        self.assertTrue(field.primary_key)

    # Test Recitation

    def test_it_contains_recitation_attribute(self):
        self.assertTrue(hasattr(RecitationVerse, 'recitation'))

    def test_recitation_field_is_instance_of_ForeignKey(self):
        field = RecitationVerse._meta.get_field('recitation')
        self.assertIsInstance(field, models.ForeignKey)

    def test_recitation_field_is_related_to_recitation_model(self):
        field = RecitationVerse._meta.get_field('recitation')
        self.assertEqual(field.remote_field.model, Recitation)

    def test_recitation_field_on_delete_attribute(self):
        field = RecitationVerse._meta.get_field('recitation')
        self.assertEqual(field.remote_field.on_delete, models.CASCADE)

    # Test Record

    def test_it_contains_record_attribute(self):
        self.assertTrue(hasattr(RecitationVerse, 'record'))

    def test_record_field_is_instance_of_FileField(self):
        field = RecitationVerse._meta.get_field('record')
        self.assertIsInstance(field, models.FileField)

    def test_record_field_upload_to_function_is_get_upload_to(self):
        field = RecitationVerse._meta.get_field('record')
        self.assertEqual(field.upload_to, RecitationVerse.get_upload_to)

    def test_record_field_is_set_blank_to_true(self):
        field = RecitationVerse._meta.get_field('record')
        self.assertTrue(field.blank)

    def test_record_field_is_set_null_to_true(self):
        field = RecitationVerse._meta.get_field('record')
        self.assertTrue(field.blank)

    # Test Verse_number

    def test_it_contains_verse_number_attribute(self):
        self.assertTrue(hasattr(RecitationVerse, 'verse_number'))

    def test_verse_number_field_is_instance_of_PositiveIntegerField(self):
        field = RecitationVerse._meta.get_field('verse_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_verse_number_field_is_set_blank_to_true(self):
        field = RecitationVerse._meta.get_field('verse_number')
        self.assertTrue(field.blank)

    def test_verse_number_field_is_set_null_to_true(self):
        field = RecitationVerse._meta.get_field('verse_number')
        self.assertTrue(field.null)

    # Test Chapter

    def test_it_contains_chapter_attribute(self):
        self.assertTrue(hasattr(RecitationVerse, 'chapter'))

    def test_chapter_field_is_instance_of_ForeignKey(self):
        field = RecitationVerse._meta.get_field('chapter')
        self.assertIsInstance(field, models.ForeignKey)

    def test_chapter_field_is_related_to_chapter_model(self):
        field = RecitationVerse._meta.get_field('chapter')
        self.assertEqual(field.remote_field.model, Chapter)

    def test_chapter_field_on_delete_attribute(self):
        field = RecitationVerse._meta.get_field('chapter')
        self.assertEqual(field.remote_field.on_delete, models.CASCADE)

    # Test get_upload_to

    def test_model_has_get_upload_to_method(self):
        self.assertTrue(hasattr(RecitationVerse(), 'get_upload_to'))

    def test_get_upload_to_is_callable(self):
        self.assertTrue(callable(getattr(RecitationVerse, 'get_upload_to')))

    def test_get_upload_to_signature(self):
        expected_signature = ['self', 'filename']
        actual_signature = inspect.getfullargspec(RecitationVerse.get_upload_to)[0]
        self.assertEqual(actual_signature, expected_signature)


class RecitationVerseModelTestCase(TestCase):
    def test_get_upload_to_return_correct_path_where_the_file_uploaded(self):
        reciter = ReciterFactory()
        recitation = RecitationFactory(reciter=reciter)
        chapter = ChapterFactory()
        filename = 'file'
        recitation_verse = RecitationVerseFactory(chapter=chapter, recitation=recitation)
        self.assertEqual(recitation_verse.get_upload_to(filename=filename),
                          'recitations/{}/recitation_verses/{}'.format(recitation_verse.recitation.pk, filename))
