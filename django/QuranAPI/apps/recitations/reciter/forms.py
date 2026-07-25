from translation.forms import TranslatableModelForm

from apps.recitations.models import Reciter


class ReciterForm(TranslatableModelForm):
    class Meta:
        model = Reciter
        fields = ["name"]
