from rest_framework import serializers
from translation.serializers import TranslatableModelSerializer

from apps.chapters.models import Chapter


class BaseChapterSerializer(TranslatableModelSerializer):
    class Meta:
        model = Chapter
        fields = ('id', 'name', 'chapter_number', 'origin', 'chapter_metadata')


class ChapterSerializer(BaseChapterSerializer):
    class Meta(BaseChapterSerializer.Meta):
        fields = BaseChapterSerializer.Meta.fields + ("chapter_metadata",)


class ChapterSearchSerializer(BaseChapterSerializer):
    result_type = serializers.SerializerMethodField()

    class Meta(BaseChapterSerializer.Meta):
        fields = BaseChapterSerializer.Meta.fields + ("result_type",)

    def get_result_type(self, obj):
        return 'chapter'
