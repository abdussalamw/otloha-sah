from django import forms
from django.contrib.auth.models import Group, Permission
from django.utils.translation import gettext_lazy as _

from .user import UserForm
from ..models import Admin


class AdminForm(UserForm):
    permissions = forms.ModelMultipleChoiceField(
        queryset=Permission.objects.all(),
        required=False)
    groups = forms.ModelMultipleChoiceField(
        required=False,
        label=_("Roles"),
        queryset=Group.objects.all(),
        widget=forms.SelectMultiple(attrs={
            "class": "form-control select2",
            "data-control": "select2",
            "data-placeholder": _("Select Roles"),
            "data-allow-clear": "true",
            "multiple": "multiple",
            "style": "width: 100%;",
        })
    )

    class Meta(UserForm.Meta):
        model = Admin
        fields = UserForm.Meta.fields + ("is_superuser", "groups", "permissions")

    class Media:
        js = ('groups/permissions.js',)

    def __init__(self, *args, **kwargs):
        super(AdminForm, self).__init__(*args, **kwargs)
        if self.instance.pk:
            self.fields['groups'].initial = self.instance.groups.all()
            self.fields['permissions'].initial = self.instance.user_permissions.all()

    def save(self, commit=True):
        instance = super(AdminForm, self).save(commit=False)
        instance.is_staff = True
        if commit:
            instance.save()

            instance.groups.set(self.cleaned_data['groups'])

            instance.user_permissions.set(self.cleaned_data['permissions'])
        return instance
