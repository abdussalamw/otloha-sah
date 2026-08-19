import inspect

import django_filters
from django.test import TestCase
from django_filters import FilterSet

from apps.main.services.service_search.search import SearchProvider
from apps.narrations.factories import NarrationFactory
from apps.tajweed.factories import TajweedBookFactory, RuleFactory, CharacterFactory
from apps.tajweed.filters import (
    CharacterAdminSearch,
    CharacterAPISearch,
    CharacterFilter,
    RuleAdminSearch,
    RuleAPISearch,
    RuleFilter,
)
from apps.tajweed.models import Book, Rule, Character




class RuleFilterStructureTestCase(TestCase):
    def test_it_extends_django_Filter(self):
        self.assertTrue(issubclass(RuleFilter, FilterSet))

    def test_filter_class_has_meta_class_on_it(self):
        self.assertIn('Meta', RuleFilter.__dict__)

    def test_filter_class_meta_has_model_on_it(self):
        self.assertIn('model', RuleFilter.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Rule_model(self):
        self.assertEqual(Rule, RuleFilter.Meta.model)

    def test_filter_class_meta_has_fields_on_it(self):
        self.assertIn('fields', RuleFilter.Meta.__dict__)

    def test_filter_class_meta_fields_is_a_list(self):
        self.assertEqual(type(RuleFilter.Meta.fields), list)

    def test_class_meta_fields_has_rule_number(self):
        self.assertIn('rule_number', RuleFilter.Meta.fields)

    def test_class_meta_fields_has_tajweed_book(self):
        self.assertIn('tajweed_book', RuleFilter.Meta.fields)

    def test_class_meta_fields_has_colors(self):
        self.assertIn('color', RuleFilter.Meta.fields)


class RuleFilterTestCase(TestCase):
    def setUp(self):
        self.tajweed_book_1 = TajweedBookFactory()
        self.tajweed_book_2 = TajweedBookFactory()

    def test_it_filters_based_on_rule_number_correctly(self):
        for i in range(5):
            RuleFactory(rule_number=1, tajweed_book=self.tajweed_book_1)
        for i in range(2):
            RuleFactory(rule_number=2, tajweed_book=self.tajweed_book_1)
        result = RuleFilter({'rule_number': 1}, Rule.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual(1, result[0].rule_number)

    def test_it_filters_based_on_tajweed_book_correctly(self):
        for i in range(5):
            RuleFactory(tajweed_book=self.tajweed_book_1)
        for i in range(2):
            RuleFactory(tajweed_book=self.tajweed_book_2)
        result = RuleFilter({'tajweed_book': self.tajweed_book_1}, Rule.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual(self.tajweed_book_1, result[0].tajweed_book)

    def test_it_filters_based_on_color_correctly(self):
        for i in range(5):
            RuleFactory(color='red', tajweed_book=self.tajweed_book_1)
        for i in range(2):
            RuleFactory(color='org', tajweed_book=self.tajweed_book_2)
        result = RuleFilter({'color': 'red'}, Rule.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual('red', result[0].color)


class RuleAdminSearchStructureTestCase(TestCase):
    def setUp(self):
        self.fields = RuleAdminSearch.get_filters()

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
        self.assertTrue(hasattr(RuleAdminSearch, 'search'))

    def test_view_has_method_search_is_callable(self):
        self.assertTrue(callable(RuleAdminSearch.search))

    def test_search_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(RuleAdminSearch.search)[0]
        self.assertEqual(actual_signature, expected_signature)


class RuleAdminSearchTestCase(TestCase):
    def test_it_filters_queryset_by_name_column(self):
        for _ in range(5):
            RuleFactory(tajweed_book=TajweedBookFactory())
        RuleFactory(name='test', tajweed_book=TajweedBookFactory())
        queryset = Rule.objects.all()
        result = RuleAdminSearch({'q': "test"}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'description'],
            value="test"), ordered=False)

    def test_it_filters_queryset_by_description_column(self):
        for _ in range(5):
            RuleFactory(tajweed_book=TajweedBookFactory())
        RuleFactory(description='test', tajweed_book=TajweedBookFactory())
        queryset = Rule.objects.all()
        result = RuleAdminSearch({'q': 'test'}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'description'],
            value='test'), ordered=False)


