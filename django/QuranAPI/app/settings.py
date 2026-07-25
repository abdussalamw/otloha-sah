from app.config.apps import *
from app.config.auth import *
from app.config.celery import *
# from app.config.channels import *
from app.config.cors import *
from app.config.database import *
from app.config.localization import *
from app.config.main import *
from app.config.middleware import *
from app.config.phone_service import *
from app.config.rest_framework import *
from app.config.search_providers import *
from app.config.templates import *
from app.config.testing import *

# Package Settings
# localization
from django.utils.translation import gettext_lazy as _

BASE_TEMPLATE_MULTIPLE_LANGUAGES = True

BASE_TEMPLATE_APP_NAME = _("Base Template")

# Sidebar
BASE_TEMPLATE_GET_SIDEBAR_METHOD = 'base_template.sidebars.get_sidebar'
BASE_TEMPLATE_SIDEBAR_FOOTER_TEMPLATE = "base_template/layout/partials/sidebar/_footer.html"
BASE_TEMPLATE_SIDEBAR_LOGO = "assets/img/logo.svg"
BASE_TEMPLATE_SIDEBAR_LOGO_ICON = "assets/img/logo.svg"

# header
BASE_TEMPLATE_HEADER_LOGO = "base_template/images/logo-dark.svg"
BASE_TEMPLATE_HEADER_LEFT_MENUS = [
    {"order": 0, "template_name": "base_template/partials/menus/_sample_right_menu.html"}
]
BASE_TEMPLATE_HEADER_RIGHT_MENUS = [
    {"order": 0, "template_name": "base_template/partials/theme-mode/_main.html"},
    {"order": 1, "template_name": "base_template/partials/menus/_user-account-menu.html"},
]

# footer
BASE_TEMPLATE_LINKS_TEMPLATE = 'base_template/layout/partials/footer/__footer_links.html'
BASE_TEMPLATE_COPYRIGHTS = {"text": _("Fritill"), "url": "https://fritill.com"}
