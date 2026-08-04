import distutils.util
import os
from pathlib import Path

import environ

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent.parent
TEMPLATE_DIR = Path("templates").resolve()
# Initialise environment variables
env = environ.Env()
environ.Env.read_env(os.path.join(BASE_DIR, '.env'))
MIN_APP_VERSION = os.environ.get('MIN_APP_VERSION')
# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/3.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get('SECRET_KEY')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = bool(distutils.util.strtobool(os.environ.get('DEBUG', "false")))

ALLOWED_HOSTS = []
ALLOWED_HOSTS.extend(filter(None, os.environ.get('ALLOWED_HOSTS', '').split(',')))

SITE_ID = 1
ROOT_URLCONF = 'app.urls'
WSGI_APPLICATION = 'app.wsgi.application'
ASGI_APPLICATION = "app.asgi.application"

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/3.2/howto/static-files/
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

STATIC_URL = '/static/'
MEDIA_URL = '/media/'

MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
UPLOAD_ROOT = os.path.join(BASE_DIR, 'uploads')

STATICFILES_DIRS = [
    os.path.join(BASE_DIR, 'static'),
]

DATE_INPUT_FORMATS = ('%d-%m-%Y', '%Y-%m-%d')

if DEBUG:
    INTERNAL_IPS = [
        # ...
        "127.0.0.1",
        # ...
    ]
    DEBUG_TOOLBAR_CONFIG = {
        'INTERCEPT_REDIRECTS': False,
    }

CORS_ALLOWED_ORIGINS = []
CORS_ALLOWED_ORIGINS.extend(filter(None, os.environ.get('CORS_ALLOWED_ORIGINS', '').split(',')))
