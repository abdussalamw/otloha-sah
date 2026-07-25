from django.utils.translation import gettext_lazy as _

from app.config.main import *

# Internationalization
# https://docs.djangoproject.com/en/3.2/topics/i18n/

LOCALE_PATHS = (
    os.path.join(BASE_DIR, 'locale'),
)

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True

USE_TZ = True

MAIN_LANGUAGE = 'ar'
# Language
LANGUAGE_ENGLISH = "en"
LANGUAGE_ARABIC = "ar"
LANGUAGES = (
    (LANGUAGE_ENGLISH, _("English")),
    (LANGUAGE_ARABIC, _("Arabic"))
)

LANGUAGES_KEYS = [LANGUAGE_ENGLISH, LANGUAGE_ARABIC]
LANGUAGE_CODE = LANGUAGE_ARABIC
FALLBACK_LOCALE = LANGUAGE_ARABIC
