from rest_framework import serializers

from apps.narrations.models import Verse, Word


class WordSerializer(serializers.ModelSerializer):
    class Meta:
        model = Word
        fields = ('id', 'text', 'narration', 'chapter_number', 'verse_number', 'number', 'verse', 'position_in_line',
                  'line_number', 'page_number')
