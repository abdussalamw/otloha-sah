from app.config.main import *

EMAIL_BACKEND = os.environ.get("EMAIL_BACKEND", "django.core.mail.backends.smtp.EmailBackend")

EMAIL_HOST = os.environ.get("EMAIL_HOST", None)
EMAIL_PORT = os.environ.get("EMAIL_PORT", 25)
EMAIL_HOST_USER = os.environ.get("EMAIL_HOST_USER", None)
EMAIL_HOST_PASSWORD = os.environ.get("EMAIL_HOST_PASSWORD", None)
EMAIL_USE_TLS = bool(distutils.util.strtobool(os.environ.get('EMAIL_USE_TLS', "false")))
EMAIL_USE_SSL = bool(distutils.util.strtobool(os.environ.get('EMAIL_USE_SSL', "false")))
DEFAULT_FROM_EMAIL =  os.environ.get("DEFAULT_FROM_EMAIL", 'security@otlohasah.org')
