from django.conf import settings
from django.dispatch import receiver
from django_rest_passwordreset.signals import reset_password_token_created

from apps.authn.tasks import send_password_reset_email


@receiver(reset_password_token_created)
def password_reset_token_created(sender, instance, reset_password_token, *args, **kwargs):
    protocol = "https" if instance.request.is_secure() else 'http'

    app_url = f"{protocol}://app.otlohasah.org"
    reset_password_url = f"{app_url}/reset-password/?token={reset_password_token.key}"
    send_password_reset_email.delay(
        user_id=reset_password_token.user.id,
        app_url=app_url,
        reset_password_url=reset_password_url)
