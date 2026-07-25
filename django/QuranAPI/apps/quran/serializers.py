from translation.serializers import TranslatableModelSerializer

from apps.quran.models import *


class BookSerializer(TranslatableModelSerializer):
    class Meta:
        model = Book
        fields = ['id', 'name', 'narration']