class RuleAPISearchStructureTestCase(TestCase):
    def setUp(self):
        self.fields = RuleAPISearch.get_filters()

    # test meta
    def test_it_has_meta_class(self):
        self.assertTrue(hasattr(RuleAPISearch, 'Meta'))

    def test_model_used_in_meta_class(self):
        self.assertEqual(RuleAPISearch.Meta.model, Rule)

    def test_fields_used_in_meta_class(self):
        self.assertEqual(RuleAPISearch.Meta.fields, ['rule_number', 'tajweed_book', 'color'])

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
        self.assertTrue(hasattr(RuleAPISearch, 'search'))

    def test_view_has_method_search_is_callable(self):
        self.assertTrue(callable(RuleAPISearch.search))

    def test_search_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(RuleAPISearch.search)[0]
        self.assertEqual(actual_signature, expected_signature)


class RuleAPISearchTestCase(TestCase):
    def setUp(self):
        self.tajweed_book_1 = TajweedBookFactory()
        self.tajweed_book_2 = TajweedBookFactory()

    def test_it_filter_queryset_by_rule_number_correctly(self):
        for i in range(5):
            RuleFactory(rule_number=1, tajweed_book=self.tajweed_book_1)
        for i in range(2):
            RuleFactory(rule_number=2, tajweed_book=self.tajweed_book_1)
        queryset = Rule.objects.all()
        result = RuleAPISearch({'rule_number': 1}, queryset).qs
        self.assertEqual(5, len(result))

    def test_it_filter_queryset_by_tajweed_book_correctly(self):
        for i in range(5):
            RuleFactory(tajweed_book=self.tajweed_book_1)
        for i in range(2):
            RuleFactory(tajweed_book=self.tajweed_book_2)
        queryset = Rule.objects.all()
        result = RuleAPISearch({'tajweed_book': self.tajweed_book_1}, queryset).qs
        self.assertEqual(5, len(result))

    def test_it_filter_queryset_by_color_correctly(self):
        for i in range(5):
            RuleFactory(color='red', tajweed_book=self.tajweed_book_1)
        for i in range(2):
            RuleFactory(color='org', tajweed_book=self.tajweed_book_2)
        queryset = Rule.objects.all()
        result = RuleAPISearch({'color': 'red'}, queryset).qs
        self.assertEqual(len(result), 5)

    def test_it_filters_queryset_by_name_column(self):
        for _ in range(5):
            RuleFactory(tajweed_book=self.tajweed_book_1)
        RuleFactory(name='test', tajweed_book=self.tajweed_book_1)
        queryset = Rule.objects.all()
        result = RuleAPISearch({'q': "test"}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'description'],
            value="test"), ordered=False)

    def test_it_filters_queryset_by_description_column(self):
        for _ in range(5):
            RuleFactory(tajweed_book=self.tajweed_book_1)
        RuleFactory(description='test', tajweed_book=self.tajweed_book_1)
        queryset = Rule.objects.all()
        result = RuleAPISearch({'q': 'test'}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['name', 'description'],
            value='test'), ordered=False)


