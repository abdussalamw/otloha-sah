from translation.forms import TranslatableModelForm

from apps.parts.models import Part


class PartForm(TranslatableModelForm):
    class Meta:
        model = Part
        fields = ['name', 'alias', 'part_number']
