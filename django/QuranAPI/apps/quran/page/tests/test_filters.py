import inspect

import django_filters
from django.test import TestCase

from apps.chapters.factories import ChapterFactory
from apps.main.services.service_search.search import SearchProvider
from apps.narrations.factories import NarrationFactory, VerseFactory
from apps.parts.factories import PartFactory
from apps.quran.factories import PageFactory, BookFactory, GlyphFactory
from apps.quran.models import Page, Chapter
from apps.quran.page.filters import PageAPIFilter


class PageAPIFilterStructureTestCase(TestCase):
    def setUp(self):
        self.fields = PageAPIFilter.get_filters()

    def test_it_has_class_meta(self):
        self.assertIn('Meta', PageAPIFilter.__dict__)

    def test_it_has_model_in_class_meta(self):
        self.assertIn('model', PageAPIFilter.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_reciter_Model(self):
        self.assertEquals(Page, PageAPIFilter.Meta.model)

    def test_it_has_fields_in_class_meta(self):
        self.assertIn('fields', PageAPIFilter.Meta.__dict__)

    def test_page_number_exists_in_filter_fields(self):
        self.assertIn('page_number', PageAPIFilter.Meta.fields)

    def test_sub_part_exists_in_filter_fields(self):
        self.assertIn('sub_part', PageAPIFilter.Meta.fields)

    def test_part_exists_in_filter_fields(self):
        self.assertIn('part', PageAPIFilter.Meta.fields)

    def test_chapters_exists_in_filter_fields(self):
        self.assertIn('chapters', PageAPIFilter.Meta.fields)

    def test_book_exists_in_filter_fields(self):
        self.assertIn('book', PageAPIFilter.Meta.fields)

    def test_narration_exists_in_filter_fields(self):
        self.assertIn('narration', PageAPIFilter.Meta.fields)

    def test_it_has_q_field(self):
        self.assertIn('q', self.fields)

    def test_q_field_uses_filter_char_field(self):
        field = self.fields.get('q')
        self.assertIsInstance(field, django_filters.CharFilter)

    def test_it_has_search_method(self):
        self.assertTrue(hasattr(PageAPIFilter, 'search'))

    def test_search_is_callable(self):
        self.assertTrue(callable(PageAPIFilter.search))

    def test_search_method_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(PageAPIFilter.search)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_q_field_uses_search_method(self):
        field = self.fields.get('q')
        self.assertEquals('search', field.method)

    def test_it_has_chapters_field(self):
        self.assertIn('chapters', self.fields)

    def test_chapters_field_uses_filter_model_multiple_choice_field(self):
        field = self.fields.get('chapters')
        self.assertIsInstance(field, django_filters.ModelMultipleChoiceFilter)

    def test_chapters_field_uses_queryset(self):
        field = self.fields.get('chapters')
        self.assertQuerysetEqual(Chapter.objects.all(), field.queryset)

    def test_chapters_field_uses_field_name(self):
        field = self.fields.get('chapters')
        self.assertQuerysetEqual("chapter__id", field.field_name)


class PageAPIFilterResultTestCase(TestCase):
    def create_page(self):
        narration = NarrationFactory()
        book = BookFactory(narration=narration)
        chapter = ChapterFactory()
        part = PartFactory()
        page = PageFactory(
            narration=book.narration,
            book=book,
            part=part
        )
        chapter.chaptermodel_set.create(content_object=book)
        chapter.chaptermodel_set.create(content_object=page)
        for i in range(5):
            verse = VerseFactory(
                narration=narration,
                part=part,
                chapter=chapter
            )
            GlyphFactory(page=page, verse=verse)
        return page

    def setUp(self):
        for j in range(5):
            self.create_page()

        page = Page.objects.first()
        page.page_number = 1
        page.save()

        self.verse = VerseFactory(
            text="test",
            narration=page.narration,
            part=page.part,
        )
        self.qs = Page.objects.all()

    def test_searched_queryset_is_correct(self):
        result = PageAPIFilter(queryset=self.qs, data={"q": "tes"})
        self.assertQuerysetEqual(result.qs, Page.objects.filter(verse__text__icontains="tes"))

    def test_part_filtered_queryset_is_correct(self):
        result = PageAPIFilter(queryset=self.qs, data={"part": 1})
        self.assertQuerysetEqual(result.qs, Page.objects.filter(part_id=1))

    def test_book_filtered_queryset_is_correct(self):
        result = PageAPIFilter(queryset=self.qs, data={"book": 1})
        self.assertQuerysetEqual(result.qs, Page.objects.filter(book_id=1))

    def test_filtered_narration_queryset_is_correct(self):
        result = PageAPIFilter(queryset=self.qs, data={"narration": 1})
        self.assertQuerysetEqual(result.qs, Page.objects.filter(narration_id=1))

    def test_page_number_filtered_queryset_is_correct(self):
        result = PageAPIFilter(queryset=self.qs, data={"page_number": 1})
        print(Page.objects.filter(page_number=1))
        self.assertQuerysetEqual(result.qs, Page.objects.filter(page_number=1))

    def test_sub_part_filtered_queryset_is_correct(self):
        result = PageAPIFilter(queryset=self.qs, data={"sub_part": 1})
        self.assertQuerysetEqual(result.qs, Page.objects.filter(sub_part=1))


class PageAPIFilterSearchTestCase(TestCase):
    def test_it_filters_queryset_by_name_column(self):
        narration = NarrationFactory()
        for _ in range(5):
            p = PageFactory()
            VerseFactory(narration=narration)
        page = PageFactory()
        VerseFactory(text="test", narration=narration)
        queryset = Page.objects.all()
        result = PageAPIFilter().search(
            queryset=queryset,
            value="te",
            name="q")
        self.assertQuerysetEqual(result, SearchProvider().search(
            queryset=queryset,
            columns=['verse__text'],
            value="te"), ordered=False)
