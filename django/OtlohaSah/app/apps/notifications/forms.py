from django import forms
from django.utils.translation import gettext as _

from apps.notifications.models import PushNotificationToken


class PushNotificationTokenForm(forms.ModelForm):
    class Meta:
        model = PushNotificationToken
        fields = ('token', 'device_name')

    def __init__(self, user, *args, **kwargs):
        self.user = user
        super().__init__(*args, **kwargs)

    def save(self, commit=True):
        old_token = PushNotificationToken.objects.filter(device_name=self.cleaned_data.get('device_name'))
        if old_token.exists():
            old_token.delete()
        instance = super().save(commit=False)
        instance.user = self.user

        if commit:
            instance.save()

        return instance


class NotificationForm(forms.Form):
    title = forms.CharField(label=_("title"))
    body = forms.CharField(label=_("Body"))
    image = forms.ImageField()


