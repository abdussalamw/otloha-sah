from translation.serializers import TranslatableModelSerializer

from apps.recitations.models import Reciter


class RecitersSerializer(TranslatableModelSerializer):
    class Meta:
        model = Reciter
        fields = ['id', 'name']
