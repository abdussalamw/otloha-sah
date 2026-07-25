from django.test import TestCase
from rest_framework.serializers import ModelSerializer
from translation.serializers import TranslatableModelSerializer

from apps.chapters.factories import ChapterFactory
from apps.narrations.factories import NarrationFactory
from apps.tajweed.factories import TajweedBookFactory, VerseFactory, RuleFactory, CharacterFactory
from apps.tajweed.models import Book, Rule, Verse, Character
from apps.tajweed.serializers import BookSerializer, RuleSerializer, VerseSerializer, CharacterSerializer


class BookSerializerStructureTestCase(TestCase):
    def test_it_extends_django_Serializer(self):
        self.assertTrue(issubclass(BookSerializer, TranslatableModelSerializer))

    def test_serializer_class_has_meta_class_on_it(self):
        self.assertIn('Meta', BookSerializer.__dict__)

    def test_serializer_class_meta_has_model_on_it(self):
        self.assertIn('model', BookSerializer.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Book_model(self):
        self.assertEquals(Book, BookSerializer.Meta.model)

    def test_serializer_class_meta_has_fields_on_it(self):
        self.assertIn('fields', BookSerializer.Meta.__dict__)

    def test_serializer_class_meta_fields_is_a_list(self):
        self.assertEquals(type(BookSerializer.Meta.fields), list)

    def test_class_meta_fields_has_id(self):
        self.assertIn('id', BookSerializer.Meta.fields)

    def test_class_meta_fields_has_name(self):
        self.assertIn('name', BookSerializer.Meta.fields)

    def test_class_meta_fields_has_narration(self):
        self.assertIn('narrations', BookSerializer.Meta.fields)

    def test_class_meta_fields_has_author(self):
        self.assertIn('author', BookSerializer.Meta.fields)


class BookSerializerResponseTestCase(TestCase):
    def setUp(self):
        self.book = TajweedBookFactory(narration=NarrationFactory())
        self.serializer = BookSerializer(instance=self.book)

    def test_it_returns_expected_fields(self):
        data = self.serializer.data
        self.assertEquals(set(data.keys()), {'id', 'name', 'narrations', 'author'})

    def test_id_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['id'], self.book.pk)

    def test_name_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['name'], self.book.translated_name)

    def test_narration_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['narrations'], self.book.narration.pk)

    def test_author_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['author'], self.book.translated_author)


class RuleSerializerStructureTestCase(TestCase):
    def test_it_extends_django_Serializer(self):
        self.assertTrue(issubclass(RuleSerializer, TranslatableModelSerializer))

    def test_serializer_class_has_meta_class_on_it(self):
        self.assertIn('Meta', RuleSerializer.__dict__)

    def test_serializer_class_meta_has_model_on_it(self):
        self.assertIn('model', RuleSerializer.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Rule_model(self):
        self.assertEquals(Rule, RuleSerializer.Meta.model)

    def test_serializer_class_meta_has_fields_on_it(self):
        self.assertIn('fields', RuleSerializer.Meta.__dict__)

    def test_serializer_class_meta_fields_is_a_list(self):
        self.assertEquals(type(RuleSerializer.Meta.fields), list)

    def test_class_meta_fields_has_id(self):
        self.assertIn('id', RuleSerializer.Meta.fields)

    def test_class_meta_fields_has_rule_number(self):
        self.assertIn('rule_number', RuleSerializer.Meta.fields)

    def test_class_meta_fields_has_name(self):
        self.assertIn('name', RuleSerializer.Meta.fields)

    def test_class_meta_fields_has_description(self):
        self.assertIn('description', RuleSerializer.Meta.fields)

    def test_class_meta_fields_has_tajweed_book(self):
        self.assertIn('tajweed_book', RuleSerializer.Meta.fields)

    def test_class_meta_fields_has_colors(self):
        self.assertIn('color', RuleSerializer.Meta.fields)


class RuleSerializerResponseTestCase(TestCase):
    def setUp(self):
        self.rule = RuleFactory(
            tajweed_book=TajweedBookFactory(),
            description={'ar': 'make the character hidden'}
        )
        self.serializer = RuleSerializer(instance=self.rule)

    def test_it_returns_expected_fields(self):
        data = self.serializer.data
        self.assertEquals(set(data.keys()), {
            'id', 'rule_number',
            'name',
            'description',
            'tajweed_book',
            'color'
        })

    def test_id_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['id'], self.rule.pk)

    def test_rule_number_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['rule_number'], self.rule.rule_number)

    def test_name_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['name'], self.rule.translated_name)

    def test_description_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['description'], self.rule.translated_description)

    def test_tajweed_book_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['tajweed_book'], self.rule.tajweed_book.pk)

    def test_color_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['color'], self.rule.color)


