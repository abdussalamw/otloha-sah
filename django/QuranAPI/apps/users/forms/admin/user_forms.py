from django.forms import ModelForm

from apps.users.models import User


class AdminUserCreateForm(ModelForm):
    class Meta:
        model = User
        fields = ['username', 'first_name', 'last_name', 'email', 'phone', 'groups', 'user_permissions']


class AdminUserEditForm(ModelForm):
    class Meta:
        model = User
        fields = ['user_permissions', 'is_active', 'groups', "is_staff"]
