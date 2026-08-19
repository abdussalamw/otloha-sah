from rest_framework.serializers import ModelSerializer
from translation.serializers import TranslatableModelSerializer

from apps.tajweed.models import Book, Rule, Character


class BookSerializer(TranslatableModelSerializer):
    class Meta:
        model = Book
        fields = [
            'id',
            'name',
            'narration',
            'author'
        ]


class RuleSerializer(TranslatableModelSerializer):
    class Meta:
        model = Rule
        fields = [
            'id',
            'rule_number',
            'name',
            'description',
            'tajweed_book',
            'color'
        ]


# class VerseSerializer(ModelSerializer):
#     characters = serializers.SerializerMethodField()
#
#     class Meta:
#         model = Verse
#         fields = [
#             'id',
#             'verse_text',
#             'verse_number',
#             'chapter_number',
#             'chapter',
#             'tajweed_book',
#             'characters',
#         ]
#
#     def get_characters(self, obj):
#         return CharacterSerializer(instance=obj.character_set.all(), many=True).data


class CharacterSerializer(ModelSerializer):
    class Meta:
        model = Character
        fields = [
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
        ]


