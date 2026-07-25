import phonenumbers

from django import forms
from django.conf import settings
from django.utils.translation import gettext as _
from phonenumber_field.formfields import PhoneNumberField

from apps.users import config
from apps.users.models import User


class RegisterForm:
    gender = forms.ChoiceField(required=True, choices=config.GENDERS,
                               help_text=_("Required, please provide your gender"))

    birthdate = forms.DateField(required=True,
                                input_formats=settings.DATE_INPUT_FORMATS,
                                help_text=_("Required, please select your birthdate"))
    phone = PhoneNumberField()
    country = forms.CharField(required=False, widget=forms.HiddenInput())

    class Meta:
        model = User
        fields = ("username", 'email', 'phone', 'password1', 'password2', 'gender', 'birthdate', 'country')
        widgets = {
            "birthdate": forms.DateInput(attrs={"type": "date"}),
        }

    def clean_country(self):
        if phone := self.cleaned_data.get('phone', None):
            phone_number = phonenumbers.parse(phone.raw_input, None)
            country_code = phonenumbers.region_code_for_number(phone_number)
            if country_code == 'IL':
                country_code = "PS"
            country = country_code
            return country
        else:
            self.add_error('phone', _('Please provide a valid phone number'))