#
# class VerseFilterStructureTestCase(TestCase):
#     def test_it_extends_django_Filter(self):
#         self.assertTrue(issubclass(VerseFilter, FilterSet))
#
#     def test_filter_class_has_meta_class_on_it(self):
#         self.assertIn('Meta', VerseFilter.__dict__)
#
#     def test_filter_class_meta_has_model_on_it(self):
#         self.assertIn('model', VerseFilter.Meta.__dict__)
#
#     def test_the_model_used_in_the_meta_is_Verse_model(self):
#         self.assertEqual(Verse, VerseFilter.Meta.model)
#
#     def test_filter_class_meta_has_fields_on_it(self):
#         self.assertIn('fields', VerseFilter.Meta.__dict__)
#
#     def test_filter_class_meta_fields_is_a_list(self):
#         self.assertEqual(type(VerseFilter.Meta.fields), list)
#
#     def test_class_meta_fields_has_verse_number(self):
#         self.assertIn('verse_number', VerseFilter.Meta.fields)
#
#     def test_class_meta_fields_has_chapter_number(self):
#         self.assertIn('chapter_number', VerseFilter.Meta.fields)
#
#     def test_class_meta_fields_has_chapter(self):
#         self.assertIn('chapter', VerseFilter.Meta.fields)
#
#     def test_class_meta_fields_has_tajweed_book(self):
#         self.assertIn('tajweed_book', VerseFilter.Meta.fields)
#
#
# class VerseFilterTestCase(TestCase):
#     def setUp(self):
#         self.chapter_1 = ChapterFactory()
#         self.chapter_2 = ChapterFactory()
#         self.tajweed_book_1 = TajweedBookFactory()
#         self.tajweed_book_2 = TajweedBookFactory()
#
#     def test_it_filters_based_on_verse_number_correctly(self):
#         for i in range(5):
#             VerseFactory(verse_number=1)
#         for i in range(2):
#             VerseFactory(verse_number=2)
#         result = VerseFilter({'verse_number': 1}, Verse.objects.all()).qs
#         self.assertEqual(5, len(result))
#         self.assertEqual(1, result[0].verse_number)
#
#     def test_it_filters_based_on_chapter_number_correctly(self):
#         for i in range(5):
#             VerseFactory(chapter_number=1)
#         for i in range(2):
#             VerseFactory(chapter_number=2)
#         result = VerseFilter({'chapter_number': 1}, Verse.objects.all()).qs
#         self.assertEqual(5, len(result))
#         self.assertEqual(1, result[0].chapter_number)
#
#     def test_it_filters_based_on_chapter_correctly(self):
#         for i in range(5):
#             VerseFactory(chapter=self.chapter_1)
#         for i in range(2):
#             VerseFactory(chapter=self.chapter_2)
#         result = VerseFilter({'chapter': self.chapter_1}, Verse.objects.all()).qs
#         self.assertEqual(5, len(result))
#         self.assertEqual(self.chapter_1, result[0].chapter)
#
#     def test_it_filters_based_on_tajweed_book_correctly(self):
#         for i in range(5):
#             VerseFactory(tajweed_book=self.tajweed_book_1)
#         for i in range(2):
#             VerseFactory(tajweed_book=self.tajweed_book_2)
#         result = VerseFilter({'tajweed_book': self.tajweed_book_1}, Verse.objects.all()).qs
#         self.assertEqual(5, len(result))
#         self.assertEqual(self.tajweed_book_1, result[0].tajweed_book)
#

# class VerseAdminSearchTestCase(TestCase):
#     def test_it_filters_queryset_by_name_column(self):
#         for _ in range(5):
#             VerseFactory()
#         VerseFactory(verse_text='test')
#         queryset = Verse.objects.all()
#         result = VerseAdminSearch({'q': "test"}, queryset)
#         self.assertQuerySetEqual(result.qs, SearchProvider().search(
#             queryset=queryset,
#             columns=['verse_text'],
#             value="test"), ordered=False)


# class VerseAPISearchStructureTestCase(TestCase):
#     def setUp(self):
#         self.fields = VerseAPISearch.get_filters()
#
#     # test meta
#     def test_it_has_meta_class(self):
#         self.assertTrue(hasattr(VerseAPISearch, 'Meta'))
#
#     def test_model_used_in_meta_class(self):
#         self.assertEqual(VerseAPISearch.Meta.model, Verse)
#
#     def test_fields_used_in_meta_class(self):
#         self.assertEqual(VerseAPISearch.Meta.fields, [
#             'verse_number',
#             'chapter_number',
#             'chapter',
#             'tajweed_book'
#         ])
#
#     # Test q field
#     def test_it_has_q_field(self):
#         self.assertIn('q', self.fields)
#
#     def test_q_field_uses_filter_char_field(self):
#         field = self.fields.get('q')
#         self.assertIsInstance(field, django_filters.CharFilter)
#
#     def test_q_has_method(self):
#         field = self.fields.get('q')
#         self.assertTrue(hasattr(field, 'method'))
#
#     def test_q_method_is_search(self):
#         field = self.fields.get('q')
#         self.assertEqual(field.method, 'search')
#
#     # Test search function
#     def test_it_has_search_function(self):
#         self.assertTrue(hasattr(VerseAPISearch, 'search'))
#
#     def test_view_has_method_search_is_callable(self):
#         self.assertTrue(callable(VerseAPISearch.search))
#
#     def test_search_signature(self):
#         expected_signature = ['self', 'queryset', 'name', 'value']
#         actual_signature = inspect.getfullargspec(VerseAPISearch.search)[0]
#         self.assertEqual(actual_signature, expected_signature)

