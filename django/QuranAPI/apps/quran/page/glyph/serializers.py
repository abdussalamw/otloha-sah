from rest_framework import serializers

from apps.quran.models import Glyph


class GlyphSerializer(serializers.ModelSerializer):
    class Meta:
        model = Glyph
        fields = [
            'id',
            'chapter',
            'page',
            'verse',
            'line_number',
            'min_x',
            'max_x',
            'min_y',
            'max_y',
            'position'
        ]
