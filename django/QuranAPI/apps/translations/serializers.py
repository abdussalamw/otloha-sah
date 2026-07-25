from rest_framework import serializers
from translation.serializers import TranslatableModelSerializer

from apps.translations.models import Translation, TranslationVerse


class TranslationSerializer(TranslatableModelSerializer):
    class Meta:
        model = Translation
        fields = ['name', 'language', 'author', 'narration', ]


class TranslationVerseSerializer(serializers.ModelSerializer):
    class Meta:
        model = TranslationVerse
        fields = ['text', 'translation', 'chapter', 'chapter_number', 'verse_number']
