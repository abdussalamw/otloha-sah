from django import forms
from django.forms import modelformset_factory

from apps.settings.models import Setting, UserSetting


class SettingForm(forms.ModelForm):
    class Meta:
        model = Setting
        fields = ('value',)


class UserSettingsForm(forms.ModelForm):
    class Meta:
        model = UserSetting
        fields = ('value',)


SettingsFormSet = modelformset_factory(model=Setting, form=SettingForm, extra=0)
UserSettingsFormSet = modelformset_factory(model=Setting, form=SettingForm, extra=0)
