from django.test import TestCase
from rest_framework import serializers
from translation.serializers import TranslatableModelSerializer

from apps.chapters.factories import ChapterFactory
from apps.translations.factories import TranslationFactory
from apps.translations.models import Translation, TranslationVerse
from apps.translations.serializers import TranslationSerializer, TranslationVerseSerializer


class TranslationSerializerStructureTestCase(TestCase):
    def test_it_extends_django_Serializer(self):
        self.assertTrue(issubclass(TranslationSerializer, TranslatableModelSerializer))

    def test_serializer_class_has_meta_class_on_it(self):
        self.assertIn('Meta', TranslationSerializer.__dict__)

    def test_serializer_class_meta_has_model_on_it(self):
        self.assertIn('model', TranslationSerializer.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Translation_model(self):
        self.assertEqual(Translation, TranslationSerializer.Meta.model)

    def test_serializer_class_meta_has_fields_on_it(self):
        self.assertIn('fields', TranslationSerializer.Meta.__dict__)

    def test_serializer_class_meta_fields_is_a_list(self):
        self.assertEqual(type(TranslationSerializer.Meta.fields), list)

    def test_class_meta_fields_has_name(self):
        self.assertIn('name', TranslationSerializer.Meta.fields)

    def test_class_meta_fields_has_language(self):
        self.assertIn('language', TranslationSerializer.Meta.fields)

    def test_class_meta_fields_has_author(self):
        self.assertIn('author', TranslationSerializer.Meta.fields)

    def test_it_get_serialized_data_correctly(self):
        data = {
            'name': 'Bokhari Tajweed Translation',
            'language': 'en',
            'author': 'Bokhari',
        }
        serializer = TranslationSerializer(data=data)
        self.assertTrue(serializer.is_valid())
        self.assertEqual(data, serializer.initial_data)


class TranslationVerseSerializerStructureTestCase(TestCase):
    def test_it_extends_django_Serializer(self):
        self.assertTrue(issubclass(TranslationVerseSerializer, serializers.ModelSerializer))

    def test_serializer_class_has_meta_class_on_it(self):
        self.assertIn('Meta', TranslationVerseSerializer.__dict__)

    def test_serializer_class_meta_has_model_on_it(self):
        self.assertIn('model', TranslationVerseSerializer.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_TranslationVerse_model(self):
        self.assertEqual(TranslationVerse, TranslationVerseSerializer.Meta.model)

    def test_serializer_class_meta_has_fields_on_it(self):
        self.assertIn('fields', TranslationVerseSerializer.Meta.__dict__)

    def test_serializer_class_meta_fields_is_a_list(self):
        self.assertEqual(type(TranslationVerseSerializer.Meta.fields), list)

    def test_class_meta_fields_has_text(self):
        self.assertIn('text', TranslationVerseSerializer.Meta.fields)

    def test_class_meta_fields_has_translation(self):
        self.assertIn('translation', TranslationVerseSerializer.Meta.fields)

    def test_class_meta_fields_has_chapter(self):
        self.assertIn('chapter', TranslationVerseSerializer.Meta.fields)

    def test_class_meta_fields_has_chapter_number(self):
        self.assertIn('chapter_number', TranslationVerseSerializer.Meta.fields)

    def test_class_meta_fields_has_verse_number(self):
        self.assertIn('verse_number', TranslationVerseSerializer.Meta.fields)

    def test_it_get_serialized_data_correctly(self):
        data = {
            'text': 'translated verses',
            'translation': TranslationFactory().pk,
            'chapter': ChapterFactory().pk,
            'chapter_number': 2,
            'verse_number': 3,
        }
        serializer = TranslationVerseSerializer(data=data)
        self.assertTrue(serializer.is_valid())
        self.assertEqual(data, serializer.initial_data)
