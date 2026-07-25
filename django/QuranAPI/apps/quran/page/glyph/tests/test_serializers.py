from django.test import TestCase
from rest_framework import serializers

from apps.quran.page.glyph.serializers import GlyphSerializer
from apps.quran.factories import ChapterFactory, VerseFactory, PageFactory, GlyphFactory, BookFactory, NarrationFactory, \
    PartFactory
from apps.quran.models import Glyph


class GlyphSerializerStructureTestCase(TestCase):
    def test_serializer_extends_model_serializer(self):
        self.assertTrue(issubclass(GlyphSerializer, serializers.ModelSerializer))

    def test_serializer_class_has_meta_class_on_it(self):
        self.assertIn('Meta', GlyphSerializer.__dict__)

    def test_the_model_used_in_the_meta_is_glyph_model(self):
        self.assertEquals(Glyph, GlyphSerializer.Meta.model)

    def test_id_exists_in_serializer_fields(self):
        self.assertIn('id', GlyphSerializer.Meta.fields)

    def test_page_exists_in_serializer_fields(self):
        self.assertIn('page', GlyphSerializer.Meta.fields)

    def test_verse_exists_in_serializer_fields(self):
        self.assertIn('verses', GlyphSerializer.Meta.fields)

    def test_line_number_exists_in_serializer_fields(self):
        self.assertIn('line_number', GlyphSerializer.Meta.fields)

    def test_position_exists_in_serializer_fields(self):
        self.assertIn('position', GlyphSerializer.Meta.fields)

    def test_min_x_exists_in_serializer_fields(self):
        self.assertIn('min_x', GlyphSerializer.Meta.fields)

    def test_min_y_exists_in_serializer_fields(self):
        self.assertIn('min_y', GlyphSerializer.Meta.fields)

    def test_max_x_exists_in_serializer_fields(self):
        self.assertIn('max_x', GlyphSerializer.Meta.fields)

    def test_max_y_exists_in_serializer_fields(self):
        self.assertIn('max_y', GlyphSerializer.Meta.fields)


class GlyphSerializerResponseTestCase(TestCase):
    def setUp(self):
        book = BookFactory(narration=NarrationFactory())
        chapter = ChapterFactory()
        part = PartFactory()
        page = PageFactory(
            book=book,
            part=part
        )
        chapter.chapter_modelChapter.create(content_object=book)
        chapter.chapter_modelChapter.create(content_object=page)
        verse = VerseFactory(
            book=book,
            page=page,
            part=part,
            chapter=chapter
        )
        self.glyph = GlyphFactory(chapter=chapter, verse=verse, page=page)
        self.serializer = GlyphSerializer(instance=self.glyph)

    def test_it_returns_expected_fields(self):
        data = self.serializer.data
        self.assertEquals(set(data.keys()), {
            'id',
            'chapter',
            'page',
            'verses',
            'line_number',
            'min_x',
            'max_x',
            'min_y',
            'max_y',
            'position'
        })

    def test_id_value_is_correct(self):
        self.assertEquals(self.serializer.data['id'], self.glyph.id)

    def test_chapter_value_is_correct(self):
        self.assertEquals(self.serializer.data['chapter'], self.glyph.chapter_id)

    def test_page_value_is_correct(self):
        self.assertEquals(self.serializer.data['page'], self.glyph.page_id)

    def test_verse_value_is_correct(self):
        self.assertEquals(self.serializer.data['verses'], self.glyph.verse_id)

    def test_line_number_value_is_correct(self):
        self.assertEquals(self.serializer.data['line_number'], self.glyph.line_number)

    def test_min_x_value_is_correct(self):
        self.assertEquals(self.serializer.data['min_x'], self.glyph.min_x)

    def test_max_x_value_is_correct(self):
        self.assertEquals(self.serializer.data['max_x'], self.glyph.max_x)

    def test_min_y_value_is_correct(self):
        self.assertEquals(self.serializer.data['min_y'], self.glyph.min_y)

    def test_max_y_value_is_correct(self):
        self.assertEquals(self.serializer.data['max_y'], self.glyph.max_y)

    def test_position_value_is_correct(self):
        self.assertEquals(self.serializer.data['position'], self.glyph.position)
