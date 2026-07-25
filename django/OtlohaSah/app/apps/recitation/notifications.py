from django.contrib.postgres.aggregates import ArrayAgg
from django.db.models import Q
from django.utils.translation import gettext as _

from apps.notifications.models import Notification
from apps.notifications.notifications import BaseNotification
from apps.users.models import Admin, User


class RecitationAddedToGeneralNotification(BaseNotification):
    via = ("database", "push_notifications")
    target_type = Notification.TARGET_TYPE_DETAILS

    def get_target_name(self):
        return 'added_to_teachers_recitation' if self.instance.is_teacher_recitation else 'added_to_general_box'

    def get_collapse_key(self):
        return "{}-{}".format(self.get_target_name(), self.instance.id)

    def get_message(self):
        return _("[{sender}] added new recitation to the {box}").format(
            sender=self.sender.get_full_name,
            box=_('teachers recitations') if self.instance.is_teacher_recitation else _("general box")
        )

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("New Recitation")
        message["body"] = self.pn_format_message(self.get_message())
        message["image"] = self.get_image_url(self.sender.profile_image)
        return message

    def get_receivers(self):
        permissions = [
            "view_recitation", "add_recitation", "change_recitation", "delete_recitation"
        ]
        from apps.settings.utils import get_user_setting
        allow_opposite_gender = get_user_setting(
            self.instance.owner,
            'display_teacher_recitations_to_opposite_gender' if self.instance.is_teacher_recitation else
            'display_general_box_recitations_to_opposite_gender')

        filters = {
            **({'is_staff': False, } if
               self.instance.is_teacher_recitation
               else {'is_a_teacher': True,
                     'teachernarration__is_certified': True,
                     'teachernarration__narration_id': self.instance.narration_id,
                     'level__gte': self.instance.owner.level}),
            **({} if allow_opposite_gender else {'gender': self.instance.gender})
        }

        excludes = {
            'id': self.instance.owner_id if self.instance.is_teacher_recitation else None
        }

        staff_filters = Q(is_staff=True, user_permissions__codename__in=permissions)

        combined_filters = Q(**filters) | staff_filters

        queryset = (
            User.objects
            .filter(combined_filters)
            .exclude(**excludes)
            .annotate(
                notification_slugs=ArrayAgg('notifications_via_settings__slug',
                                            filter=Q(notifications_via_settings__is_active=True))
            )
            .values('id', 'password', 'last_login', 'is_superuser', 'first_name', 'last_name', 'is_staff',
                    'is_active', 'date_joined', 'rate', 'level', 'narration_id', 'recitation_method',
                    'allow_remarkable_recitations_to_public', 'allow_cross_gender_view', 'language',
                    'notification_slugs')
        )

        return queryset


class RecitationAddedToRemarkableRecitationsNotification(BaseNotification):
    via = ("database", "push_notifications")
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'added_to_remarkable_recitations'

    def get_collapse_key(self):
        return "{}-{}".format(self.get_target_name(), self.instance.id)

    def get_message(self):
        return _("[{owner}'s] recitation r'{recitation}' was added to remarkable recitations").format(
            owner=self.instance.owner.get_full_name,
            recitation=self.instance.name,
        )

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("New Remarkable Recitation")
        message["body"] = self.pn_format_message(self.get_message())
        message["image"] = self.get_image_url(self.get_sender().profile_image)
        return message

    def get_receivers(self):
        permissions = [
            "view_recitation", "add_recitation", "change_recitation", "delete_recitation"
        ]

        from apps.settings.utils import get_user_setting

        allow_opposite_gender = get_user_setting(
            self.instance.owner, 'display_remarkable_recitations_to_opposite_gender')

        filters = {
            **{'is_staff': False},
            **({} if allow_opposite_gender else {'gender': self.instance.gender})
        }
        staff_filters = Q(is_staff=True, user_permissions__codename__in=permissions)

        combined_filters = Q(**filters) | staff_filters

        excludes = {'id': self.instance.owner_id}

        queryset = User.objects.filter(**filters).exclude(**excludes)

        # if not allow_opposite_gender:
        #     queryset = queryset.filter(gender=self.instance.gender)
        #
        # results = (queryset | User.objects.filter(is_staff=True, user_permissions__codename__in=permissions)).distinct()

        return queryset


class RecitationEvaluatedNotification(BaseNotification):
    via = ("database", "push_notifications")
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'recitation_evaluated'

    def get_message(self):
        from apps.recitation.models import Recitation
        if self.instance.result == Recitation.RESULT_ACCEPTED:
            return _("[{sender}] accepted your recitation r'{recitation}'").format(
                sender=self.sender.get_full_name,
                recitation=self.instance.name
            )
        elif self.instance.result == Recitation.RESULT_REJECTED:
            return _("[{sender}] rejected your recitation r'{recitation}'").format(
                sender=self.sender.get_full_name,
                recitation=self.instance.name
            )

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        from apps.recitation.models import Recitation
        message = super().to_push_notification()
        message["title"] = _("Recitation Accepted") if self.instance.result == Recitation.RESULT_ACCEPTED else _(
            "Recitation Rejected")
        message["body"] = self.pn_format_message(self.get_message())
        message["image"] = self.get_image_url(self.sender.profile_image)
        return message


class RecitationReportedNotification(BaseNotification):
    via = ("database",)
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'recitation_reported'

    def get_message(self):
        return _("Teacher [{sender}] reported recitation r'{recitation}' of user [{owner}]").format(
            sender=self.instance.teacher.get_full_name,
            recitation=self.instance.name,
            owner=self.instance.owner.get_full_name
        )

    def to_database(self):
        return self.get_message()

    def get_receivers(self):
        return Admin.objects.all().distinct()

    def get_sender(self):
        return self.instance.teacher


class TeacherRatedRecitationNotification(BaseNotification):
    via = ("database", "push_notifications")
    target_type = Notification.TARGET_TYPE_DETAILS
    template_name = 'recitation_rated'

    def get_message(self):
        return _("you have got c'{rate}' for your recitation r'{recitation}'").format(
            rate=self.instance.teacher_rate,
            recitation=self.instance.name,
        )

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("Recitation Rated")
        message["body"] = self.pn_format_message(self.get_message())
        message["image"] = self.get_image_url(self.get_sender().profile_image)
        return message

    def get_sender(self):
        return self.instance.teacher

    def get_receivers(self):
        return [self.instance.owner]


class MarkedAsRemarkableNotification(BaseNotification):
    via = ("database", "push_notifications")
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'recitation_added_to_remarkable_box'

    def get_message(self):
        return _("[Congratulations], your recitation r'{recitation}' was added to remarkable recitations").format(
            recitation=self.instance.name,
        )

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("Recitation Marked as Remarkable")
        message["body"] = self.pn_format_message(self.get_message())
        message["image"] = self.get_image_url(self.get_sender().profile_image)
        return message

    def get_sender(self):
        return self.instance.teacher

    def get_receivers(self):
        return [self.instance.owner]
