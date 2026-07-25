from django.test import TestCase
from translation.serializers import TranslatableModelSerializer

from apps.chapters.factories import ChapterFactory
from apps.chapters.models import Chapter
from apps.chapters.serializers import ChapterSerializer


class ChapterSerializerStructureTestCase(TestCase):
    def test_it_extends_translatable_model_serializer(self):
        self.assertTrue(issubclass(ChapterSerializer, TranslatableModelSerializer))

    # Test Meta class
    def test_it_has_meta_class(self):
        self.assertTrue(hasattr(ChapterSerializer, 'Meta'))
    
    def test_meta_has_model(self):
        self.assertTrue(hasattr(ChapterSerializer.Meta, 'model'))

    def test_meta_model_is_part(self):
        self.assertEqual(ChapterSerializer.Meta.model, Chapter)

    def test_meta_has_fields(self):
        self.assertTrue(hasattr(ChapterSerializer.Meta, 'fields'))

    def test_meta_fields_has_id(self):
        self.assertIn('id', ChapterSerializer.Meta.fields)

    def test_meta_fields_has_name(self):
        self.assertIn('name', ChapterSerializer.Meta.fields)

    def test_meta_fields_has_chapter_number(self):
        self.assertIn('chapter_number', ChapterSerializer.Meta.fields)

    def test_meta_fields_has_origin(self):
        self.assertIn('origin', ChapterSerializer.Meta.fields)


class PartSerializerResponseTestCase(TestCase):
    def setUp(self):
        self.chapter = ChapterFactory()
        self.serializer = ChapterSerializer(instance=self.chapter)
        self.data = self.serializer.data

    def test_it_returns_expected_fields(self):
        self.assertEqual(set(self.data.keys()), {'id', 'name', 'chapter_number', 'origin', 'chapter_metadata'})

    def test_id_has_correct_value(self):
        self.assertEquals(self.data['id'], self.chapter.pk)

    def test_name_has_correct_value(self):
        self.assertEquals(self.data['name'], self.chapter.translated_name)

    def test_chapter_number_has_correct_value(self):
        self.assertEquals(self.data['chapter_number'], self.chapter.chapter_number)

    def test_origin_has_correct_value(self):
        self.assertEquals(self.data['origin'], self.chapter.origin)