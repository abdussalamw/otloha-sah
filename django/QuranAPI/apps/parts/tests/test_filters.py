import inspect

import django_filters
from django.test import TestCase

from apps.main.services.service_search.search import SearchProvider
from apps.parts.factories import PartFactory
from apps.parts.filters import PartFilter, PartAPISearch, PartAdminSearch
from apps.parts.models import Part


class PartFilterStructureTestCase(TestCase):

    def setUp(self):
        self.fields = PartFilter.get_filters()

    def test_it_extends_filterset(self):
        self.assertTrue(issubclass(PartFilter, django_filters.FilterSet))

    # Test meta class
    def test_it_has_meta_class(self):
        self.assertTrue(hasattr(PartFilter, 'Meta'))

    def test_meta_has_model_attribute(self):
        self.assertTrue(hasattr(PartFilter.Meta, 'model'))

    def test_meta_model_is_chapter(self):
        self.assertEqual(PartFilter.Meta.model, Part)

    def test_meta_has_fields_attribute(self):
        self.assertTrue(hasattr(PartFilter.Meta, 'fields'))

    def test_meta_fields_has_part_number(self):
        self.assertIn('part_number', PartFilter.Meta.fields)

    def test_meta_fields_has_name(self):
        self.assertIn('name', PartFilter.Meta.fields)

    def test_meta_fields_has_alias(self):
        self.assertIn('alias', PartFilter.Meta.fields)

    # Test name attribute
    def test_it_has_name_attribute(self):
        self.assertTrue(hasattr(Part, 'name'))

    def test_name_is_instance_of_char_filter(self):
        field = self.fields.get('name')
        self.assertIsInstance(field, django_filters.CharFilter)

    def test_name_has_method(self):
        field = self.fields.get('name')
        self.assertTrue(hasattr(field, 'method'))

    def test_name_method_is_name_filter(self):
        field = self.fields.get('name')
        self.assertEqual(field.method, 'name_filter')

    # Test alias attribute
    def test_alias_is_instance_of_char_filter(self):
        field = self.fields.get('alias')
        self.assertIsInstance(field, django_filters.CharFilter)

    def test_alias_has_method(self):
        field = self.fields.get('alias')
        self.assertTrue(hasattr(field, 'method'))

    def test_alias_method_is_alias_filter(self):
        field = self.fields.get('alias')
        self.assertEqual(field.method, 'alias_filter')

    # Test name_filter function
    def test_it_has_name_filter_function(self):
        self.assertTrue(hasattr(PartFilter, 'name_filter'))

    def test_name_filter_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(PartFilter.name_filter)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test alias_filter function
    def test_it_has_name_filter_function(self):
        self.assertTrue(hasattr(PartFilter, 'alias_filter'))

    def test_name_filter_signature(self):
        expected_signature = ['self', 'queryset', 'alias', 'value']
        actual_signature = inspect.getfullargspec(PartFilter.alias_filter)[0]
        self.assertEquals(actual_signature, expected_signature)


class PartFilterTestCase(TestCase):
    def setUp(self):
        for _ in range(5):
            PartFactory()

    def test_name_filter_filters_queryset_by_name_column(self):
        PartFactory(name='test')
        queryset = Part.objects.all()
        result = PartFilter().name_filter(
            queryset=queryset,
            name='name',
            value="test")
        self.assertTrue(len(result) == 1)

    def test_alias_filter_filters_queryset_by_alias_filter_column(self):
        PartFactory(alias='test')
        queryset = Part.objects.all()
        result = PartFilter().alias_filter(
            queryset=queryset,
            alias='alias',
            value="test")
        self.assertTrue(len(result) == 1)


class PartAdminSearchStructureTestCase(TestCase):
    def setUp(self):
        self.fields = PartAdminSearch.get_filters()

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
        self.assertTrue(hasattr(PartAdminSearch, 'search'))

    def test_view_has_method_search_is_callable(self):
        self.assertTrue(callable(PartAdminSearch.search))

    def test_search_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(PartAdminSearch.search)[0]
        self.assertEquals(actual_signature, expected_signature)


class PartAdminSearchTestCase(TestCase):
    def setUp(self):
        for _ in range(5):
            PartFactory()

    def test_it_filters_queryset_by_name_column(self):
        for _ in range(5):
            PartFactory()
        PartFactory(name='te')
        queryset = Part.objects.all()
        result = PartAdminSearch({'q': "te"}, queryset)
        self.assertQuerysetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'alias'],
            value="te"), ordered=False)

    def test_it_filters_queryset_by_alias_column(self):
        for _ in range(5):
            PartFactory()
        PartFactory(alias='te')
        queryset = Part.objects.all()
        result = PartAdminSearch({'q': "te"}, queryset)
        self.assertQuerysetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'alias'],
            value="te"), ordered=False)


class PartAPISearchStructureTestCase(TestCase):
    def setUp(self):
        self.fields = PartAPISearch.get_filters()

    # Test meta class
    def test_it_has_meta_class(self):
        self.assertTrue(hasattr(PartAPISearch, 'Meta'))

    def test_meta_has_model_attribute(self):
        self.assertTrue(hasattr(PartAPISearch.Meta, 'model'))

    def test_meta_model_is_chapter(self):
        self.assertEqual(PartAPISearch.Meta.model, Part)

    def test_meta_has_fields_attribute(self):
        self.assertTrue(hasattr(PartAPISearch.Meta, 'fields'))

    def test_meta_fields_has_part_number(self):
        self.assertIn('part_number', PartAPISearch.Meta.fields)

    def test_meta_fields_has_is_active(self):
        self.assertIn('is_active', PartAPISearch.Meta.fields)

    def test_meta_fields_has_q(self):
        self.assertIn('q', PartAPISearch.Meta.fields)

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
        self.assertTrue(hasattr(PartAPISearch, 'search'))

    def test_view_has_method_search_is_callable(self):
        self.assertTrue(callable(PartAPISearch.search))

    def test_search_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(PartAPISearch.search)[0]
        self.assertEquals(actual_signature, expected_signature)


class PartAPISearchTestCase(TestCase):
    def setUp(self):
        for _ in range(5):
            PartFactory()

    def test_it_filters_queryset_by_name_column(self):
        for _ in range(5):
            PartFactory()
        PartFactory(name='te')
        queryset = Part.objects.all()
        result = PartAPISearch({'q': "te"}, queryset)
        self.assertQuerysetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'alias'],
            value="te"), ordered=False)

    def test_it_filters_queryset_by_alias_column(self):
        for _ in range(5):
            PartFactory()
        PartFactory(alias='te')
        queryset = Part.objects.all()
        result = PartAPISearch({'q': "te"}, queryset)
        self.assertQuerysetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'alias'],
            value="te"), ordered=False)