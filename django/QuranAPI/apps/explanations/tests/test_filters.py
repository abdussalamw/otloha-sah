import inspect

import django_filters
from django.test import TestCase
from django_filters import FilterSet

from apps.explanations.factories import ExplanationFactory
from apps.explanations.filters import ExplanationAPIFilter, ExplanationAdminFilter, ExplanationAdminSearch
from apps.explanations.models import Explanation
from apps.narrations.factories import NarrationFactory


class ExplanationAPIFilterStructureTestCase(TestCase):
    def setUp(self):
        self.fields = ExplanationAPIFilter.get_filters()

    def test_it_extends_django_Filter(self):
        self.assertTrue(issubclass(ExplanationAPIFilter, FilterSet))

    def test_filter_class_has_meta_class_on_it(self):
        self.assertIn('Meta', ExplanationAPIFilter.__dict__)

    def test_filter_class_meta_has_model_on_it(self):
        self.assertIn('model', ExplanationAPIFilter.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Explanation_model(self):
        self.assertEqual(Explanation, ExplanationAPIFilter.Meta.model)

    def test_filter_class_meta_has_fields_on_it(self):
        self.assertIn('fields', ExplanationAPIFilter.Meta.__dict__)

    def test_filter_class_meta_fields_is_a_list(self):
        self.assertEqual(type(ExplanationAPIFilter.Meta.fields), list)

    def test_class_meta_fields_has_narration(self):
        self.assertIn('narration', ExplanationAPIFilter.Meta.fields)

    def test_it_has_q_field(self):
        self.assertIn('q', self.fields)

    def test_q_field_uses_filter_char_field(self):
        field = self.fields.get('q')
        self.assertIsInstance(field, django_filters.CharFilter)

    def test_it_has_search_method(self):
        self.assertTrue(hasattr(ExplanationAPIFilter, 'search'))

    def test_search_method_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(ExplanationAPIFilter.search)[0]
        self.assertEqual(actual_signature, expected_signature)


class ExplanationAPIFilterTestCase(TestCase):
    def setUp(self):
        self.narration_1 = NarrationFactory()
        self.narration_2 = NarrationFactory()

    def test_it_filters_based_on_narration_correctly(self):
        for i in range(5):
            ExplanationFactory(narration=self.narration_1)
        for i in range(2):
            ExplanationFactory(narration=self.narration_2)
        result = ExplanationAPIFilter({'narration': self.narration_1}, Explanation.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual(self.narration_1, result[0].narration)

    def test_it_filters_based_on_q_correctly(self):
        for i in range(5):
            ExplanationFactory(name="ahmed")
        for i in range(2):
            ExplanationFactory(name='khalid')
        result = ExplanationAPIFilter({'q': 'med'}, Explanation.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual('ahmed', result[0].name)


class ExplanationAdminFilterStructureTestCase(TestCase):

    def test_it_extends_django_Filter(self):
        self.assertTrue(issubclass(ExplanationAPIFilter, FilterSet))

    def test_filter_class_has_meta_class_on_it(self):
        self.assertIn('Meta', ExplanationAdminFilter.__dict__)

    def test_filter_class_meta_has_model_on_it(self):
        self.assertIn('model', ExplanationAdminFilter.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Explanation_model(self):
        self.assertEqual(Explanation, ExplanationAdminFilter.Meta.model)

    def test_filter_class_meta_has_fields_on_it(self):
        self.assertIn('fields', ExplanationAdminFilter.Meta.__dict__)

    def test_filter_class_meta_fields_is_a_list(self):
        self.assertEqual(type(ExplanationAdminFilter.Meta.fields), list)

    def test_class_meta_fields_has_narration(self):
        self.assertIn('narration', ExplanationAdminFilter.Meta.fields)


class ExplanationAdminFilterTestCase(TestCase):
    def setUp(self):
        self.narration_1 = NarrationFactory()
        self.narration_2 = NarrationFactory()

    def test_it_filters_based_on_narration_correctly(self):
        for i in range(5):
            ExplanationFactory(narration=self.narration_1)
        for i in range(2):
            ExplanationFactory(narration=self.narration_2)
        result = ExplanationAdminFilter({'narration': self.narration_1}, Explanation.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual(self.narration_1, result[0].narration)


class ExplanationAdminSearchStructureTestCase(TestCase):
    def setUp(self):
        self.fields = ExplanationAdminSearch.get_filters()

    def test_it_has_q_field(self):
        self.assertIn('q', self.fields)

    def test_q_field_uses_filter_char_field(self):
        field = self.fields.get('q')
        self.assertIsInstance(field, django_filters.CharFilter)

    def test_it_has_search_method(self):
        self.assertTrue(hasattr(ExplanationAdminSearch, 'search'))

    def test_search_method_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(ExplanationAdminSearch.search)[0]
        self.assertEqual(actual_signature, expected_signature)


class ExplanationAdminSearchTestCase(TestCase):

    def test_it_filters_based_on_q_correctly(self):
        for i in range(5):
            ExplanationFactory(name="ahmed")
        for i in range(2):
            ExplanationFactory(name='khalid')
        result = ExplanationAdminSearch({'q': 'med'}, Explanation.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual('ahmed', result[0].name)

