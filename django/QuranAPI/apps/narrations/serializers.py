from translation.serializers import TranslatableModelSerializer

from apps.narrations.models import Narration


class NarrationSerializer(TranslatableModelSerializer):
    class Meta:
        model = Narration
        fields = ['id', 'name', 'description']
        