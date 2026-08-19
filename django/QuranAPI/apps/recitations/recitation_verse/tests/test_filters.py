import django_filters
from django.test import TestCase

from apps.chapters.models import Chapter
from apps.recitations.models import RecitationVerse, Recitation
from apps.recitations.recitation_verse.filters import RecitationVerseFilter


class RecitationVerseFilterStructureTestCase(TestCase):
    def setUp(self):
        self.fields = RecitationVerseFilter.get_filters()

    def test_it_has_class_meta(self):
        self.assertIn('Meta', RecitationVerseFilter.__dict__)

    def test_it_has_model_in_class_meta(self):
        self.assertIn('model', RecitationVerseFilter.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_reciter_Model(self):
        self.assertEqual(RecitationVerse, RecitationVerseFilter.Meta.model)

    def test_it_has_fields_in_class_meta(self):
        self.assertIn('fields', RecitationVerseFilter.Meta.__dict__)

    def test_it_has_chapter_field(self):
        self.assertIn('chapter', self.fields)

    def test_it_has_recitation_field(self):
        self.assertIn('recitation', self.fields)

    def test_it_has_verse_number_field(self):
        self.assertIn('verse_number', self.fields)

    def test_chapter_is_instance_of_model_choice_filter(self):
        field = RecitationVerseFilter.get_filters()['chapter']
        self.assertIsInstance(field, django_filters.filters.ModelChoiceFilter)

    def test_chapter_query_set_is_all_chapter(self):
        field = RecitationVerseFilter.get_filters()['chapter']
        self.assertQuerySetEqual(field.queryset, Chapter.objects.all())

    def test_recitation_is_instance_of_model_choice_filter(self):
        field = RecitationVerseFilter.get_filters()['recitation']
        self.assertIsInstance(field, django_filters.filters.ModelChoiceFilter)

    def test_recitation_query_set_is_all_recitation(self):
        field = RecitationVerseFilter.get_filters()['recitation']
        self.assertQuerySetEqual(field.queryset, Recitation.objects.all())