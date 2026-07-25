from django import forms
from django.db import models
from django.test import TestCase
from django.utils.translation import gettext as _

from app import settings
from apps.chapters.models import Chapter
from apps.narrations.models import Narration
from apps.translations.factories import TranslationFactory
from apps.translations.models import Translation, TranslationVerse, TranslatableModel

"""
    Translation Model
        ## fields
            * id primary
            * name string
            * language string [en, ar, fr]
            * author
        ## __str__
            ** name, language ** 
    TranslationVerse Models
        ## fields
            * id 
            * text 
            * translation foreign key 
            * narrations foreign key null= true blank=true
            * chapter foreign key 
            * verse_number not a foreign key 
        ## __str__
            ** first five words of text ** 
"""


class TranslationModelStructureTestCase(TestCase):
    """
    id
    name
    language
    author
    """

    def test_it_extends_django_model(self):
        self.assertTrue(issubclass(Translation, TranslatableModel))

    def test_translation_model_has_class_meta(self):
        self.assertIn('_meta', Translation.__dict__)

    def test_translation_model_verbose_meta_value_is_translation(self):
        self.assertEquals(Translation._meta.verbose_name, _('Translation'))

    def test_translation_model_verbose_name_plural_meta_value_is_translations(self):
        self.assertEquals(Translation._meta.verbose_name_plural, _('Translations'))

    # Test Id

    def test_translation_contains_id_attribute(self):
        self.assertTrue(hasattr(Translation, 'id'))

    def test_id_field_is_instance_of_BigAutoField(self):
        field = Translation._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    def test_id_field_is_primary_attribute_set_to_true(self):
        field = Translation._meta.get_field('id')
        self.assertTrue(field.primary_key)

    # Test Name

    def test_if_translation_has_translatable_variable(self):
        self.assertTrue(hasattr(Translation, 'translatable'))

    def test_if_translatable_has_2_keys(self):
        self.assertEqual(len(Translation.translatable), 2)

    def test_if_translatable_has_name_key(self):
        self.assertIn('name', Translation.translatable.keys())

    def test_if_name_key_has_field_key(self):
        self.assertIn('field', Translation.translatable['name'].keys())

    def test_if_field_key_in_name_key_of_translatable_extends_forms_CharField(self):
        self.assertEquals(Translation.translatable['name']['field'], forms.CharField)

    def test_it_has_name_attribute(self):
        self.assertTrue(hasattr(Translation, 'name'))

    def test_name_attribute_is_instance_of_json(self):
        field = Translation._meta.get_field("name")
        self.assertIsInstance(field, models.JSONField)

    def test_name_field_has_varbose_name(self):
        field = Translation._meta.get_field("name")
        self.assertIn('verbose_name', field.__dict__)

    def test_name_attribute_its_verbose_name_value_is_author(self):
        field = Translation._meta.get_field('name')
        self.assertEqual(field.verbose_name, _('Name'))

    # Test Language

    # Test SETTINGS.LANGUAGES

    def test_if_english_variable_exists(self):
        self.assertTrue(hasattr(settings, 'LANGUAGE_ENGLISH'))

    def test_if_english_variable_value_is_en(self):
        self.assertEqual(settings.LANGUAGE_ENGLISH, 'en')

    def test_if_arabic_variable_exists(self):
        self.assertTrue(hasattr(settings, 'LANGUAGE_ARABIC'))

    def test_if_arabic_variable_value_is_en(self):
        self.assertEqual(settings.LANGUAGE_ARABIC, 'ar')

    def test_if_languages_variable_exists(self):
        self.assertTrue(hasattr(settings, 'LANGUAGES'))

    def test_if_len_of_languages_is_2(self):
        self.assertEqual(len(settings.LANGUAGES), 2)

    def test_if_languages_returns_tuple_of_tuples(self):
        self.assertEqual(settings.LANGUAGES, (('en', _("English")), ('ar', _("Arabic"))))

    def test_if_languages_has_english_value(self):
        self.assertEqual(settings.LANGUAGES[0][0], 'en')

    def test_if_languages_has_arabic_value(self):
        self.assertEqual(settings.LANGUAGES[1][0], 'ar')

    def test_if_language_attribute_exists(self):
        self.assertTrue(hasattr(Translation, 'language'))

    def test_language_attribute_is_instance_of_char_field(self):
        field = Translation._meta.get_field("language")
        self.assertIsInstance(field, models.CharField)

    def test_language_attribute_has_max_length_value(self):
        field = Translation._meta.get_field("language")
        self.assertIn('max_length', field.__dict__)

    def test_language_attribute_max_length_value_is_50(self):
        field = Translation._meta.get_field("language")
        self.assertEquals(field.max_length, 50)

    def test_language_attribute_has_languages_choices(self):
        field = Translation._meta.get_field("language")
        self.assertIsNotNone(field.choices)

    def test_language_attribute_value_is_languages_choices_variable(self):
        field = Translation._meta.get_field("language")
        self.assertEquals(settings.LANGUAGES, field.choices)

    # Test Author

    def test_if_translatable_has_author_key(self):
        self.assertIn('author', Translation.translatable.keys())

    def test_if_field_key_in_author_key_of_translatable_extends_forms_CharField(self):
        self.assertEquals(Translation.translatable['author']['field'], forms.CharField)

    def test_it_has_author_attribute(self):
        self.assertTrue(hasattr(Translation, 'author'))

    def test_author_attribute_is_instance_of_json(self):
        field = Translation._meta.get_field("author")
        self.assertIsInstance(field, models.JSONField)

    def test_author_field_has_verbose_name(self):
        field = Translation._meta.get_field("author")
        self.assertIn('verbose_name', field.__dict__)

    def test_author_attribute_its_verbose_name_value_is_author(self):
        field = Translation._meta.get_field('author')
        self.assertEqual(field.verbose_name, _('Author'))

    # Test Narration

    def test_model_has_narration_attribute(self):
        self.assertTrue(hasattr(Translation, 'narration'))

    def test_narration_field_is_instance_of_foreign_Key(self):
        field = Translation._meta.get_field('narration')
        self.assertIsInstance(field, models.ForeignKey)

    def test_narration_field_is_related_to_narration_model(self):
        field = Translation._meta.get_field("narration")
        self.assertEquals(field.__dict__['related_model'], Narration)

    def test_narration_field_has_related_name_attribute(self):
        field = Translation._meta.get_field("narration")
        self.assertIn('related_name', field.__dict__['remote_field'].__dict__)

    def test_narration_field_has_on_delete_attribute(self):
        field = Translation._meta.get_field("narration")
        self.assertIn('on_delete', field.__dict__['remote_field'].__dict__)

    def test_narration_field_on_delete_attribute_is_set_null(self):
        field = Translation._meta.get_field("narration")
        self.assertEquals(field.__dict__['remote_field'].__dict__['on_delete'], models.SET_NULL)

    def test_narration_field_has_null_value(self):
        field = Translation._meta.get_field("narration")
        self.assertIn('null', field.__dict__)

    def test_narration_field_null_value_is_true(self):
        field = Translation._meta.get_field("narration")
        self.assertTrue(field.null)

    def test_narration_field_has_blank_value(self):
        field = Translation._meta.get_field("narration")
        self.assertIn('blank', field.__dict__)

    def test_narration_field_blank_value_is_true(self):
        field = Translation._meta.get_field("narration")
        self.assertTrue(field.blank)


