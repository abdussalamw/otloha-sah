import inspect

import django_filters
from django.test import TestCase

from apps.main.services.service_search.search import SearchProvider
from apps.narrations.factories import NarrationFactory
from apps.narrations.filters import NarrationAPIFilter, NarrationFilter, NarrationAdminSearch
from apps.narrations.models import Narration


class NarrationFilterStructureTestCase(TestCase):
    def setUp(self):
        self.fields = NarrationFilter.get_filters()

    # Test meta class
    def test_it_has_class_meta(self):
        self.assertIn('Meta', NarrationFilter.__dict__)

    def test_it_has_model_in_class_meta(self):
        self.assertIn('model', NarrationFilter.Meta.__dict__)

    def test_meta_model_is_narration_model(self):
        self.assertEquals(Narration, NarrationFilter.Meta.model)

    def test_it_has_fields_in_class_meta(self):
        self.assertIn('fields', NarrationFilter.Meta.__dict__)

    # Test name attribute
    def test_it_has_name_attribute(self):
        self.assertTrue(hasattr(Narration, 'name'))

    def test_name_is_instance_of_char_filter(self):
        field = self.fields.get('name')
        self.assertIsInstance(field, django_filters.CharFilter)

    def test_name_has_method(self):
        field = self.fields.get('name')
        self.assertTrue(hasattr(field, 'method'))

    def test_name_method_is_name_filter(self):
        field = self.fields.get('name')
        self.assertEqual(field.method, 'name_filter')

    # Test name_filter function
    def test_it_has_name_filter_function(self):
        self.assertTrue(hasattr(NarrationFilter, 'name_filter'))

    def test_name_filter_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(NarrationFilter.name_filter)[0]
        self.assertEquals(actual_signature, expected_signature)


class NarrationFilterTestCase(TestCase):
    def setUp(self):
        for _ in range(5):
            NarrationFactory()

    def test_name_filter_filters_queryset_by_name_column(self):
        NarrationFactory(name='test')
        queryset = Narration.objects.all()
        result = NarrationFilter().name_filter(
            queryset=queryset,
            name='name',
            value="test")
        self.assertTrue(len(result) == 1)


class NarrationAdminSearchStructureTestCase(TestCase):
    def setUp(self):
        self.fields = NarrationAdminSearch.get_filters()

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

    def test_view_has_method_search_is_callable(self):
        self.assertTrue(callable(NarrationAdminSearch.search))

    def test_search_method_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(NarrationAdminSearch.search)[0]
        self.assertEquals(actual_signature, expected_signature)


class NarrationAdminSearchTestCase(TestCase):
    def test_it_filters_queryset_by_name_column(self):
        for _ in range(5):
            NarrationFactory()
        NarrationFactory(name='test')
        queryset = Narration.objects.all()
        result = NarrationAdminSearch({'q': "test"}, queryset)
        self.assertQuerysetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'description'],
            value="test"), ordered=False)

    def test_it_filters_queryset_by_description_column(self):
        for _ in range(5):
            NarrationFactory()
        NarrationFactory(description='test')
        queryset = Narration.objects.all()
        result = NarrationAdminSearch({'q': "test"}, queryset)
        self.assertQuerysetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'description'],
            value="test"), ordered=False)


class NarrationAPISearchStructureTestCase(TestCase):
    def setUp(self):
        self.fields = NarrationAPIFilter.get_filters()

    # Test meta class
    def test_it_has_class_meta(self):
        self.assertIn('Meta', NarrationAPIFilter.__dict__)

    def test_it_has_model_in_class_meta(self):
        self.assertIn('model', NarrationAPIFilter.Meta.__dict__)

    def test_meta_model_is_narration_model(self):
        self.assertEquals(Narration, NarrationAPIFilter.Meta.model)

    def test_it_has_fields_in_class_meta(self):
        self.assertIn('fields', NarrationAPIFilter.Meta.__dict__)

    def test_fields_in_class_meta_values(self):
        self.assertEqual(NarrationAPIFilter.Meta.fields, ['q', 'is_active'])

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

    def test_view_has_method_search_is_callable(self):
        self.assertTrue(callable(NarrationAPIFilter.search))

    def test_search_method_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(NarrationAPIFilter.search)[0]
        self.assertEquals(actual_signature, expected_signature)


class NarrationAPISearchTestCase(TestCase):
    # @override_settings(SEARCH_SERVICE_PROVIDER="apps.main.services.service_search.providers.SQLSearchProvider")
    def test_it_filters_queryset_by_name_column(self):
        for _ in range(5):
            NarrationFactory()
        NarrationFactory(name='te')
        queryset = Narration.objects.all()
        result = NarrationAPIFilter({'q': "te"}, queryset)
        self.assertQuerysetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'description'],
            value="te"), ordered=False)

    def test_it_filters_queryset_by_description_column(self):
        for _ in range(5):
            NarrationFactory()
        NarrationFactory(description='test')
        queryset = Narration.objects.all()
        result = NarrationAPIFilter({'q': "test"}, queryset)
        self.assertQuerysetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'description'],
            value="test"), ordered=False)
