from datetime import timedelta

from django.utils import timezone
from oauth2_provider.models import Application, AccessToken


def create_authorization_header(token):
    return "Bearer {0}".format(token)


def create_token(user):
    app = Application.objects.create(
        client_type=Application.CLIENT_CONFIDENTIAL,
        authorization_grant_type=Application.GRANT_CLIENT_CREDENTIALS,
        redirect_uris='',
        name='dummy',
        user=user
    )
    return AccessToken.objects.create(
        user=user,
        scope='read write',
        expires=timezone.now() + timedelta(seconds=300),
        token='secret-access-token-key',
        application=app
    )
