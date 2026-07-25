import firebase_admin
from django.conf import settings
from firebase_admin import credentials
import os

try:
    if getattr(settings, 'FCM_CRED_CERTIFICATE', None) and os.path.exists(settings.FCM_CRED_CERTIFICATE):
        firebase_cred = credentials.Certificate(settings.FCM_CRED_CERTIFICATE)
        firebase_app = firebase_admin.initialize_app(firebase_cred)
    else:
        firebase_app = None
except Exception:
    firebase_app = None
