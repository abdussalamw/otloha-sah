import requests
from django.contrib.auth import get_user_model
from django.db.models import Q

from .base import BaseProvider

UserModel = get_user_model()


class FacebookProvider(BaseProvider):
    name = 'facebook'
    social_id_key = 'userID'
    expiry_key = 'data_access_expiration_time'
    profile_picture_key = 'picture'

    AUTHORIZE_URL = 'https://graph.facebook.com/v20.0/me'
    PROFILE_PICTURE_URL = "https://graph.facebook.com/{}/picture?type=square"

    def authorize(self, payload):
        response = requests.get(self.AUTHORIZE_URL, params={
            "access_token": payload['access_token'],
            "fields": "name,email,picture,birthday,gender"
        })
        return response.json()

    def get_profile_picture(self, data):
        return data['picture']['data']['url']

    def get_user(self, data):
        return UserModel.objects.get(Q(Q(social_accounts__social_id=data[self.social_id_key]) | Q(email=data['email'])))

    def get_user_data(self, data):
        name_components = data['name'].splite('')
        return {
            "username": self.generate_unique_username(data['name']),
            "email": data['email'],
            "birthdate": data['birthday'],
            "gender": data['gender'],
            "first_name": name_components[0],
            "last_name": name_components[1],
            "full_name": data['name'],
        }
