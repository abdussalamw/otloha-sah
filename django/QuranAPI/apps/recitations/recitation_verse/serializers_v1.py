from rest_framework.serializers import ModelSerializer

from apps.recitations.models import RecitationVerse


class RecitationVerseSerializer(ModelSerializer):
    class Meta:
        model = RecitationVerse
        fields = ['id', 'recitation', 'record', 'verse_number', 'chapter']
