import os

from .main import *

AUTH_USER_MODEL = 'users.User'

AUTHENTICATION_BACKENDS = (
    'apps.authn.backends.MultipleAuthenticationBackend',
)

LOGIN_URL = '/login/'
LOGIN_REDIRECT_URL = '/'
LOGOUT_REDIRECT_URL = '/'

# Password validation
# https://docs.djangoproject.com/en/3.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    # {
    #     'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    # },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    # {
    #     'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    # },
    # {
    #     'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    # },
]

REGISTER_FORM = "apps.users.forms.auth.RegisterForm"
PROFILE_SERIALIZER = "apps.users.profile.serializers.UpdateProfileSerializer"
MULTIPLE_AUTHENTICATION_ACTIVE = True
# GSI
SOCIAL_AUTH_GSI_KEY = os.environ.get("SOCIAL_AUTH_GSI_KEY", "")
# X
SOCIAL_X_CLIENT_ID = os.environ.get("SOCIAL_X_CLIENT_ID", "")
SOCIAL_X_CLIENT_SECRET = os.environ.get("SOCIAL_X_CLIENT_SECRET", "")
SOCIAL_X_REDIRECT_URI = os.environ.get("SOCIAL_X_REDIRECT_URI", "")
# AppleID
SOCIAL_APPLE_CLIENT_ID = os.environ.get("SOCIAL_APPLE_CLIENT_ID", "")

