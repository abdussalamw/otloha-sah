from django.test import TestCase
from rest_framework.serializers import ModelSerializer
from translation.serializers import TranslatableModelSerializer

from apps.narrations.factories import NarrationFactory
from apps.tajweed.factories import CharacterFactory, RuleFactory, TajweedBookFactory
from apps.tajweed.models import Book, Character, Rule
from apps.tajweed.serializers import BookSerializer, CharacterSerializer, RuleSerializer


class BookSerializerTestCase(TestCase):
    def test_uses_the_current_book_model_and_fields(self):
        self.assertTrue(issubclass(BookSerializer, TranslatableModelSerializer))
        self.assertEqual(Book, BookSerializer.Meta.model)
        self.assertEqual(['id', 'name', 'narration', 'author'], BookSerializer.Meta.fields)

    def test_serializes_the_book_narration(self):
        book = TajweedBookFactory(narration=NarrationFactory())
        data = BookSerializer(instance=book).data

        self.assertEqual({'id', 'name', 'narration', 'author'}, set(data))
        self.assertEqual(book.pk, data['id'])
        self.assertEqual(book.narration_id, data['narration'])


class RuleSerializerTestCase(TestCase):
    def test_uses_the_current_rule_model_and_fields(self):
        self.assertTrue(issubclass(RuleSerializer, TranslatableModelSerializer))
        self.assertEqual(Rule, RuleSerializer.Meta.model)
        self.assertEqual(
            ['id', 'rule_number', 'name', 'description', 'tajweed_book', 'color'],
            RuleSerializer.Meta.fields,
        )

    def test_serializes_the_rule_book_and_color(self):
        rule = RuleFactory(tajweed_book=TajweedBookFactory())
        data = RuleSerializer(instance=rule).data

        self.assertEqual(rule.pk, data['id'])
        self.assertEqual(rule.tajweed_book_id, data['tajweed_book'])
        self.assertEqual(rule.color, data['color'])


class CharacterSerializerTestCase(TestCase):
    def test_uses_the_current_character_model_and_fields(self):
        self.assertTrue(issubclass(CharacterSerializer, ModelSerializer))
        self.assertEqual(Character, CharacterSerializer.Meta.model)
        self.assertEqual(
            [
                'id',
                'character_text',
                'rule_text',
                'word_text',
                'character_number',
                'word_number',
                'verse_number',
                'chapter_number',
                'word',
                'verse',
                'chapter',
                'book',
                'rule',
            ],
            CharacterSerializer.Meta.fields,
        )

    def test_serializes_current_character_fields(self):
        character = CharacterFactory()
        data = CharacterSerializer(instance=character).data

        self.assertEqual(character.pk, data['id'])
        self.assertEqual(character.character_text, data['character_text'])
        self.assertEqual(character.rule_text, data['rule_text'])
        self.assertEqual(character.book_id, data['book'])
        self.assertEqual(character.rule_id, data['rule'])
