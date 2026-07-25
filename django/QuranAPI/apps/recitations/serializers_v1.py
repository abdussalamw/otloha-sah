from translation.serializers import TranslatableModelSerializer

from apps.recitations.models import Recitation


class RecitationSerializer(TranslatableModelSerializer):
    class Meta:
        model = Recitation
        fields = ['id', 'narration', 'reciter', 'name']
