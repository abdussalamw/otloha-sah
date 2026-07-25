# Package Settings
# localization
from django.utils.translation import gettext_lazy as _

BASE_TEMPLATE_MULTIPLE_LANGUAGES = True

# Logo


# Sidebar
BASE_TEMPLATE_GET_SIDEBAR_METHOD = 'app.sidebars.get_sidebar'
BASE_TEMPLATE_SIDEBAR_FOOTER_TEMPLATE = "base_template/layout/partials/sidebar/_footer.html"
BASE_TEMPLATE_SIDEBAR_LOGO = "images/logo.png"

# header
BASE_TEMPLATE_HEADER_LOGO = "images/logo.png"
BASE_TEMPLATE_HEADER_LEFT_MENUS = [
    # {"order": 0, "template_name": "base_template/partials/menus/_sample_right_menu.html"}
]
BASE_TEMPLATE_HEADER_RIGHT_MENUS = [
    {"order": 0, "template_name": "base_template/partials/theme-mode/_main.html"},
    {"order": 1, "template_name": "base_template/partials/menus/_user-account-menu.html"},
]

# footer
BASE_TEMPLATE_LINKS_TEMPLATE = '' # base_template/layout/partials/footer/__footer_links.html'
BASE_TEMPLATE_COPYRIGHTS = {"text": _("All Rights Reserved to Khairkom Association"), "url": "#"}
