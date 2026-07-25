from django import forms
from django.contrib.auth import get_user_model, authenticate
from django.contrib.auth.forms import UserCreationForm
from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _

from apps.users.auth.verify_phone import VerifyPhone

UserModel = get_user_model()


class RegisterForm(UserCreationForm):
    username = forms.CharField(
        required=True,
        max_length=100, help_text="Required, please provide your username")

    first_name = forms.CharField(
        required=True,
        max_length=100, help_text="Required, please provide your first name")

    last_name = forms.CharField(
        required=True,
        max_length=100, help_text="Required, please provide your last name")

    email = forms.EmailField(
        required=True,
        max_length=100, help_text="Required, please provide your email")
    phone = forms.CharField(
        required=True,
        max_length=100, help_text="Required, please provide your phone number")
    # gender = forms.ChoiceField(required=True, choices=UserModel.GENDERS)

    class Meta:
        model = UserModel
        fields = ('first_name', 'last_name', 'email', 'phone', 'password1', 'password2')

    def clean_phone(self):
        phone = self.cleaned_data['phone']
        if UserModel.objects.filter(phone=phone).exists():
            raise ValidationError("Phone already exists", code="unique")
        return phone

    def clean_email(self):
        email = self.cleaned_data['email']
        if UserModel.objects.filter(email=email).exists():
            raise ValidationError("Email already exists", code="unique")
        return email

    def clean_first_name(self):
        first_name = self.cleaned_data['first_name']
        if not first_name:
            raise ValidationError("First Name is Required", code="Required")
        return first_name

    def clean_last_name(self):
        last_name = self.cleaned_data['last_name']
        if not last_name:
            raise ValidationError("Last Name is Required", code="Required")
        return last_name


class AuthenticationForm(forms.Form):
    username = forms.EmailField(required=False)
    phone = forms.CharField(required=False)
    password = forms.CharField(
        label=_("Password"),
        strip=False,
        widget=forms.PasswordInput(attrs={'autocomplete': 'current-password'}),
    )
    remember_me = forms.BooleanField(
        required=False,
        label=_('Remember Me'),
        initial=False
    )

    error_messages = {
        'invalid_login': _(
            "Please enter a correct phone and password. Note that both "
            "fields may be case-sensitive."
        ),
        'inactive': _("This account is inactive."),
        "phone_or_username_are_required": _("Please enter a correct phone or username"),
    }

    def __init__(self, request=None, *args, **kwargs):
        self.request = request
        self.user_cache = None
        super(AuthenticationForm, self).__init__(*args, **kwargs)
        self.username_field = UserModel._meta.get_field(UserModel.USERNAME_FIELD)

    def get_user(self):
        return self.user_cache

    def clean(self):
        username = self.cleaned_data.get('username')
        phone = self.cleaned_data.get('phone')
        password = self.cleaned_data.get('password')
        remember_me = self.cleaned_data.get('remember_me')
        login_by = None

        if not phone and not username:
            raise ValidationError(
                self.error_messages['phone_or_username_are_required'],
                code='phone_or_username_are_required',
                params={
                    'phone': UserModel._meta.get_field('phone').verbose_name,
                    'username': self.username_field.verbose_name,
                })

        credentials = {"password": password}

        if phone:
            login_by = phone
            credentials.update({"phone": phone})

        elif username:
            login_by = username
            credentials.update({UserModel.USERNAME_FIELD: username})

        if login_by and password:
            self.user_cache = authenticate(request=self.request, **credentials)
            if not self.user_cache:
                raise ValidationError(
                    self.error_messages['invalid_login'],
                    code='invalid_login',
                    params={'phone': UserModel._meta.get_field('phone').verbose_name})
            if not remember_me:
                self.request.session.set_expiry(0)
                self.request.session.modified = True
            else:
                if not self.user_cache.is_active:
                    raise ValidationError(self.error_messages['inactive'], code='inactive')

        return self.cleaned_data


class VerifyPhoneForm(forms.Form):
    code = forms.CharField(max_length=6, min_length=6)

    def __init__(self, *args, **kwargs):
        self.user = kwargs.pop('user', None)
        super(VerifyPhoneForm, self).__init__(*args, **kwargs)
        self.fields['code'].label = "message sent to phone number: {}".format(self.user.phone)

    def clean(self):
        code = self.cleaned_data.get('code')

        success = VerifyPhone().check(self.user.phone, code)
        if not success:
            raise ValidationError(_("The Provided code is Properly invalid"), code='invalid_code')

        return self.cleaned_data
