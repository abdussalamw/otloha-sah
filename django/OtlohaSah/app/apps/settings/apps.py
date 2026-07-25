from base_template.utils import register_sidebar_label, register_sidebar_item
from django.apps import AppConfig
from django.urls import reverse
from django.utils.translation import gettext as _


class SettingsConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.settings'

    def get_admin_sidebar(self, request):
        user = request.user
        return [
            register_sidebar_label(
                order=9,
                title=_("System Settings"),
                permissions=any([
                    user.has_perm('settings.view_setting'),
                    user.has_perm('users.view_ad'),
                ])),
            register_sidebar_item(
                order=10,
                title=_("Settings"),
                icon='<i class="fa-solid fa-gear fs-2"></i>',
                url=reverse('admin:settings:listing', args=['recitations']),
                is_active='/settings' in request.path,
                permissions=user.has_perm('settings.view_setting'),
                comment=_("View all Settings"),
            ),
            register_sidebar_item(
                order=11,
                title=_("Ads"),
                icon='<i class="fa-solid fa-ad fs-2"></i>',
                url=reverse('admin:ads:listing'),
                is_active='/ads' in request.path,
                permissions=user.has_perm('users.view_ad'),
                comment=_("View all Ads"),
            ),
        ]
