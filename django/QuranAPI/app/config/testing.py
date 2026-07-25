import sys

from app.config.apps import *
from app.config.database import *

if 'test' in sys.argv:
    INSTALLED_APPS += [
        'dynamic_listing.tests',
    ]
    DATABASES['default'] = {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