#
# class VerseAPISearchTestCase(TestCase):
#
#     def test_it_filters_based_on_verse_number_correctly(self):
#         for i in range(5):
#             VerseFactory(verse_number=1)
#         for i in range(2):
#             VerseFactory(verse_number=2)
#         result = VerseAPISearch({'verse_number': 1}, Verse.objects.all()).qs
#         self.assertEqual(5, len(result))
#
#     def test_it_filters_based_on_chapter_number_correctly(self):
#         for i in range(5):
#             VerseFactory(chapter_number=1)
#         for i in range(2):
#             VerseFactory(chapter_number=2)
#         result = VerseAPISearch({'chapter_number': 1}, Verse.objects.all()).qs
#         self.assertEqual(5, len(result))
#
#     def test_it_filters_based_on_chapter_correctly(self):
#         chapter_1 = ChapterFactory()
#         for i in range(5):
#             VerseFactory(chapter=chapter_1)
#         for i in range(2):
#             VerseFactory(chapter=ChapterFactory())
#         result = VerseAPISearch({'chapter': chapter_1}, Verse.objects.all()).qs
#         self.assertEqual(5, len(result))
#
#     def test_it_filters_based_on_tajweed_book_correctly(self):
#         tajweed_book_1 = TajweedBookFactory()
#         for i in range(5):
#             VerseFactory(tajweed_book=tajweed_book_1)
#         for i in range(2):
#             VerseFactory(tajweed_book=TajweedBookFactory())
#         result = VerseAPISearch({'tajweed_book': tajweed_book_1}, Verse.objects.all()).qs
#         self.assertEqual(5, len(result))
#
#     def test_it_filters_queryset_by_verse_text_column(self):
#         for _ in range(5):
#             VerseFactory()
#         VerseFactory(verse_text='test')
#         queryset = Verse.objects.all()
#         result = VerseAPISearch({'q': "test"}, queryset)
#         self.assertQuerySetEqual(result.qs, SearchProvider().search(
#             queryset=queryset,
#             columns=['verse_text'],
#             value="test"), ordered=False)
#

