from .main import *

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [
            BASE_DIR / 'templates',
        ],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'base_template.context_processors.base_template',
            ],
        },
    },
]

FORM_RENDERER = "django.forms.renderers.TemplatesSetting"

# Base template settings

# localization
from django.utils.translation import gettext_lazy as _

BASE_TEMPLATE_MULTIPLE_LANGUAGES = True

BASE_TEMPLATE_APP_NAME = _("Otloha Sah")

# Sidebar
BASE_TEMPLATE_GET_SIDEBAR_METHOD = 'app.sidebars.get_sidebar'

BASE_TEMPLATE_SIDEBAR_FOOTER_TEMPLATE = None
BASE_TEMPLATE_SIDEBAR_LOGO = "images/logo.png"
BASE_TEMPLATE_SIDEBAR_LOGO_ICON = "images/logo.png"

# header
BASE_TEMPLATE_HEADER_LOGO = "images/logo.png"
BASE_TEMPLATE_HEADER_LEFT_MENUS = []
BASE_TEMPLATE_HEADER_RIGHT_MENUS = [
    # {"order": 1, "template_name": "base_template/partials/theme-mode/_main.html"},
    # {"order": 2, "template_name": "menus/_user-account-menu.html"},
]
BASE_TEMPLATE_GET_ASSETS_METHOD = 'app.sidebars.get_assets'

# toolbar
BASE_TEMPLATE_TOOLBAR_FIXED = True

# right drawers
BASE_TEMPLATE_RIGHT_DRAWERS = []
# footer
BASE_TEMPLATE_COPYRIGHTS = {"text": _("Khairokom Association"), "url": "https://qjstore.org.sa/"}
