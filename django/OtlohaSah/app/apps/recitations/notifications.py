from django.contrib.postgres.aggregates import ArrayAgg
from django.db.models import Q
from django.utils.translation import gettext as _

from apps.notifications.models import Notification
from apps.notifications.notifications import BaseNotification
from apps.users.models import User


class UserRecitationAddedToBoxNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS

    def get_target_name(self):
        return f'user_recitation_added_to_{self.instance.box_type}_box'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return _(f"Your recitation added to [{self.instance.box_type}] successfully.").format(
            sender=self.instance.name,
        )

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["body"] = self.pn_format_message(self.get_message())
        return message

    def pn_get_data(self):
        data = super().pn_get_data()
        data['object_id'] = str(self.sender.id)
        data['content_type'] = self.content_type.model
        return data


class UserAssignedYouAsFavoriteTeacherForRecitationNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'user_assigned_teacher_to_recitation'

    def get_message(self):
        return _("[{sender}] assigned you as a favorite teacher for a new recitation.").format(
            sender=self.sender,
        )

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("Assigned as favorite teacher for recitation.")
        message["body"] = self.pn_format_message(self.get_message())
        message["image"] = self.get_image_url(self.get_sender().profile_image)
        return message

    def get_sender(self):
        return self.sender

    def get_receivers(self):
        return [self.instance.teacher]


class UserRecitationDeletedSuccessfullyNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'user_recitation_deleted_recitation'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return _(f"Your recitation [{self.instance.name}] successfully.").format(
            sender=self.instance.name,
        )

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["body"] = self.pn_format_message(self.get_message())
        return message

    def pn_get_data(self):
        data = super().pn_get_data()
        data['object_id'] = str(self.sender.id)
        data['content_type'] = self.content_type.model
        return data

    def get_receivers(self):
        return [self.instance.owner]


class RecitationAddedToRemarkableRecitationsNotification(BaseNotification):
    via = ("database", "push_notifications")
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'added_to_remarkable_recitations'

    def get_target_name(self):
        return self.target_name

    def get_collapse_key(self):
        return "{}-{}".format(self.get_target_name(), self.instance.id)

    def get_message(self):
        return _("[{sender}] added new recitation to the {box}").format(
            sender=self.sender.get_full_name,
            box=_("remarkable box"),
            recitation=self.instance.name
        )

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("New Remarkable Recitation")
        message["body"] = self.pn_format_message(self.get_message())
        message["image"] = self.get_image_url(self.instance.owner.profile_image)
        return message

    def get_receivers(self):
        permissions = [
            "view_recitation", "add_recitation", "change_recitation", "delete_recitation"
        ]

        from apps.settings.utils import get_user_setting

        allow_opposite_gender = get_user_setting(
            self.instance.owner, 'display_remarkable_recitations_to_opposite_gender')

        filters = {
            'is_staff': False,
        }

        if not allow_opposite_gender:
            filters['gender'] = self.instance.owner.gender

        staff_filters = Q(is_staff=True) & Q(
            Q(user_permissions__codename__in=permissions) |
            Q(groups__permissions__codename__in=permissions) |
            Q(is_superuser=True)
        )

        combined_filters = Q(**filters) | staff_filters

        excludes = {'id': self.instance.owner_id}

        queryset = User.objects.filter(combined_filters).exclude(**excludes).distinct().annotate(
            notification_slugs=ArrayAgg('notifications_via_settings__slug',
                                        filter=Q(notifications_via_settings__is_active=True))
        ).values(
            'id', 'notification_slugs', 'language'
        )

        return queryset


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
        message["image"] = self.get_image_url(self.instance.owner.profile_image)

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


class RecitationRoomCreatedNotification(BaseNotification):
    via = ("push_notifications",)
    target_type = Notification.TARGET_TYPE_LISTING
    target_name = 'recitation_room_created'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.record.uuid)

    def get_message(self):
        if self.sender.is_a_teacher:
            return _("Teacher [{sender}] is evaluating your recitation '{recitation}'").format(
                sender=self.sender,
                recitation=self.instance.name
            )
        return _("Student [{sender}] sent '{recitation}' to be evaluated").format(
            sender=self.sender,
            recitation=self.instance.name
        )

    def get_title(self):
        return _("Recitation Is Being Evaluated") if self.sender.is_a_teacher else _("Recitation Evaluation Request")

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = self.get_title()
        message["body"] = self.pn_format_message(self.get_message())
        message["image"] = self.get_image_url(self.sender.profile_image)
        return message

    def to_database(self):
        return self.get_message()

    def pn_get_data(self):
        data = super().pn_get_data()
        data['room_id'] = str(self.instance.id)
        return data
