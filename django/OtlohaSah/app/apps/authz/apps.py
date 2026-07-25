# from base_template.utils import register_sidebar_item
from django.apps import AppConfig
from django.urls import reverse
from django.utils.translation import gettext_lazy as _


class AuthzConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.authz'

    # def get_admin_sidebar(self, request):
    #     user = request.user
    #
    #     return register_sidebar_item(
    #         order=15,
    #         title=_('Roles'),
    #         url=reverse("admin:authorization:listing"),
    #         icon='<i class="ki-duotone ki-shield fs-2"><span class="path1"></span><span class="path2"></span></i>',
    #         is_active=request.path == reverse("admin:authorization:listing"),
    #         permissions=user.has_perm("auth.view_group"),
    #         comment=_("View all roles"),
    #     )

