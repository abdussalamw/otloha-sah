from django.test import TestCase
from django_filters import FilterSet

from apps.chapters.factories import ChapterFactory
from apps.narrations.factories import NarrationFactory
from apps.translations.factories import TranslationFactory, TranslationVerseFactory
from apps.translations.filters import TranslationFilter, TranslationVerseFilter
from apps.translations.models import Translation, TranslationVerse


class TranslationFilterStructureTestCase(TestCase):
    def test_it_extends_django_Filter(self):
        self.assertTrue(issubclass(TranslationFilter, FilterSet))

    def test_filter_class_has_meta_class_on_it(self):
        self.assertIn('Meta', TranslationFilter.__dict__)

    def test_filter_class_meta_has_model_on_it(self):
        self.assertIn('model', TranslationFilter.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Translation_model(self):
        self.assertEquals(Translation, TranslationFilter.Meta.model)

    def test_filter_class_meta_has_fields_on_it(self):
        self.assertIn('fields', TranslationFilter.Meta.__dict__)

    def test_filter_class_meta_fields_is_a_list(self):
        self.assertEquals(type(TranslationFilter.Meta.fields), list)

    def test_class_meta_fields_has_language(self):
        self.assertIn('language', TranslationFilter.Meta.fields)

    def test_class_meta_fields_has_narration(self):
        self.assertIn('narration', TranslationFilter.Meta.fields)


class TranslationFilterTestCase(TestCase):
    def test_it_filters_based_on_language_correctly(self):
        for i in range(5):
            TranslationFactory(language='en')
        for i in range(2):
            TranslationFactory(language='ar')
        result = TranslationFilter({'language': 'en'}, Translation.objects.all()).qs
        self.assertEquals(5, len(result))
        self.assertEquals('en', result[0].language)


class TranslationVerseFilterStructureTestCase(TestCase):
    def test_it_extends_django_Filter(self):
        self.assertTrue(issubclass(TranslationVerseFilter, FilterSet))

    def test_filter_class_has_meta_class_on_it(self):
        self.assertIn('Meta', TranslationVerseFilter.__dict__)

    def test_filter_class_meta_has_model_on_it(self):
        self.assertIn('model', TranslationVerseFilter.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_TranslationVerse_model(self):
        self.assertEquals(TranslationVerse, TranslationVerseFilter.Meta.model)

    def test_filter_class_meta_has_fields_on_it(self):
        self.assertIn('fields', TranslationVerseFilter.Meta.__dict__)

    def test_filter_class_meta_fields_is_a_list(self):
        self.assertEquals(type(TranslationVerseFilter.Meta.fields), list)

    def test_class_meta_fields_has_translation(self):
        self.assertIn('translation', TranslationVerseFilter.Meta.fields)

    def test_class_meta_fields_has_chapter(self):
        self.assertIn('chapter', TranslationVerseFilter.Meta.fields)

    def test_class_meta_fields_has_chapter_number(self):
        self.assertIn('chapter_number', TranslationVerseFilter.Meta.fields)

    def test_class_meta_fields_has_verse_number(self):
        self.assertIn('verse_number', TranslationVerseFilter.Meta.fields)


class TranslationVerseFilterTestCase(TestCase):
    def setUp(self):

        self.narration_1 = NarrationFactory()
        self.narration_2 = NarrationFactory()
        self.translation_1 = TranslationFactory(narration=self.narration_1)
        self.translation_2 = TranslationFactory(narration=self.narration_2)
        self.chapter_1 = ChapterFactory()
        self.chapter_2 = ChapterFactory()

    def test_it_filters_based_on_translation_correctly(self):
        for i in range(5):
            TranslationVerseFactory(translation=self.translation_1)
        for i in range(2):
            TranslationVerseFactory(translation=self.translation_2)
        result = TranslationVerseFilter({'translation': self.translation_1}, TranslationVerse.objects.all()).qs
        self.assertEquals(5, len(result))
        self.assertEquals(self.translation_1, result[0].translation)

    def test_it_filters_based_on_chapter_correctly(self):
        for i in range(5):
            TranslationVerseFactory(chapter=self.chapter_1, translation=self.translation_1)
        for i in range(2):
            TranslationVerseFactory(chapter=self.chapter_2, translation=self.translation_1)
        result = TranslationVerseFilter({'chapter': self.chapter_1}, TranslationVerse.objects.all()).qs
        self.assertEquals(5, len(result))
        self.assertEquals(self.chapter_1, result[0].chapter)

    def test_it_filters_based_on_chapter_number_correctly(self):
        for i in range(5):
            TranslationVerseFactory(chapter_number=1, translation=self.translation_1)
        for i in range(2):
            TranslationVerseFactory(chapter_number=2, translation=self.translation_1)
        result = TranslationVerseFilter({'chapter_number': 1}, TranslationVerse.objects.all()).qs
        self.assertEquals(5, len(result))
        self.assertEquals(1, result[0].chapter_number)

    def test_it_filters_based_on_verse_number_correctly(self):
        for i in range(5):
            TranslationVerseFactory(verse_number=1, translation=self.translation_1)
        for i in range(2):
            TranslationVerseFactory(verse_number=2, translation=self.translation_1)
        result = TranslationVerseFilter({'verse_number': 1}, TranslationVerse.objects.all()).qs
        self.assertEquals(5, len(result))
        self.assertEquals(1, result[0].verse_number)
