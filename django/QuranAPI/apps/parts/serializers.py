from translation.serializers import TranslatableModelSerializer

from apps.parts.models import Part


class PartSerializer(TranslatableModelSerializer):
    class Meta:
        model = Part
        fields = ['id', 'name', "alias", 'part_number']
