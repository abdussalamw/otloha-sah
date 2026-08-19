from rest_framework import serializers

from apps.quran.page.glyph.serializers import GlyphSerializer
# from apps.quran.page.verses.serializers import VerseSerializer
from apps.quran.models import Page
# from apps.tajweed.serializers import VerseSerializer


class PageSerializer(serializers.ModelSerializer):
    glyphs = GlyphSerializer(many=True, read_only=True, source="page_glyphs")
    image = serializers.ImageField(use_url=True)
    chapters = serializers.SerializerMethodField(method_name="get_chapters")

    class Meta:
        model = Page
        fields = (
            "id",
            "image",
            "page_number",
            "sub_part",
            "chapters",
            "part",
            "book",
            "narration",
            "glyphs"
        )

    def get_chapters(self, obj):
        return list(obj.chapters.values_list('chapter_id', flat=True))
