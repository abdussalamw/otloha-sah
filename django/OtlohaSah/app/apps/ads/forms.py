from django.forms import ModelForm

from apps.ads.models import Ad


class AdForm(ModelForm):
    class Meta:
        model = Ad
        fields = ('title', 'url', 'image', 'is_active')

