import os

from app.config.main import env_bool
from django.utils.translation import gettext_lazy as _

PHONE_VERIFY_SERVICE = os.environ.get('PHONE_VERIFY_SERVICE')

# Twilio
TWILIO_VERIFY_SERVICE_SID = os.environ.get('TWILIO_VERIFY_SERVICE_SID')
TWILIO_ACCOUNT_SID = os.environ.get('TWILIO_ACCOUNT_SID')
TWILIO_AUTH_TOKEN = os.environ.get('TWILIO_AUTH_TOKEN')
TWILIO_PREMIUM_ENABLED = env_bool(os.environ.get('TWILIO_PREMIUM_ENABLED', 'false'))

TWILIO_NAME = _('Otloha Sah')
