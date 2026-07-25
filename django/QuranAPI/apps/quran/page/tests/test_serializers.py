import inspect

from django.test import TestCase
from rest_framework import serializers

from apps.quran.page.glyph.serializers import GlyphSerializer
from apps.quran.page.serializers import PageSerializer
from apps.quran.page.verse.serializers import VerseSerializer
from apps.quran.factories import PageFactory, PartFactory, BookFactory, ChapterFactory, \
    NarrationFactory, VerseFactory, GlyphFactory
from apps.quran.models import Page


class PageSerializerStructureTestCase(TestCase):
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
        for i in range(5):
            verse = VerseFactory(
                book=book,
                page=page,
                part=part,
                chapter=chapter
            )
            GlyphFactory(page=page, verse=verse)

        self.serializer = PageSerializer(instance=page)

    def test_serializer_extends_model_serializer(self):
        self.assertTrue(issubclass(PageSerializer, serializers.ModelSerializer))

    def test_serializer_class_has_meta_class_on_it(self):
        self.assertIn('Meta', PageSerializer.__dict__)

    def test_the_model_used_in_the_meta_is_page_model(self):
        self.assertEquals(Page, PageSerializer.Meta.model)

    def test_id_exists_in_serializer_fields(self):
        self.assertIn('id', PageSerializer.Meta.fields)

    def test_image_exists_in_serializer_fields(self):
        self.assertIn('image', PageSerializer.Meta.fields)

    def test_page_number_exists_in_serializer_fields(self):
        self.assertIn('page_number', PageSerializer.Meta.fields)

    def test_sub_part_exists_in_serializer_fields(self):
        self.assertIn('sub_part', PageSerializer.Meta.fields)

    def test_part_exists_in_serializer_fields(self):
        self.assertIn('part', PageSerializer.Meta.fields)

    def test_chapters_exists_in_serializer_fields(self):
        self.assertIn('chapters', PageSerializer.Meta.fields)

    def test_book_exists_in_serializer_fields(self):
        self.assertIn('book', PageSerializer.Meta.fields)

    def test_narration_exists_in_serializer_fields(self):
        self.assertIn('narrations', PageSerializer.Meta.fields)

    def test_verses_exists_in_serializer_fields(self):
        self.assertIn('verses', PageSerializer.Meta.fields)

    def test_glyphs_exists_in_serializer_fields(self):
        self.assertIn('glyphs', PageSerializer.Meta.fields)

    def test_image_is_instance_of_drf_image_field(self):
        self.assertIsInstance(self.serializer.fields['image'], serializers.ImageField)

    def test_image_attribute_of_image_field(self):
        self.assertEquals(self.serializer.fields['image'].use_url, True)

    def test_verses_field_source_attribute_is_set_to_pages_verse(self):
        self.assertEquals(self.serializer.fields['verses'].source, "pages_verse")

    def test_read_only_attribute_verse_field(self):
        self.assertTrue(self.serializer.fields['verses'].read_only)

    def test_read_only_attribute_of_glyph_field(self):
        self.assertEquals(self.serializer.fields['glyphs'].read_only, True)

    def test_many_attribute_of_verse(self):
        self.assertEquals(self.serializer.fields['verses'].many, True)

    def test_many_attribute_of_glyph(self):
        self.assertEquals(self.serializer.fields['glyphs'].many, True)

    def test_it_has_verses_field(self):
        self.assertIn('verses', self.serializer.fields)

    def test_it_has_glyph_field(self):
        self.assertIn('glyphs', self.serializer.fields)

    def test_it_has_image_field(self):
        self.assertIn('image', self.serializer.fields)

    def test_glyphs_field_source_attribute_is_set_to_page_glyph(self):
        self.assertEquals(self.serializer.fields['glyphs'].source, "page_glyph")

    def test_chapters_attribute_is_instance_of_serializer_method_field(self):
        self.assertIsInstance(self.serializer.fields['chapters'], serializers.SerializerMethodField)

    def test_chapters_method_name_is_get_chapters(self):
        self.assertEquals(self.serializer.fields['chapters'].method_name, "get_chapters")

    def test_it_has_get_chapters_attribute(self):
        self.assertTrue(hasattr(PageSerializer, 'get_chapters'))

    def test_get_chapters_is_callable(self):
        self.assertTrue(callable(PageSerializer.get_chapters))

    def test_get_chapters_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(PageSerializer.get_chapters)[0]
        self.assertEquals(actual_signature, expected_signature)


class PageSerializerResponseTestCase(TestCase):
    def setUp(self):
        book = BookFactory(narration=NarrationFactory())
        chapter = ChapterFactory()
        part = PartFactory()
        self.page = PageFactory(book=book, part=part)
        chapter.chapter_modelChapter.create(content_object=book)
        chapter.chapter_modelChapter.create(content_object=self.page)
        for i in range(5):
            verse = VerseFactory(
                book=book,
                page=self.page,
                part=part,
                chapter=chapter
            )
            GlyphFactory(page=self.page, verse=verse)
        self.serializer = PageSerializer(instance=self.page)

    def test_it_returns_expected_fields(self):
        data = self.serializer.data
        self.assertEquals(set(data.keys()), {
            "id",
            "image",
            "page_number",
            "sub_part",
            "chapters",
            "part",
            "book",
            "narrations",
            "verses",
            "glyphs"
        })

    def test_id_value_is_correct(self):
        self.assertEquals(self.serializer.data['id'], self.page.id)

    def test_image_value_is_correct(self):
        self.assertEquals(self.serializer.data['image'], self.page.image.url)

    def test_page_number_value_is_correct(self):
        self.assertEquals(self.serializer.data['page_number'], self.page.page_number)

    def test_sub_part_value_is_correct(self):
        self.assertEquals(self.serializer.data['sub_part'], self.page.sub_part)

    def test_part_value_is_correct(self):
        self.assertEquals(self.serializer.data['part'], self.page.part_id)

    def test_book_value_is_correct(self):
        self.assertEquals(self.serializer.data['book'], self.page.book_id)

    def test_narration_value_is_correct(self):
        self.assertEquals(self.serializer.data['narrations'], self.page.narration_id)

    def test_verses_value_is_correct(self):
        self.assertEquals(self.serializer.data['verses'],
                          VerseSerializer(self.page.pages_verse.all(), many=True).data)

    def test_glyphs_value_is_correct(self):
        self.assertEquals(self.serializer.data['glyphs'],
                          GlyphSerializer(self.page.page_glyph.all(), many=True).data)

    def test_chapters_value_is_correct(self):
        chapters = list(self.page.chapters.values_list('chapter_id', flat=True))
        self.assertEquals(self.serializer.data['chapters'], chapters)


class PageSerializerGetChaptersTestCase(TestCase):
    def test_it_returns_list_of_chapters_ids(self):
        book = BookFactory(narration=NarrationFactory())
        part = PartFactory()
        page = PageFactory(book=book, part=part)
        for i in range(3):
            chapter = ChapterFactory()
            chapter.chapter_modelChapter.create(content_object=page)
            chapter.chapter_modelChapter.create(content_object=book)
        serializer = PageSerializer(instance=page)
        self.assertEquals(serializer.data['chapters'],
                          list(page.chapters.values_list('chapter_id', flat=True)))
