from rest_framework import serializers

from apps.tajweed.models import Character


class CharacterSerializer(serializers.ModelSerializer):
    class Meta:
        model = Character
        fields = (
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
        )
