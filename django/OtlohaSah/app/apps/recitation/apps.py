from base_template.utils import register_sidebar_label, register_sidebar_item
from django.apps import AppConfig
from django.urls import reverse
from django.utils.translation import gettext as _


class RecitationConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.recitation'

    def get_admin_sidebar(self, request):
        user = request.user
        return [
            register_sidebar_item(
                order=0,
                title=_("Home"),
                icon='<i class="fa-solid fa-house fs-2"></i>',
                url='/admin/',
                is_active=request.path == '/admin/',
                permissions=True,
            ),
            register_sidebar_label(
                order=0,
                title=_("Services"),
                permissions=user.has_perms([
                    user.has_perm('recitation.view_recitation'),
                ])
            ),
            register_sidebar_item(
                order=1,
                title=_("Recitations"),
                icon='<i class="fa-solid fa-play fs-2"></i>',
                is_active='/recitations' in request.path,
                permissions=any([
                    user.has_perm('recitation.view_recitation'),
                ]),
                children=[
                    register_sidebar_item(
                        order=0,
                        title=_("Statistics"),
                        url=reverse('admin:recitations:statistics'),
                        is_active=reverse('admin:recitations:statistics') == request.path,
                        permissions=user.has_perm('recitation.view_recitation'),
                        comment=_("View recitation statistics"),
                        is_child=True
                    ),
                    register_sidebar_item(
                        order=1,
                        title=_("Recitations"),
                        url=reverse('admin:recitations:listing'),
                        is_active=reverse('admin:recitations:listing') == request.path,
                        permissions=user.has_perm('recitation.view_recitation'),
                        comment=_("View all Recitations"),
                        is_child=True
                    ),

                ]
            ),
        ]
