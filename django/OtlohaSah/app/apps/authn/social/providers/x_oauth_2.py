import base64

import requests
from django.conf import settings
from django.contrib.auth import get_user_model
from django.utils.translation import gettext as _

from .base import BaseProvider

UserModel = get_user_model()


class XOAUTH2Provider(BaseProvider):
    name = "x"
    social_id_key = 'id'
    expiry_key = "expires_in"
    access_token_uri = 'https://api.twitter.com/2/oauth2/token'
    authorize_uri = 'https://api.twitter.com/2/users/me'

    ACCESS_TOKEN_MISSING = _('Authorization code is missing.')
    profile_picture_key = 'profile_image_url'
    app_access_token = None

    def get_app_access_token(self):
        if not self.app_access_token:
            credentials = f'{settings.SOCIAL_X_CLIENT_ID}:{settings.SOCIAL_X_CLIENT_SECRET}'
            self.app_access_token = base64.b64encode(credentials.encode('utf-8')).decode('utf-8')
        return self.app_access_token

    def get_access_token(self, payload):
        response = requests.post(self.access_token_uri, data={
            'grant_type': 'authorization_code',
            'code': payload['access_token'],
            "redirect_uri": settings.SOCIAL_X_REDIRECT_URI,
            'code_verifier': "8KxxO-RPl0bLSxX5AWwgdiFbMnry_VOKzFeIlVA7NoA",
            'code_challenge_method': "S256",
        }, headers={
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization': f'Basic {self.get_app_access_token()}'
        })
        response.raise_for_status()
        return response.json()

    def authorize(self, data):
        response = requests.get(
            url=self.authorize_uri,
            params={
                "user.fields": "id,description,profile_image_url,username,name"
            },
            headers={'Authorization': f"Bearer {data['access_token']}"})
        return {**response.json()['data'], **data}

    def get_user_data(self, data):
        return {
            "username": self.generate_unique_username(data['name']),
            "bio": data['description'],
            "first_name": data['name'],
        }

    def get_user(self, data):
        return UserModel.objects.get(social_accounts__social_id=data['id'])

    def do_authorize(self, payload):
        data = self.get_access_token(payload)
        return self.authorize(data)




