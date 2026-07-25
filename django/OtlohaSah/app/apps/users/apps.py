from base_template.utils import register_sidebar_label, register_sidebar_item
from django.apps import AppConfig
from django.urls import reverse
from django.utils.translation import gettext as _


class UsersConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.users'

    def ready(self):
        from . import signals  # noqa

    def get_admin_sidebar(self, request):
        user = request.user
        return [
            register_sidebar_label(
                order=4,
                title=_("Users Management"),
                permissions=any([
                    user.has_perm('users.view_student'),
                    user.has_perm('users.view_teacher'),
                    user.has_perm('users.view_admin'),
                    user.has_perm('auth.view_roles'),
                ])),
            register_sidebar_item(
                order=5,
                title=_("Students"),
                url=reverse('admin:users:listing', args=['students']),
                icon='<i class="fa-solid fa-users fs-2"></i>',
                is_active='/students' in request.path,
                permissions=user.has_perm('users.view_teacher'),
                comment=_("View all Students")
            ),
            register_sidebar_item(
                order=6,
                title=_("Teachers"),
                icon='<i class="fa-solid fa-chalkboard-user fs-2"></i>',
                is_active='/teachers' in request.path,
                permissions=user.has_perm('users.view_teacher'),
                children=[
                    register_sidebar_item(
                        order=0,
                        title=_("Teachers"),
                        url=reverse('admin:users:listing', args=['teachers']),
                        is_active='/teachers/' in request.path,
                        permissions=user.has_perm('users.view_teacher'),
                        comment=_("View all Teachers"),
                        is_child=True
                    ),
                    register_sidebar_item(
                        order=1,
                        title=_("Accounting"),
                        url=reverse('admin:reports:teacher-accounting'),
                        is_active='/teachers-accountings' in request.path,
                        permissions=user.has_perm('users.view_teacher'),
                        comment=_("View Teachers Accounting's"),
                        is_child=True
                    ),
                ]
            ),
            register_sidebar_item(
                order=7,
                title=_("Admins"),
                url=reverse('admin:users:listing', args=['admins']),
                icon='<i class="fa-solid fa-user-shield fs-2"></i>',
                is_active='/admins' in request.path,
                permissions=user.has_perm('users.view_admin'),
                comment=_("View all Admins")
            ),
            # register_sidebar_item(
            #     order=8,
            #     title=_("Roles"),
            #     url=reverse('admin:authz:roles'),
            #     icon='<i class="fa-solid fa-user-tag fs-2"></i>',
            #     is_active='/roles' in request.path,
            #     permissions=user.has_perm('auth.view_roles'),
            #     comment=_("View all Roles")
            # ),
        ]
