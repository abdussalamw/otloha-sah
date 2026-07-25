from base_template.utils import register_sidebar_item
from django.apps import AppConfig
from django.urls import reverse
from django.utils.translation import gettext as _


class TajweedConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    default_app_config = 'tajweed.apps.TajweedConfig'
    name = 'apps.tajweed'

    def ready(self):
        from . import signals  # noqa

    def get_admin_sidebar(self, request):
        user = request.user
        return [
            register_sidebar_item(
                order=2,
                title=_("Tajweed"),
                icon='<i class="fa-solid fa-person-chalkboard fs-2"></i>',
                is_active='/tajweed' in request.path,
                permissions=any([
                    user.has_perm('tajweed.view_level'),
                    user.has_perm('tajweed.view_lesson'),
                    user.has_perm('tajweed.view_calendar-slot'),
                    user.has_perm('tajweed.view_exam-reservation'),
                    user.has_perm('tajweed.view_user-level-passed'),
                ]),
                children=[
                    register_sidebar_item(
                        order=0,
                        title=_("Levels"),
                        url=reverse('admin:tajweed:levels:listing'),
                        is_active=reverse('admin:tajweed:levels:listing') == request.path,
                        permissions=user.has_perm('users.view_level'),
                        comment=_("View Tajweed Levels"),
                        is_child=True
                    ),
                    register_sidebar_item(
                        order=1,
                        title=_("Lessons"),
                        url=reverse('admin:tajweed:lessons:listing'),
                        is_active=reverse('admin:tajweed:lessons:listing') == request.path,
                        permissions=user.has_perm('tajweed.view_lesson'),
                        comment=_("View Tajweed Lesson"),
                        is_child=True
                    ),
                    register_sidebar_item(
                        order=2,
                        title=_("Calendar Slots"),
                        url=reverse('admin:tajweed:calendar-slots:listing'),
                        is_active=reverse('admin:tajweed:calendar-slots:listing') == request.path,
                        permissions=user.has_perm('admin:tajweed.view_calendar-slots'),
                        comment=_("View Tajweed Calendar Slots"),
                        is_child=True
                    ),
                    register_sidebar_item(
                        order=3,
                        title=_("Exam Reservations"),
                        url=reverse('admin:tajweed:exam-reservations:listing'),
                        is_active=reverse('admin:tajweed:exam-reservations:listing') == request.path,
                        permissions=user.has_perm('auth.view_exam-reservations'),
                        comment=_("View Tajweed Exam Reservations"),
                        is_child=True
                    ),
                    register_sidebar_item(
                        order=4,
                        title=_("User Level Passed"),
                        url=reverse('admin:tajweed:user-level-passed:listing'),
                        is_active=reverse('admin:tajweed:user-level-passed:listing') == request.path,
                        permissions=user.has_perm('tajweed.view_user-level-passed'),
                        comment=_("View Tajweed User Level Passed"),
                        is_child=True
                    ),

                ]
            ),
        ]