class VerseSerializerStructureTestCase(TestCase):
    def test_it_extends_django_Serializer(self):
        self.assertTrue(issubclass(VerseSerializer, ModelSerializer))

    def test_serializer_class_has_meta_class_on_it(self):
        self.assertIn('Meta', VerseSerializer.__dict__)

    def test_serializer_class_meta_has_model_on_it(self):
        self.assertIn('model', VerseSerializer.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Verse_model(self):
        self.assertEquals(Verse, VerseSerializer.Meta.model)

    def test_serializer_class_meta_has_fields_on_it(self):
        self.assertIn('fields', VerseSerializer.Meta.__dict__)

    def test_serializer_class_meta_fields_is_a_list(self):
        self.assertEquals(type(VerseSerializer.Meta.fields), list)

    def test_class_meta_fields_has_id(self):
        self.assertIn('id', VerseSerializer.Meta.fields)

    def test_class_meta_fields_has_verse_text(self):
        self.assertIn('verse_text', VerseSerializer.Meta.fields)

    def test_class_meta_fields_has_verse_number(self):
        self.assertIn('verse_number', VerseSerializer.Meta.fields)

    def test_class_meta_fields_has_chapter(self):
        self.assertIn('chapter', VerseSerializer.Meta.fields)

    def test_class_meta_fields_has_chapter_number(self):
        self.assertIn('chapter_number', VerseSerializer.Meta.fields)

    def test_class_meta_fields_has_tajweed_book(self):
        self.assertIn('tajweed_book', VerseSerializer.Meta.fields)


class VerseSerializerResponseTestCase(TestCase):
    def setUp(self):
        self.verse = VerseFactory(
            chapter=ChapterFactory(),
            tajweed_book=TajweedBookFactory()
        )
        for _ in range(5):
            CharacterFactory(tajweed_verse=self.verse)
        self.serializer = VerseSerializer(instance=self.verse)

    def test_it_returns_expected_fields(self):
        data = self.serializer.data
        self.assertEquals(set(data.keys()), {
            'id', 'verse_text',
            'verse_number',
            'chapter_number',
            'chapter',
            'tajweed_book',
            'characters'
        })

    def test_id_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['id'], self.verse.pk)

    def test_verse_number_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['verse_number'], self.verse.verse_number)

    def test_chapter_number_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['chapter_number'], self.verse.chapter_number)

    def test_chapter_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['chapter'], self.verse.chapter.pk)

    def test_tajweed_book_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['tajweed_book'], self.verse.tajweed_book.pk)

    def test_characters_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['characters'],
                          CharacterSerializer(instance=self.verse.character_set.all(), many=True).data)


