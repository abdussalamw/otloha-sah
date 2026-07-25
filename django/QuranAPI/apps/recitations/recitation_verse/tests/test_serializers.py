from django.test import TestCase
from rest_framework.serializers import ModelSerializer

from apps.chapters.factories import ChapterFactory
from apps.recitations.factories import RecitationFactory, ReciterFactory, RecitationVerseFactory
from apps.recitations.models import RecitationVerse
from apps.recitations.recitation_verse.serializers_v1 import RecitationVerseSerializer


class RecitationVerseSerializerStructureTestCase(TestCase):
    def test_it_extends_model_serializer(self):
        self.assertTrue(issubclass(RecitationVerseSerializer, ModelSerializer))

    def test_if_class_meta_exists(self):
        self.assertIsNotNone(RecitationVerseSerializer.Meta)

    def test_if_model_in_meta_extends_recitation_verse_model(self):
        self.assertEqual(RecitationVerseSerializer.Meta.model, RecitationVerse)

    def test_if_fields_in_meta_exists(self):
        self.assertIsNotNone(RecitationVerseSerializer.Meta.fields)

    def test_if_fields_in_meta_has_id_field(self):
        self.assertIn('id', list(RecitationVerseSerializer.Meta.fields))

    def test_if_fields_in_meta_has_recitation_field(self):
        self.assertIn('recitation', list(RecitationVerseSerializer.Meta.fields))

    def test_if_fields_in_meta_has_record_field(self):
        self.assertIn('record', list(RecitationVerseSerializer.Meta.fields))

    def test_if_fields_in_meta_has_verse_number_field(self):
        self.assertIn('verse_number', list(RecitationVerseSerializer.Meta.fields))

    def test_if_fields_in_meta_has_chapter_field(self):
        self.assertIn('chapter', list(RecitationVerseSerializer.Meta.fields))


class RecitationVerseSerializerTestCase(TestCase):
    def setUp(self):
        self.recitation_verse = RecitationVerseFactory(recitation=RecitationFactory(reciter=ReciterFactory()), chapter=ChapterFactory())
        self.serializer = RecitationVerseSerializer(self.recitation_verse)

    def test_id_field_in_the_data(self):
        self.assertIn('id', self.serializer.data.keys())

    def test_id_field_is_correct(self):
        self.assertEqual(self.serializer.data['id'], self.recitation_verse.id)

    def test_recitation_field_in_the_data(self):
        self.assertIn('recitation', self.serializer.data.keys())

    def test_recitation_field_is_correct(self):
        self.assertEqual(self.serializer.data['recitation'], self.recitation_verse.recitation.id)

    def test_verse_number_field_in_the_data(self):
        self.assertIn('verse_number', self.serializer.data.keys())

    def test_verse_number_field_is_correct(self):
        self.assertEqual(self.serializer.data['verse_number'], self.recitation_verse.verse_number)

    def test_chapter_field_in_the_data(self):
        self.assertIn('chapter', self.serializer.data.keys())

    def test_chapter_field_is_correct(self):
        self.assertEqual(self.serializer.data['chapter'], self.recitation_verse.chapter.pk)
