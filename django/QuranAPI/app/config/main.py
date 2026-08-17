import os
from pathlib import Path

import environ

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent.parent
TEMPLATE_DIR = Path("templates").resolve()
# Initialise environment variables
env = environ.Env()
environ.Env.read_env()

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/5.2/howto/deployment/checklist/


def env_bool(value):
    normalized = str(value).strip().lower()
    if normalized in {'y', 'yes', 't', 'true', 'on', '1'}:
        return True
    if normalized in {'n', 'no', 'f', 'false', 'off', '0'}:
        return False
    raise ValueError(f'Invalid boolean environment value: {value!r}')


# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ.get('SECRET_KEY')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = env_bool(os.environ.get('DEBUG', 'false'))

ALLOWED_HOSTS = []
ALLOWED_HOSTS.extend(filter(None, os.environ.get('ALLOWED_HOSTS', '').split(',')))


CSRF_TRUSTED_ORIGINS = [f"https://{host}" for host in ALLOWED_HOSTS]
USE_X_FORWARDED_HOST = True
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
print("=" *100)
print("CSRF_TRUSTED_ORIGINS", CSRF_TRUSTED_ORIGINS)
print("=" *100)
CORS_ALLOWED_ORIGINS = []
CORS_ALLOWED_ORIGINS.extend(filter(None, os.environ.get('CORS_ALLOWED_ORIGINS', '').split(',')))
CORS_ALLOW_HEADERS = "*"
print("=" *100)
print("CORS_ALLOWED_ORIGINS", CORS_ALLOWED_ORIGINS)
print("=" *100)
SITE_ID = 1
ROOT_URLCONF = 'app.urls'

# WSGI_APPLICATION = 'app.wsgi.application'
ASGI_APPLICATION = 'app.asgi.application'

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

STATIC_URL = '/static/'
MEDIA_URL = '/media/'

MEDIA_ROOT = os.path.join(BASE_DIR, 'media')
STATIC_ROOT = 'staticfiles/'
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, 'static'),
]

if DEBUG:
    INTERNAL_IPS = [
        # ...
        "127.0.0.1",
        # ...
    ]
    DEBUG_TOOLBAR_CONFIG = {
        'INTERCEPT_REDIRECTS': False,
    }

