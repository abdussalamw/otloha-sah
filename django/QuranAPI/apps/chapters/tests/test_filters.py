import inspect

import django_filters
from django.test import TestCase

from apps.chapters.factories import ChapterFactory
from apps.chapters.filters import ChapterFilter, ChapterAPISearch, ChapterAdminSearch
from apps.chapters.models import Chapter
from apps.main.services.service_search.search import SearchProvider


class ChapterFilterStructureTestCase(TestCase):
    def test_it_extends_filterset(self):
        self.assertTrue(issubclass(ChapterFilter, django_filters.FilterSet))

    # Test meta class
    def test_it_has_meta_class(self):
        self.assertTrue(hasattr(ChapterFilter, 'Meta'))

    def test_meta_has_model_attribute(self):
        self.assertTrue(hasattr(ChapterFilter.Meta, 'model'))

    def test_meta_model_is_chapter(self):
        self.assertEqual(ChapterFilter.Meta.model, Chapter)

    def test_meta_has_fields_attribute(self):
        self.assertTrue(hasattr(ChapterFilter.Meta, 'fields'))

    def test_meta_fields_has_origin(self):
        self.assertIn('origin', ChapterFilter.Meta.fields)


class ChapterFilterTestCase(TestCase):
    def test_it_filter_queryset_by_origin(self):
        for _ in range(5):
            ChapterFactory()
        queryset = Chapter.objects.all()
        result = ChapterFilter({'origin': 'makkiah'}, queryset).qs
        self.assertGreater(len(queryset), len(result))


class ChapterAdminSearchStructureTestCase(TestCase):
    def setUp(self):
        self.fields = ChapterAdminSearch.get_filters()

    # Test q field
    def test_it_has_q_field(self):
        self.assertIn('q', self.fields)

    def test_q_field_uses_filter_char_field(self):
        field = self.fields.get('q')
        self.assertIsInstance(field, django_filters.CharFilter)

    def test_q_has_method(self):
        field = self.fields.get('q')
        self.assertTrue(hasattr(field, 'method'))

    def test_q_method_is_search(self):
        field = self.fields.get('q')
        self.assertEqual(field.method, 'search')

    # Test search function
    def test_it_has_search_function(self):
        self.assertTrue(hasattr(ChapterAdminSearch, 'search'))

    def test_view_has_method_search_is_callable(self):
        self.assertTrue(callable(ChapterAdminSearch.search))

    def test_search_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(ChapterAdminSearch.search)[0]
        self.assertEquals(actual_signature, expected_signature)


class ChapterAdminSearchTestCase(TestCase):
    def test_it_filters_queryset_by_name_column(self):
        for _ in range(5):
            ChapterFactory()
        ChapterFactory(name='test')
        queryset = Chapter.objects.all()
        result = ChapterAdminSearch({'q': "test"}, queryset)
        self.assertQuerysetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'chapter_number'],
            value="test"), ordered=False)

    def test_it_filters_queryset_by_chapter_number_column(self):
        for _ in range(5):
            ChapterFactory()
        ChapterFactory(chapter_number=1)
        queryset = Chapter.objects.all()
        result = ChapterAdminSearch({'q': 1}, queryset)
        self.assertQuerysetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'chapter_number'],
            value=1), ordered=False)


class ChapterAPISearchStructureTestCase(TestCase):
    def setUp(self):
        self.fields = ChapterAPISearch.get_filters()

    # test meta
    def test_it_has_meta_class(self):
        self.assertTrue(hasattr(ChapterAPISearch, 'Meta'))

    def test_model_used_in_meta_class(self):
        self.assertEqual(ChapterAPISearch.Meta.model, Chapter)

    def test_fields_used_in_meta_class(self):
        self.assertEqual(ChapterAPISearch.Meta.fields, ['origin', 'chapter_number'])

    # Test q field
    def test_it_has_q_field(self):
        self.assertIn('q', self.fields)

    def test_q_field_uses_filter_char_field(self):
        field = self.fields.get('q')
        self.assertIsInstance(field, django_filters.CharFilter)

    def test_q_has_method(self):
        field = self.fields.get('q')
        self.assertTrue(hasattr(field, 'method'))

    def test_q_method_is_search(self):
        field = self.fields.get('q')
        self.assertEqual(field.method, 'search')

    # Test search function
    def test_it_has_search_function(self):
        self.assertTrue(hasattr(ChapterAPISearch, 'search'))

    def test_view_has_method_search_is_callable(self):
        self.assertTrue(callable(ChapterAPISearch.search))

    def test_search_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(ChapterAPISearch.search)[0]
        self.assertEquals(actual_signature, expected_signature)


class ChapterAPISearchTestCase(TestCase):
    def test_it_filter_queryset_by_origin(self):
        for _ in range(5):
            ChapterFactory()
        queryset = Chapter.objects.all()
        result = ChapterAPISearch({'origin': 'makkiah'}, queryset).qs
        self.assertGreater(len(queryset), len(result))

    def test_it_filters_queryset_by_name_column(self):
        for _ in range(5):
            ChapterFactory()
        ChapterFactory(name='test')
        queryset = Chapter.objects.all()
        result = ChapterAPISearch({'q': "test"}, queryset)
        self.assertQuerysetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'chapter_number'],
            value="test"), ordered=False)

    def test_it_filters_queryset_by_chapter_number_column(self):
        for _ in range(5):
            ChapterFactory()
        ChapterFactory(chapter_number=1)
        queryset = Chapter.objects.all()
        result = ChapterAPISearch({'q': 1}, queryset)
        self.assertQuerysetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'chapter_number'],
            value=1), ordered=False)
