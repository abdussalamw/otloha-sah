import django_filters
from django.test import TestCase

from apps.narrations.models import Narration
from apps.recitations.filters import RecitationFilter
from apps.recitations.models import Recitation


class RecitationFilterStructureTestCase(TestCase):

    def test_it_has_class_meta(self):
        self.assertIn('Meta', RecitationFilter.__dict__)

    def test_it_has_model_in_class_meta(self):
        self.assertIn('model', RecitationFilter.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_recitation_Model(self):
        self.assertEqual(Recitation, RecitationFilter.Meta.model)

    def test_it_has_fields_in_class_meta(self):
        self.assertIn('fields', RecitationFilter.Meta.__dict__)

    def test_it_has_narration_field(self):
        self.assertIn('narration', RecitationFilter.Meta.fields)

    def test_it_has_reciter_field(self):
        self.assertIn('reciter', RecitationFilter.Meta.fields)

    def test_narration_is_instance_of_model_choice_filter(self):
        field = RecitationFilter.get_filters()['narration']
        self.assertIsInstance(field, django_filters.filters.ModelChoiceFilter)

    def test_narration_query_set_is_all_narration(self):
        field = RecitationFilter.get_filters()['narration']
        self.assertQuerySetEqual(field.queryset, Narration.objects.all())

    def test_reciter_is_instance_of_model_choice_filter(self):
        field = RecitationFilter.get_filters()['reciter']
        self.assertIsInstance(field, django_filters.filters.ModelChoiceFilter)

    def test_reciter_query_set_is_all_reciter(self):
        field = RecitationFilter.get_filters()['reciter']
        self.assertQuerySetEqual(field.queryset, Narration.objects.all())
