from django import forms
from django.contrib.auth.models import Group

from apps.users.models import Admin


class GroupForm(forms.ModelForm):
    class Meta:
        model = Group
        fields = ("name", "permissions",)

    class Media:
        js = ("groups/permissions.js",)


class GroupAdminForm(forms.ModelForm):
    users = forms.ModelMultipleChoiceField(
        queryset=Admin.objects.all(),
        widget=forms.SelectMultiple(attrs={
            "class": "form-control select2",
            "data-control": "select2",
            "data-placeholder": "Select an option",
            "data-allow-clear": "true",
            "multiple": "multiple",
            "style": "width: 100%;",
            "data-dropdown-parent": "#modal-group-admins",
        })
    )

    class Meta:
        model = Group
        fields = ("users",)

    class Media:
        js = ("groups/grant-group-access-form.js",)

    def __init__(self, *args, **kwargs):
        super(GroupAdminForm, self).__init__(*args, **kwargs)
        if self.instance.pk:
            self.fields['users'].initial = self.instance.user_set.all()

    def save(self, commit=True):
        instance = super(GroupAdminForm, self).save(commit=commit)
        instance.user_set.set(self.cleaned_data['users'])
        return instance


