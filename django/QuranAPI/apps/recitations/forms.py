from translation.forms import TranslatableModelForm

from apps.recitations.models import Recitation


class RecitationForm(TranslatableModelForm):
    class Meta:
        model = Recitation
        fields = ['name', 'narration', 'reciter']
