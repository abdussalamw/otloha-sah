from celery import shared_task
from django.core.mail import EmailMultiAlternatives
from django.template.loader import render_to_string
from django.utils.html import strip_tags
from django.utils.translation import gettext as _

from apps.users.models import User


def send_email_with_template(subject, template_name, context, to_email):
    context = {
        **context,
        "logo": "https://nawah.resporty.com/static/logos/FullColor/LOGO-2*4.png"
    }
    html_content = render_to_string(template_name, context)
    text_content = strip_tags(html_content)

    email = EmailMultiAlternatives(subject, text_content, to=[to_email])
    email.content_subtype = 'html'  # Set the content type to HTML

    email.attach_alternative(html_content, "text/html")
    email.send()


@shared_task
def send_password_reset_email(user_id, app_url, reset_password_url):
    user = User.objects.get(pk=user_id)
    send_email_with_template(
        _("Password reset on Otloha Sah"),
        'authn/emails/password-reset.html', {
            "username": user.get_full_name,
            "reset_password_url": reset_password_url,
            "app_url": app_url
        }, user.email)


@shared_task
def send_email_verification(user_id, app_url, verification_url):
    user = User.objects.get(pk=user_id)
    send_email_with_template(
        _("Email address verification on Otloha Sah"),
        'authn/emails/email_verification.html', {
            "username": user.get_full_name,
            "verification_url": verification_url,
            "app_url": app_url
        }, user.email)
