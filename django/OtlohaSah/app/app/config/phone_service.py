import distutils.util
import os

from django.utils.translation import gettext_lazy as _

PHONE_VERIFY_SERVICE = os.environ.get('PHONE_VERIFY_SERVICE')

# Twilio
TWILIO_VERIFY_SERVICE_SID = os.environ.get('TWILIO_VERIFY_SERVICE_SID')
TWILIO_ACCOUNT_SID = os.environ.get('TWILIO_ACCOUNT_SID')
TWILIO_AUTH_TOKEN = os.environ.get('TWILIO_AUTH_TOKEN')
TWILIO_PREMIUM_ENABLED = bool(distutils.util.strtobool(os.environ.get('TWILIO_PREMIUM_ENABLED', 'false')))

TWILIO_NAME = _('Otloha Sah')