class CharacterFilterStructureTestCase(TestCase):
    def test_it_extends_django_Filter(self):
        self.assertTrue(issubclass(CharacterFilter, FilterSet))

    def test_filter_class_has_meta_class_on_it(self):
        self.assertIn('Meta', CharacterFilter.__dict__)

    def test_filter_class_meta_has_model_on_it(self):
        self.assertIn('model', CharacterFilter.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Character_model(self):
        self.assertEqual(Character, CharacterFilter.Meta.model)

    def test_filter_class_meta_has_fields_on_it(self):
        self.assertIn('fields', CharacterFilter.Meta.__dict__)

    def test_filter_class_meta_fields_is_a_list(self):
        self.assertEqual(type(CharacterFilter.Meta.fields), list)

    def test_class_meta_fields_has_character_number(self):
        self.assertIn('character_number', CharacterFilter.Meta.fields)

    def test_class_meta_fields_has_word_number(self):
        self.assertIn('word_number', CharacterFilter.Meta.fields)

    def test_class_meta_fields_has_verse_number(self):
        self.assertIn('verse_number', CharacterFilter.Meta.fields)

    def test_class_meta_fields_has_chapter_number(self):
        self.assertIn('chapter_number', CharacterFilter.Meta.fields)

    def test_class_meta_fields_has_tajweed_book(self):
        self.assertIn('tajweed_book', CharacterFilter.Meta.fields)

    def test_class_meta_fields_has_tajweed_rule(self):
        self.assertIn('tajweed_rule', CharacterFilter.Meta.fields)

    def test_class_meta_fields_has_tajweed_verse(self):
        self.assertIn('tajweed_verse', CharacterFilter.Meta.fields)


class CharacterFilterTestCase(TestCase):
    def setUp(self):
        self.tajweed_book_1 = TajweedBookFactory()
        self.tajweed_book_2 = TajweedBookFactory()
        self.tajweed_rule_1 = RuleFactory(tajweed_book=self.tajweed_book_1)
        self.tajweed_rule_2 = RuleFactory(tajweed_book=self.tajweed_book_2)
        # self.tajweed_verse_1 = VerseFactory()
        # self.tajweed_verse_2 = VerseFactory()

    def test_it_filters_based_on_character_number_correctly(self):
        for i in range(5):
            CharacterFactory(character_number=1)
        for i in range(2):
            CharacterFactory(character_number=2)
        result = CharacterFilter({'character_number': 1}, Character.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual(1, result[0].character_number)

    def test_it_filters_based_on_word_number_correctly(self):
        for i in range(5):
            CharacterFactory(word_number=1)
        for i in range(2):
            CharacterFactory(word_number=2)
        result = CharacterFilter({'word_number': 1}, Character.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual(1, result[0].word_number)

    def test_it_filters_based_on_verse_number_correctly(self):
        for i in range(5):
            CharacterFactory(verse_number=1)
        for i in range(2):
            CharacterFactory(verse_number=2)
        result = CharacterFilter({'verse_number': 1}, Character.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual(1, result[0].verse_number)

    def test_it_filters_based_on_chapter_number_correctly(self):
        for i in range(5):
            CharacterFactory(chapter_number=1, tajweed_book=self.tajweed_book_1)
        for i in range(2):
            CharacterFactory(chapter_number=2, tajweed_book=self.tajweed_book_2)
        result = CharacterFilter({'chapter_number': 1}, Character.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual(1, result[0].chapter_number)

    def test_it_filters_based_on_tajweed_book_correctly(self):
        for i in range(5):
            CharacterFactory(tajweed_book=self.tajweed_book_1)
        for i in range(2):
            CharacterFactory(tajweed_book=self.tajweed_book_2)
        result = CharacterFilter({'tajweed_book': self.tajweed_book_1}, Character.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual(self.tajweed_book_1, result[0].tajweed_book)

    def test_it_filters_based_on_tajweed_rule_correctly(self):
        for i in range(5):
            CharacterFactory(tajweed_rule=self.tajweed_rule_1)
        for i in range(2):
            CharacterFactory(tajweed_rule=self.tajweed_rule_2)
        result = CharacterFilter({'tajweed_rule': self.tajweed_rule_1}, Character.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual(self.tajweed_rule_1, result[0].tajweed_rule)

    def test_it_filters_based_on_tajweed_verse_correctly(self):
        for i in range(5):
            CharacterFactory(tajweed_verse=self.tajweed_verse_1)
        for i in range(2):
            CharacterFactory(tajweed_verse=self.tajweed_verse_2)
        result = CharacterFilter({'tajweed_verse': self.tajweed_verse_1}, Character.objects.all()).qs
        self.assertEqual(5, len(result))
        self.assertEqual(self.tajweed_verse_1, result[0].tajweed_verse)


class CharacterAdminSearchStructureTestCase(TestCase):
    def setUp(self):
        self.fields = CharacterAdminSearch.get_filters()

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
        self.assertTrue(hasattr(CharacterAdminSearch, 'search'))

    def test_view_has_method_search_is_callable(self):
        self.assertTrue(callable(CharacterAdminSearch.search))

    def test_search_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(CharacterAdminSearch.search)[0]
        self.assertEqual(actual_signature, expected_signature)


class CharacterAdminSearchTestCase(TestCase):
    def test_it_filters_queryset_by_character_text_column(self):
        for _ in range(5):
            CharacterFactory()
        CharacterFactory(character_text='test')
        queryset = Character.objects.all()
        result = CharacterAdminSearch({'q': "test"}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['character_text', 'word_text', 'rule'],
            value="test"), ordered=False)

    def test_it_filters_queryset_by_word_text_column(self):
        for _ in range(5):
            CharacterFactory()
        CharacterFactory(word_text='test')
        queryset = Character.objects.all()
        result = CharacterAdminSearch({'q': "test"}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['character_text', 'word_text', 'rule'],
            value="test"), ordered=False)

    def test_it_filters_queryset_by_rule_column(self):
        for _ in range(5):
            CharacterFactory()
        CharacterFactory(rule='test')
        queryset = Character.objects.all()
        result = CharacterAdminSearch({'q': "test"}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['character_text', 'word_text', 'rule'],
            value="test"), ordered=False)


class CharacterAPISearchStructureTestCase(TestCase):
    def setUp(self):
        self.fields = CharacterAPISearch.get_filters()

    # test meta
    def test_it_has_meta_class(self):
        self.assertTrue(hasattr(CharacterAPISearch, 'Meta'))

    def test_model_used_in_meta_class(self):
        self.assertEqual(CharacterAPISearch.Meta.model, Character)

    def test_fields_used_in_meta_class(self):
        self.assertEqual(CharacterAPISearch.Meta.fields, [
            'character_number',
            'word_number',
            'verse_number',
            'chapter_number',
            'tajweed_book',
            'tajweed_rule',
            'tajweed_verse'
        ])

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
        self.assertTrue(hasattr(CharacterAPISearch, 'search'))

    def test_view_has_method_search_is_callable(self):
        self.assertTrue(callable(CharacterAPISearch.search))

    def test_search_signature(self):
        expected_signature = ['self', 'queryset', 'name', 'value']
        actual_signature = inspect.getfullargspec(CharacterAPISearch.search)[0]
        self.assertEqual(actual_signature, expected_signature)


class CharacterAPISearchTestCase(TestCase):

    def test_it_filters_based_on_character_number_correctly(self):
        for i in range(5):
            CharacterFactory(character_number=1)
        for i in range(2):
            CharacterFactory(character_number=2)
        result = CharacterAPISearch({'character_number': 1}, Character.objects.all()).qs
        self.assertEqual(5, len(result))

    def test_it_filters_based_on_word_number_correctly(self):
        for i in range(5):
            CharacterFactory(word_number=1)
        for i in range(2):
            CharacterFactory(word_number=2)
        result = CharacterAPISearch({'word_number': 1}, Character.objects.all()).qs
        self.assertEqual(5, len(result))

    def test_it_filters_based_on_verse_number_correctly(self):
        for i in range(5):
            CharacterFactory(verse_number=1)
        for i in range(2):
            CharacterFactory(verse_number=2)
        result = CharacterAPISearch({'verse_number': 1}, Character.objects.all()).qs
        self.assertEqual(5, len(result))

    def test_it_filters_based_on_chapter_number_correctly(self):
        for i in range(5):
            CharacterFactory(chapter_number=1, tajweed_book=TajweedBookFactory())
        for i in range(2):
            CharacterFactory(chapter_number=2, tajweed_book=TajweedBookFactory())
        result = CharacterAPISearch({'chapter_number': 1}, Character.objects.all()).qs
        self.assertEqual(5, len(result))

    def test_it_filters_based_on_tajweed_book_correctly(self):
        tajweed_book_1 = TajweedBookFactory()
        for i in range(5):
            CharacterFactory(tajweed_book=tajweed_book_1)
        for i in range(2):
            CharacterFactory(tajweed_book=TajweedBookFactory())
        result = CharacterAPISearch({'tajweed_book': tajweed_book_1}, Character.objects.all()).qs
        self.assertEqual(5, len(result))

    def test_it_filters_based_on_tajweed_rule_correctly(self):
        tajweed_rule_1 = RuleFactory(tajweed_book=TajweedBookFactory())
        for i in range(5):
            CharacterFactory(tajweed_rule=tajweed_rule_1)
        for i in range(2):
            CharacterFactory(tajweed_rule=RuleFactory(tajweed_book=TajweedBookFactory()))
        result = CharacterAPISearch({'tajweed_rule': tajweed_rule_1}, Character.objects.all()).qs
        self.assertEqual(5, len(result))

    # def test_it_filters_based_on_tajweed_verse_correctly(self):
    #     tajweed_verse_1 = VerseFactory()
    #     for i in range(5):
    #         CharacterFactory(tajweed_verse=tajweed_verse_1)
    #     for i in range(2):
    #         CharacterFactory(tajweed_verse=VerseFactory())
    #     result = CharacterAPISearch({'tajweed_verse': tajweed_verse_1}, Character.objects.all()).qs
    #     self.assertEqual(5, len(result))

    def test_it_filters_queryset_by_character_text_column(self):
        for _ in range(5):
            CharacterFactory()
        CharacterFactory(character_text='test')
        queryset = Character.objects.all()
        result = CharacterAPISearch({'q': "test"}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['character_text', 'word_text', 'rule'],
            value="test"), ordered=False)

    def test_it_filters_queryset_by_word_text_column(self):
        for _ in range(5):
            CharacterFactory()
        CharacterFactory(word_text='test')
        queryset = Character.objects.all()
        result = CharacterAPISearch({'q': "test"}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['character_text', 'word_text', 'rule'],
            value="test"), ordered=False)

    def test_it_filters_queryset_by_rule_column(self):
        for _ in range(5):
            CharacterFactory()
        CharacterFactory(rule='test')
        queryset = Character.objects.all()
        result = CharacterAPISearch({'q': "test"}, queryset)
        self.assertQuerySetEqual(result.qs, SearchProvider().search(
            queryset=queryset,
            columns=['character_text', 'word_text', 'rule'],
            value="test"), ordered=False)
