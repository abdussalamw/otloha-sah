from translation.serializers import TranslatableModelSerializer

from apps.explanations.models import Explanation, ExplanationVerse


class ExplanationSerializer(TranslatableModelSerializer):
    class Meta:
        model = Explanation
        fields = ['id', 'name', 'narration']


class ExplanationVerseSerializer(TranslatableModelSerializer):
    class Meta:
        model = ExplanationVerse
        fields = [
            'id', 'explanation', 'text', 'verse_number', 'chapter_number', 'page_number', 'verse', 'chapter']
