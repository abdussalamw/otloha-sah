from abc import abstractmethod, ABC
from pprint import pprint

from django.contrib.auth import get_user_model
from django.utils.text import slugify
from django.utils.translation import gettext as _
from rest_framework_simplejwt.tokens import RefreshToken

from apps.authn.models import SocialToken

UserModel = get_user_model()


class BaseProvider(ABC):
    name = None
    social_id_key = None
    expiry_key = None
    profile_picture_key = None

    ACCESS_TOKEN_MISSING = _('Access token is missing.')

    @abstractmethod
    def get_user_data(self, data):
        raise NotImplementedError("Subclasses must implement this method")

    @abstractmethod
    def get_user(self, data):
        raise NotImplementedError("Subclasses must implement this method")

    @abstractmethod
    def authorize(self, token):
        raise NotImplementedError("Subclasses must implement this method")

    def generate_unique_username(self, base):
        username = slugify(base)
        unique_username = username
        suffix = 1
        while UserModel.objects.filter(username=unique_username).exists():
            unique_username = f"{username}{suffix}"
            suffix += 1
        return unique_username

    def get_social_token(self, user, social_account, payload):
        refresh = RefreshToken.for_user(user)
        jwt_token = str(refresh.access_token)
        try:
            social_token = SocialToken.objects.get(user=user, social_account=social_account)
            social_token.token = payload['access_token']
            social_token.expiry = payload[self.expiry_key]
            social_token.jwt_token = jwt_token
            social_token.save()
        except SocialToken.DoesNotExist:
            SocialToken.objects.create(
                user=user,
                social_account=social_account,
                provider=self.name,
                extra_data=payload,
                token=payload['access_token'],
                expiry=payload[self.expiry_key],
                jwt_token=jwt_token
            )

        return {'refresh': str(refresh), 'access': jwt_token}

    def get_profile_picture(self, data):
        return data[self.profile_picture_key]

    def get_social_account(self, user, data):
        obj, created = user.social_accounts.get_or_create(provider=self.name, social_id=data[self.social_id_key])
        obj.image = self.get_profile_picture(data)
        obj.save()
        return obj

    def get_or_create_user(self, data):
        try:
            user = self.get_user(data)
        except UserModel.DoesNotExist:
            user = UserModel.objects.create(**self.get_user_data(data))

        social_account = self.get_social_account(user, data)
        tokens = self.get_social_token(user, social_account, data)
        return user, tokens

    def do_authorize(self, payload):
        return self.authorize(payload)

    def do_auth(self, payload):
        credential = payload.get('access_token')
        if not credential:
            raise ValueError(self.ACCESS_TOKEN_MISSING)
        user_data = self.do_authorize(payload)
        user_data = {**user_data, **payload}
        user, tokens = self.get_or_create_user(user_data)
        return user, tokens