class TranslationModelTestCase(TestCase):

    def test_translation_has__str__attribute(self):
        self.assertTrue(hasattr(Translation, '__str__'))

    def test__str__is_callable(self):
        self.assertTrue(callable(getattr(Translation, '__str__')))

    def test___str___returns_name_and_language_if_available(self):
        translation = TranslationFactory(name='test', language='en')
        self.assertEqual(str(translation),
                         _("{}, translated to {}").format(translation.translated_name, translation.language))

    def test___str___returns_parent___str___if_name_is_not_available(self):
        translation = TranslationFactory(name=None)
        self.assertEqual(str(translation), super(Translation, translation).__str__())


class TranslationVerseModelStructureTestCase(TestCase):
    """
    id
    text
    translation
    narrations
    chapter
    verse_number
    """

    def test_it_extends_django_model(self):
        self.assertTrue(issubclass(TranslationVerse, models.Model))

    # Test Id

    def test_translation_verse_contains_id_attribute(self):
        self.assertTrue(hasattr(TranslationVerse, 'id'))

    def test_id_field_is_instance_of_BigAutoField(self):
        field = TranslationVerse._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    def test_id_field_is_primary_attribute_set_to_true(self):
        field = TranslationVerse._meta.get_field('id')
        self.assertTrue(field.primary_key)

    # Test Text

    def test_it_has_text_attribute(self):
        self.assertTrue(hasattr(TranslationVerse, 'text'))

    def test_text_attribute_is_instance_of_text_field(self):
        field = TranslationVerse._meta.get_field("text")
        self.assertIsInstance(field, models.TextField)

    def test_text_field_has_null_value(self):
        field = TranslationVerse._meta.get_field("text")
        self.assertIn('null', field.__dict__)

    def test_text_field_null_value_is_false(self):
        field = TranslationVerse._meta.get_field("text")
        self.assertFalse(field.null)

    def test_text_field_has_blank_value(self):
        field = TranslationVerse._meta.get_field("text")
        self.assertIn('blank', field.__dict__)

    def test_text_field_blank_value_is_false(self):
        field = TranslationVerse._meta.get_field("text")
        self.assertFalse(field.blank)

    # Test Translation

    def test_model_has_translation_attribute(self):
        self.assertTrue(hasattr(TranslationVerse, 'translation'))

    def test_translation_field_is_instance_of_foreign_Key(self):
        field = TranslationVerse._meta.get_field('translation')
        self.assertIsInstance(field, models.ForeignKey)

    def test_translation_field_is_related_to_translation_model(self):
        field = TranslationVerse._meta.get_field("translation")
        self.assertEquals(field.__dict__['related_model'], Translation)

    def test_translation_field_has_on_delete_attribute(self):
        field = TranslationVerse._meta.get_field("translation")
        self.assertIn('on_delete', field.__dict__['remote_field'].__dict__)

    def test_translation_field_on_delete_attribute_is_cascade(self):
        field = TranslationVerse._meta.get_field("translation")
        self.assertEquals(field.__dict__['remote_field'].__dict__['on_delete'], models.CASCADE)

    # Test Chapter

    def test_model_has_chapter_attribute(self):
        self.assertTrue(hasattr(TranslationVerse, 'chapter'))

    def test_chapter_field_is_instance_of_foreign_Key(self):
        field = TranslationVerse._meta.get_field('chapter')
        self.assertIsInstance(field, models.ForeignKey)

    def test_chapter_field_is_related_to_chapter_model(self):
        field = TranslationVerse._meta.get_field("chapter")
        self.assertEquals(field.__dict__['related_model'], Chapter)

    def test_chapter_field_has_related_name_attribute(self):
        field = TranslationVerse._meta.get_field("chapter")
        self.assertIn('related_name', field.__dict__['remote_field'].__dict__)

    def test_chapter_field_related_name_attribute_is_chapter_translation_verse(self):
        field = TranslationVerse._meta.get_field("chapter")
        self.assertEquals(field.__dict__['remote_field'].__dict__['related_name'], 'chapter_translation_verse')

    def test_chapter_field_has_on_delete_attribute(self):
        field = TranslationVerse._meta.get_field("chapter")
        self.assertIn('on_delete', field.__dict__['remote_field'].__dict__)

    def test_chapter_field_on_delete_attribute_is_set_null(self):
        field = TranslationVerse._meta.get_field("chapter")
        self.assertEquals(field.__dict__['remote_field'].__dict__['on_delete'], models.SET_NULL)

    def test_chapter_field_has_null_value(self):
        field = TranslationVerse._meta.get_field("chapter")
        self.assertIn('null', field.__dict__)

    def test_chapter_field_null_value_is_true(self):
        field = TranslationVerse._meta.get_field("chapter")
        self.assertTrue(field.null)

    def test_chapter_field_has_blank_value(self):
        field = TranslationVerse._meta.get_field("chapter")
        self.assertIn('blank', field.__dict__)

    def test_chapter_field_blank_value_is_true(self):
        field = TranslationVerse._meta.get_field("chapter")
        self.assertTrue(field.blank)

    # Test Chapter_number

    def test_if_it_contains_chapter_number(self):
        self.assertTrue(hasattr(TranslationVerse, 'chapter_number'))

    def test_chapter_number_field_is_instance_of_PositiveIntegerField(self):
        field = TranslationVerse._meta.get_field('chapter_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_chapter_number_field_has_blank_value(self):
        field = TranslationVerse._meta.get_field("chapter_number")
        self.assertIn('blank', field.__dict__)

    def test_chapter_number_field_is_set_blank_to_false(self):
        field = TranslationVerse._meta.get_field('chapter_number')
        self.assertFalse(field.blank)

    def test_chapter_number_field_has_null_value(self):
        field = TranslationVerse._meta.get_field("chapter_number")
        self.assertIn('null', field.__dict__)

    def test_chapter_number_field_is_set_null_to_true(self):
        field = TranslationVerse._meta.get_field('chapter_number')
        self.assertFalse(field.null)

    def test_chapter_number_attribute_has_verbose_name(self):
        field = TranslationVerse._meta.get_field('chapter_number')
        self.assertIn('verbose_name', field.__dict__)

    def test_chapter_number_field_verbose_name_attribute_is_Chapter_Number(self):
        field = TranslationVerse._meta.get_field('chapter_number')
        self.assertEqual(field.verbose_name, _('Chapter Number'))

    # Test Verse_number

    def test_it_contains_verse_number_field(self):
        self.assertTrue(hasattr(TranslationVerse, 'verse_number'))

    def test_verse_number_field_is_instance_of_PositiveIntegerField(self):
        field = TranslationVerse._meta.get_field('verse_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_verse_number_field_has_blank_value(self):
        field = TranslationVerse._meta.get_field("verse_number")
        self.assertIn('blank', field.__dict__)

    def test_verse_number_field_is_set_blank_to_false(self):
        field = TranslationVerse._meta.get_field('verse_number')
        self.assertFalse(field.blank)

    def test_verse_number_field_has_null_value(self):
        field = TranslationVerse._meta.get_field("verse_number")
        self.assertIn('null', field.__dict__)

    def test_verse_number_field_is_set_null_to_false(self):
        field = TranslationVerse._meta.get_field('verse_number')
        self.assertFalse(field.null)

    def test_verse_number_attribute_has_verbose_name(self):
        field = TranslationVerse._meta.get_field('verse_number')
        self.assertIn('verbose_name', field.__dict__)

    def test_verse_number_field_verbose_name_attribute_is_Verse_Number(self):
        field = TranslationVerse._meta.get_field('verse_number')
        self.assertEqual(field.verbose_name, _('Verse Number'))
