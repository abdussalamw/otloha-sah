from django import forms
from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _
from apps.users.models import User


class UserForm(forms.ModelForm):
    class Meta:
        model = User
        fields = (
            "username", "first_name", "last_name", "email", "phone"
        )

    def clean_username(self):
        username = self.cleaned_data['username']
        if User.objects.filter(username=username).exists() and not self.instance.username == username:
            raise ValidationError(_("Username already exists"), code="unique")
        return username

    def clean_phone(self):
        phone = self.cleaned_data['phone']
        if User.objects.filter(phone=phone).exists() and not self.instance.phone == phone:
            raise ValidationError(_("Phone already exists"), code="unique")
        return phone

    def clean_email(self):
        email = self.cleaned_data['email']
        if User.objects.filter(email=email).exists() and not self.instance.email == email:
            raise ValidationError(_("Email already exists"), code="unique")
        return email
