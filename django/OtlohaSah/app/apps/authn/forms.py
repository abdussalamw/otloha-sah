from django import forms
from django.contrib.auth import get_user_model, authenticate
from django.contrib.auth.forms import _unicode_ci_compare, SetPasswordForm as BaseSetPasswordForm
from django.contrib.auth.tokens import default_token_generator
from django.core.exceptions import ValidationError
from django.forms import Form
from django.urls import reverse
from django.utils.encoding import force_bytes
from django.utils.http import urlsafe_base64_encode
from django.utils.translation import gettext as _

from apps.authn.tasks import send_password_reset_email

UserModel = get_user_model()


class AuthenticationForm(Form):
    """
    Base class for authenticating users. Extend this to get a form that accepts
    username/password logins.
    """

    identifier = forms.CharField(
        label=_("Email, Phone, Username, or ID"),
        widget=forms.TextInput(attrs={"autofocus": True}))
    password = forms.CharField(
        label=_("Password"),
        strip=False,
        widget=forms.PasswordInput(attrs={"autocomplete": "current-password"}),
    )

    error_messages = {
        "invalid_login": _(
            "Please enter a correct credentials. Note that both "
            "fields may be case-sensitive."
        ),
        "inactive": _("This account is inactive."),
    }

    def __init__(self, request=None, *args, **kwargs):
        """
        The 'request' parameter is set for custom auth use by subclasses.
        The form data comes in via the standard 'data' kwarg.
        """
        self.request = request
        self.user_cache = None
        super().__init__(*args, **kwargs)

    def clean(self):
        identifier = self.cleaned_data.get("identifier")
        password = self.cleaned_data.get("password")

        if identifier is not None and password:
            self.user_cache = authenticate(self.request, identifier=identifier, password=password)
            if self.user_cache is None:
                raise self.get_invalid_login_error()
            else:
                self.confirm_login_allowed(self.user_cache)

        return self.cleaned_data

    def confirm_login_allowed(self, user):
        """
        Controls whether the given User may log in. This is a policy setting,
        independent of end-user authentication. This default behavior is to
        allow login by active users, and reject login by inactive users.

        If the given user cannot log in, this method should raise a
        ``ValidationError``.

        If the given user may log in, this method should return None.
        """
        if not user.is_active:
            raise ValidationError(self.error_messages["inactive"], code="inactive")

    def get_user(self):
        return self.user_cache

    def get_invalid_login_error(self):
        return ValidationError(self.error_messages["invalid_login"], code="invalid_login")


class PasswordResetForm(Form):
    email = forms.EmailField(
        label=_("Email"),
        max_length=254,
        widget=forms.EmailInput(attrs={"autocomplete": "email"}),
    )

    def get_users(self, email):
        email_field_name = UserModel.get_email_field_name()
        active_users = UserModel._default_manager.filter(
            **{
                "%s__iexact" % email_field_name: email,
                "is_active": True,
            }
        )
        return (
            u
            for u in active_users
            if u.has_usable_password()
               and _unicode_ci_compare(email, getattr(u, email_field_name))
        )

    def save(self, is_secure, host):
        email = self.cleaned_data["email"]
        protocol = "https" if is_secure else 'http'
        app_url = f"{protocol}://{host}"
        for user in self.get_users(email):
            pattern = reverse('admin:authentication:password-reset:confirm', args=[
                urlsafe_base64_encode(force_bytes(user.pk)),
                default_token_generator.make_token(user)
            ])
            reset_password_url = f"{app_url}{pattern}"
            send_password_reset_email(
                user_id=user.id,
                app_url=app_url,
                reset_password_url=reset_password_url)


class SetPasswordForm(BaseSetPasswordForm, Form):
    pass
