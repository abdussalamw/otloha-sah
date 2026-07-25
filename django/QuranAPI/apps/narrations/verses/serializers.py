from rest_framework import serializers

from apps.narrations.models import Verse, Word


class WordSerializer(serializers.ModelSerializer):
    class Meta:
        model = Word
        fields = ('id', 'text', 'narration', 'chapter_number', 'verse_number', 'number', 'verse', 'position_in_line',
                  'line_number', 'page_number')


class BaseVerseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Verse
        fields = (
            'id',
            'uuid',
            'text',
            'verse_number',
            'page_number',
            'chapter_number',
            'part_number',
            'part',
            'chapter',
            'narration',
        )


class VerseSerializer(BaseVerseSerializer):
    image = serializers.ImageField(use_url=True, required=False)
    words = WordSerializer(many=True, read_only=True, source='verse_words')

    class Meta(BaseVerseSerializer.Meta):
        fields = BaseVerseSerializer.Meta.fields + (
            'line_start',
            'line_end',
            'image',
            'words'
        )


class VerseSearchSerializer(BaseVerseSerializer):
    result_type = serializers.SerializerMethodField()

    class Meta(BaseVerseSerializer.Meta):
        fields = BaseVerseSerializer.Meta.fields + ("result_type",)

    def get_result_type(self, obj):
        return 'verse'
