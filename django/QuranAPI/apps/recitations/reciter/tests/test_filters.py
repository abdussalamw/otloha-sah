import inspect

import django_filters
from django.test import TestCase

from apps.main.services.service_search.search import SearchProvider
from apps.recitations.factories import ReciterFactory
from apps.recitations.models import Reciter
from apps.recitations.reciter.filters import ReciterAPIFilter


class ReciterAPIFilterStructureTestCase(TestCase):
    def setUp(self):
        self.fields = ReciterAPIFilter.get_filters()

    def test_it_has_class_meta(self):
        self.assertIn('Meta', ReciterAPIFilter.__dict__)

    def test_it_has_model_in_class_meta(self):
        self.assertIn('model', ReciterAPIFilter.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_reciter_Model(self):
        self.assertEqual(Reciter, ReciterAPIFilter.Meta.model)

    def test_it_has_fields_in_class_meta(self):
        self.assertIn('fields', ReciterAPIFilter.Meta.__dict__)

    def test_it_has_q_field(self):
        self.assertIn('q', self.fields)

    def test_q_field_uses_filter_char_field(self):
        field = self.fields.get('q')
        self.assertIsInstance(field, django_filters.CharFilter)

    def test_it_has_search_method(self):
        self.assertTrue(hasattr(ReciterAPIFilter, 'search'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(ReciterAPIFilter.search))

    def test_search_method_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(ReciterAPIFilter.search)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_q_field_uses_search_method(self):
        field = self.fields.get('q')
        self.assertEqual('search', field.method)


class ReciterAPIFilterSearchTestCase(TestCase):
    def test_it_filters_queryset_by_name_column(self):
        for _ in range(5):
            ReciterFactory()
        ReciterFactory(name='te')
        queryset = Reciter.objects.all()
        result = ReciterAPIFilter().search(
            queryset=queryset,
            value="te",
            name="q"
        )
        self.assertQuerySetEqual(result, SearchProvider().search(
            queryset=queryset,
            columns=['name'],
            value="te"), ordered=False)