class CharacterSerializerStructureTestCase(TestCase):
    def test_it_extends_django_Serializer(self):
        self.assertTrue(issubclass(CharacterSerializer, ModelSerializer))

    def test_serializer_class_has_meta_class_on_it(self):
        self.assertIn('Meta', CharacterSerializer.__dict__)

    def test_serializer_class_meta_has_model_on_it(self):
        self.assertIn('model', CharacterSerializer.Meta.__dict__)

    def test_the_model_used_in_the_meta_is_Character_model(self):
        self.assertEquals(Character, CharacterSerializer.Meta.model)

    def test_serializer_class_meta_has_fields_on_it(self):
        self.assertIn('fields', CharacterSerializer.Meta.__dict__)

    def test_serializer_class_meta_fields_is_a_list(self):
        self.assertEquals(type(CharacterSerializer.Meta.fields), list)

    def test_class_meta_fields_has_id(self):
        self.assertIn('id', CharacterSerializer.Meta.fields)

    def test_class_meta_fields_has_character_text(self):
        self.assertIn('character_text', CharacterSerializer.Meta.fields)

    def test_class_meta_fields_has_character_number(self):
        self.assertIn('character_number', CharacterSerializer.Meta.fields)

    def test_class_meta_fields_has_word_text(self):
        self.assertIn('word_text', CharacterSerializer.Meta.fields)

    def test_class_meta_fields_has_word_number(self):
        self.assertIn('word_number', CharacterSerializer.Meta.fields)

    def test_class_meta_fields_has_rule(self):
        self.assertIn('rule', CharacterSerializer.Meta.fields)

    def test_class_meta_fields_has_verse_number(self):
        self.assertIn('verse_number', CharacterSerializer.Meta.fields)

    def test_class_meta_fields_has_chapter_number(self):
        self.assertIn('chapter_number', CharacterSerializer.Meta.fields)

    def test_class_meta_fields_has_tajweed_book(self):
        self.assertIn('tajweed_book', CharacterSerializer.Meta.fields)

    def test_class_meta_fields_has_tajweed_rule(self):
        self.assertIn('tajweed_rule', CharacterSerializer.Meta.fields)

    def test_class_meta_fields_has_tajweed_verse(self):
        self.assertIn('tajweed_verse', CharacterSerializer.Meta.fields)

    def test_it_get_serialized_data_correctly(self):
        data = {
            'character_text': 'b',
            'character_number': 1,
            'word_text': 'bsm ellah',
            'word_number': 3,
            'rule': 1,
            'verse_number': 3,
            'chapter_number': 5,
            'tajweed_book': TajweedBookFactory().pk,
            'tajweed_rule': RuleFactory(tajweed_book=TajweedBookFactory()).pk,
            'tajweed_verse': VerseFactory().pk,
        }
        serializer = CharacterSerializer(data=data)
        self.assertTrue(serializer.is_valid())
        self.assertEquals(data, serializer.initial_data)


class CharacterSerializerResponseTestCase(TestCase):
    def setUp(self):
        self.book = TajweedBookFactory(narration=NarrationFactory())
        self.character = CharacterFactory(
            tajweed_book=self.book,
            tajweed_rule=RuleFactory(tajweed_book=self.book),
            tajweed_verse=VerseFactory(chapter=ChapterFactory(),
                                       tajweed_book=self.book
                                       )
        )
        self.serializer = CharacterSerializer(instance=self.character)

    def test_it_returns_expected_fields(self):
        data = self.serializer.data
        self.assertEquals(set(data.keys()), {
            'id',
            'character_text',
            'character_number',
            'word_text',
            'word_number',
            'rule',
            'verse_number',
            'chapter_number',
            'tajweed_book',
            'tajweed_rule',
            'tajweed_verse',
        })

    def test_id_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['id'], self.character.pk)

    def test_character_text_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['character_text'], self.character.character_text)

    def test_word_text_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['word_text'], self.character.word_text)

    def test_rule_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['rule'], self.character.rule)

    def test_character_number_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['character_number'], self.character.character_number)

    def test_word_number_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['word_number'], self.character.word_number)

    def test_verse_number_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['verse_number'], self.character.verse_number)

    def test_chapter_number_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['chapter_number'], self.character.chapter_number)

    def test_tajweed_book_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['tajweed_book'], self.character.tajweed_book.pk)

    def test_tajweed_rule_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['tajweed_rule'], self.character.tajweed_rule.pk)

    def test_tajweed_verse_has_correct_value(self):
        data = self.serializer.data
        self.assertEquals(data['tajweed_verse'], self.character.tajweed_verse.pk)
