from django.test import TestCase
from rest_framework import serializers

from apps.chapters.factories import ChapterFactory
from apps.narrations.factories import NarrationFactory, VerseFactory
from apps.narrations.verses.serializers import VerseSerializer
from apps.parts.factories import PartFactory
from apps.quran.models import Verse


class VerseSerializerStructureTestCase(TestCase):
    def setUp(self):
        chapter = ChapterFactory()
        part = PartFactory()
        self.verse = VerseFactory(
            part=part,
            chapter=chapter,
            narration=NarrationFactory()
        )
        self.serializer = VerseSerializer(instance=self.verse)

    def test_serializer_extends_TranslatableModelSerializer(self):
        self.assertTrue(issubclass(VerseSerializer, serializers.ModelSerializer))

    def test_serializer_class_has_meta_class_on_it(self):
        self.assertIn('Meta', VerseSerializer.__dict__)

    def test_the_model_used_in_the_meta_is_verse_model(self):
        self.assertEqual(Verse, VerseSerializer.Meta.model)

    def test_id_exists_in_serializer_fields(self):
        self.assertIn('id', VerseSerializer.Meta.fields)

    def test_text_exists_in_serializer_fields(self):
        self.assertIn('text', VerseSerializer.Meta.fields)

    def test_line_start_exists_in_serializer_fields(self):
        self.assertIn('line_start', VerseSerializer.Meta.fields)

    def test_line_end_exists_in_serializer_fields(self):
        self.assertIn('line_end', VerseSerializer.Meta.fields)

    def test_image_exists_in_serializer_fields(self):
        self.assertIn('image', VerseSerializer.Meta.fields)

    def test_part_exists_in_serializer_fields(self):
        self.assertIn('part', VerseSerializer.Meta.fields)

    def test_narration_exists_in_serializer_fields(self):
        self.assertIn('narration', VerseSerializer.Meta.fields)

    def test_chapter_exists_in_serializer_fields(self):
        self.assertIn('chapter', VerseSerializer.Meta.fields)

    def test_verse_number_exists_in_serializer_fields(self):
        self.assertIn('verse_number', VerseSerializer.Meta.fields)

    def test_image_is_instance_of_drf_image_field(self):
        self.assertIsInstance(self.serializer.fields['image'], serializers.ImageField)

    def test_image_attribute_of_image_field(self):
        self.assertEqual(self.serializer.fields['image'].use_url, True)


class VerseSerializerResponseTestCase(TestCase):
    def setUp(self):
        chapter = ChapterFactory()
        part = PartFactory()
        self.verse = VerseFactory(
            part=part,
            chapter=chapter,
            narration=NarrationFactory()
        )
        self.serializer = VerseSerializer(instance=self.verse)

    def test_it_returns_expected_fields(self):
        data = self.serializer.data
        self.assertEqual(set(data.keys()), {
            'id',
            'uuid',
            'text',
            'line_start',
            'line_end',
            'image',
            'part',
            'narration',
            'chapter',
            'verse_number',
            'page_number',
            'part_number',
            'chapter_number'
        })

    def test_id_value_is_correct(self):
        self.assertEqual(self.serializer.data['id'], self.verse.id)

    def test_text_value_is_correct(self):
        self.assertEqual(self.serializer.data['text'], self.verse.text)

    def test_line_start_value_is_correct(self):
        self.assertEqual(self.serializer.data['line_start'], self.verse.line_start)

    def test_line_end_value_is_correct(self):
        self.assertEqual(self.serializer.data['line_end'], self.verse.line_end)

    def test_image_value_is_correct(self):
        self.assertEqual(self.serializer.data['image'], self.verse.image.url)

    def test_part_value_is_correct(self):
        self.assertEqual(self.serializer.data['part'], self.verse.part_id)

    def test_narration_value_is_correct(self):
        self.assertEqual(self.serializer.data['narration'], self.verse.narration_id)

    def test_chapter_value_is_correct(self):
        self.assertEqual(self.serializer.data['chapter'], self.verse.chapter_id)

    def test_verse_number_value_is_correct(self):
        self.assertEqual(self.serializer.data['verse_number'], self.verse.verse_number)
