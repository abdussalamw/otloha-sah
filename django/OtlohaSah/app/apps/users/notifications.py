from django.utils.translation import gettext as _

from apps.notifications.models import Notification
from apps.notifications.notifications import BaseNotification


class TeacherMarkedAsFavoriteNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'marked_as_favorite_teacher'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return _("[{sender}] marked you as favorite teacher").format(
            sender=self.sender,
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


class CertificationGrantedOrRevokedNotification(BaseNotification):
    via = ("database", "push_notifications")
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'certification_granted'

    def get_target_name(self):
        return 'certification_granted' if self.instance.is_certified else 'certification_revoked'

    def get_collapse_key(self):
        return "{}-{}".format(self.get_target_name(), self.instance.id)

    def get_message(self):
        message = _("Congratulations, you have been granted certification for {narration} narration") \
            if self.instance.is_certified \
            else _("your certification for {narration} narration has been revoked")

        return message.format(narration=self.instance.narration.name)

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("Certification Granted") if self.instance.is_certified else _("Certification Revoked")
        message["body"] = self.get_message()
        return message


class AccountBlockedNotification(BaseNotification):
    via = ("database", "push_notifications")
    target_type = Notification.TARGET_TYPE_DETAILS

    def get_target_name(self):
        return 'account_unblocked' if not self.instance.is_blocked else 'account_blocked'

    def get_collapse_key(self):
        return "{}-{}".format(self.get_target_name(), self.instance.id)

    def get_message(self):
        return _("Great news! Your account has been successfully unblocked."
                 " You can now access your account and resume using our services.") \
            if not self.instance.is_blocked \
            else _("We regret to inform you that your account has been blocked."
                   " Please contact our support team for further assistance")

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("Account Unblocked") \
            if not self.instance.is_blocked \
            else _("Account Blocked")
        message["body"] = self.get_message()
        return message


class TeacherApprovedNotification(BaseNotification):
    via = ("database", "push_notifications")
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'teacher_approved'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return _("Congratulations, your request to be a teacher has been approved")

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("Teacher Request Approved")
        message["body"] = self.get_message()
        return message


class TeacherPrivilegeGrantedOrRevokedNotification(BaseNotification):
    via = ("database", "push_notifications")
    target_type = Notification.TARGET_TYPE_DETAILS

    def get_target_name(self):
        return 'teacher_privilege_granted' if self.instance.teacherprofile.is_active else 'teacher_privilege_revoked'

    def get_collapse_key(self):
        return "{}-{}".format(self.get_target_name(), self.instance.id)

    def get_message(self):
        return _("Congratulations, your teacher account has been activated.") \
            if self.instance.teacherprofile.is_active \
            else _("Your status as a teacher has been temporarily suspended due to certain circumstances.")

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("Teacher Privilege Granted") if self.instance.teacherprofile.is_active else _(
            "Teacher Privilege Revoked")
        message["body"] = self.get_message()
        return message


class TeacherRejectedNotification(BaseNotification):
    via = ("database", "push_notifications")
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'teacher_rejected'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return _("Unfortunately, your request to be a teacher has been rejected.")

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("Teacher Request Rejected")
        message["body"] = self.get_message()
        return message


class TeacherVerseLevelEngagementNotification(BaseNotification):
    via = ("database", "push_notifications")
    target_type = Notification.TARGET_TYPE_DETAILS

    def get_target_name(self):
        return 'can_reply_on_every_verse_in_recitation' \
            if self.instance.teacherprofile.can_reply_on_every_verse_in_recitation \
            else 'cannot_reply_on_every_verse_in_recitation'

    def get_collapse_key(self):
        return "{}-{}".format(self.get_target_name(), self.instance.id)

    def get_message(self):
        return _("You can now reply to every verse in the recitation") \
            if self.instance.teacherprofile.can_reply_on_every_verse_in_recitation \
            else _("You can now reply only to the entire recitation, not individual verses.")

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("Verse-level Engagement Unlocked") \
            if self.instance.teacherprofile.can_reply_on_every_verse_in_recitation \
            else _("Verse-level Engagement Locked")
        message["body"] = self.get_message()
        return message


class PaymentCompletedNotification(BaseNotification):
    via = ("database", "push_notifications")
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'payment_completed'

    def get_collapse_key(self):
        return "{}-{}".format(self.get_target_name(), self.instance.id)

    def get_message(self):
        return _("Congratulations! your payment have been completed").format(
            narration=self.instance.narration.name,
        )

    def to_database(self):
        return self.get_message()

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("Payment Completed")
        message["body"] = self.get_message()
        return message
