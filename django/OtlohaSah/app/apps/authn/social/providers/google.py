from django.conf import settings
from django.contrib.auth import get_user_model
from django.utils.timezone import now
from django.utils.translation import gettext as _
from google.auth.transport import requests

from apps.authn.social.providers.base import BaseProvider

UserModel = get_user_model()
from google.oauth2 import id_token


class GSIProvider(BaseProvider):
    name = 'gsi'
    social_id_key = 'sub'
    expiry_key = 'exp'
    profile_picture_key = 'picture'

    ACCESS_TOKEN_MISSING = _('Credentials is missing.')

    def authorize(self, payload):
        id_info = id_token.verify_oauth2_token(payload['access_token'], requests.Request())

        clients = settings.SOCIAL_AUTH_GSI_KEY.split(',')

        return id_info


    def get_user_data(self, data):
        username = self.generate_unique_username(data['name'])
        return {
            "username": username,
            "email_verified_at": now() if data['email_verified'] else None,
            "first_name": data['given_name'],
            "last_name": data['family_name'],
            "email": data['email'],
        }

    def get_user(self, data):
        return UserModel.objects.get(social_accounts__social_id=data['sub'])
