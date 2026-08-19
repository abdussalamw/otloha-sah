import inspect

import django_filters
from django.test import TestCase
from django_filters import FilterSet

from apps.main.services.service_search.search import SearchProvider
from apps.narrations.factories import NarrationFactory
from apps.tajweed.books.filters import BookFilter, BookAdminSearch, BookAPISearch
from apps.tajweed.factories import TajweedBookFactory
from apps.tajweed.models import Book


class BookFilterStructureTestCase(TestCase):
    def test_it_extends_django_Filter(self):
        self.assertTrue(issubclass(BookFilter, FilterSet))

    def test_filter_class_has_meta_class_on_it(self):
        self.assertIn('Meta', BookFilter.__dict__)

    def test_filter_class_meta_has_model_on_it(self):
        self.assertIn('model', BookFilter.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Book_model(self):
        self.assertEqual(Book, BookFilter.Meta.model)

    def test_filter_class_meta_has_fields_on_it(self):
        self.assertIn('fields', BookFilter.Meta.__dict__)

    def test_filter_class_meta_fields_is_a_list(self):
        self.assertEqual(type(BookFilter.Meta.fields), list)

    def test_class_meta_fields_has_narration(self):
        self.assertIn('narration', BookFilter.Meta.fields)


class BookFilterTestCase(TestCase):
    def setUp(self):
        self.narration_1 = NarrationFactory()
        self.narration_2 = NarrationFactory()

    def test_it_filters_based_on_narration_correctly(self):
        for i in range(5):
            TajweedBookFactory(narration=self.narration_1)
        for i in range(2):
            TajweedBookFactory(narration=self.narration_2)
        result = BookFilter({'narration': self.narration_1}, Book.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual(self.narration_1, result[0].narration)


class BookAdminSearchStructureTestCase(TestCase):
    def setUp(self):
        self.fields = BookAdminSearch.get_filters()

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
        self.assertTrue(hasattr(BookAdminSearch, 'search'))

    def test_view_has_method_search_is_callable(self):
        self.assertTrue(callable(BookAdminSearch.search))

    def test_search_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(BookAdminSearch.search)[0]
        self.assertEqual(actual_signature, expected_signature)


class BookAdminSearchTestCase(TestCase):
    def test_it_filters_queryset_by_name_column(self):
        for _ in range(5):
            TajweedBookFactory()
        TajweedBookFactory(name='test')
        queryset = Book.objects.all()
        result = BookAdminSearch({'q': "test"}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'author'],
            value="test"), ordered=False)

    def test_it_filters_queryset_by_author_column(self):
        for _ in range(5):
            TajweedBookFactory()
        TajweedBookFactory(author='test')
        queryset = Book.objects.all()
        result = BookAdminSearch({'q': 'test'}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'author'],
            value='test'), ordered=False)


class BookAPISearchStructureTestCase(TestCase):
    def setUp(self):
        self.fields = BookAPISearch.get_filters()

    # test meta
    def test_it_has_meta_class(self):
        self.assertTrue(hasattr(BookAPISearch, 'Meta'))

    def test_model_used_in_meta_class(self):
        self.assertEqual(BookAPISearch.Meta.model, Book)

    def test_fields_used_in_meta_class(self):
        self.assertEqual(BookAPISearch.Meta.fields, ['narration'])

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
        self.assertTrue(hasattr(BookAPISearch, 'search'))

    def test_view_has_method_search_is_callable(self):
        self.assertTrue(callable(BookAPISearch.search))

    def test_search_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(BookAPISearch.search)[0]
        self.assertEqual(actual_signature, expected_signature)


class BookAPISearchTestCase(TestCase):
    def test_it_filter_queryset_by_narration(self):
        narration = NarrationFactory()
        for _ in range(5):
            TajweedBookFactory(narration=narration)
        queryset = Book.objects.all()
        result = BookAPISearch({'narrations': narration.pk}, queryset).qs
        self.assertEqual(5, len(result))

    def test_it_filters_queryset_by_name_column(self):
        for _ in range(5):
            TajweedBookFactory()
        TajweedBookFactory(name='test')
        queryset = Book.objects.all()
        result = BookAPISearch({'q': "test"}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'author'],
            value="test"), ordered=False)

    def test_it_filters_queryset_by_author_column(self):
        for _ in range(5):
            TajweedBookFactory()
        TajweedBookFactory(author='test')
        queryset = Book.objects.all()
        result = BookAPISearch({'q': 'test'}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'author'],
            value='test'), ordered=False)
