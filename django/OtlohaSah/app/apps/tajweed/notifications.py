from django.utils.translation import gettext

from apps.notifications.models import Notification
from apps.notifications.notifications import BaseNotification


class ApproveReservationNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'approve-reservation'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return gettext("You exam reservation approved successfully.")

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


class RejectReservationNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'reject-reservation'
    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return gettext("You exam reservation rejected.")

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
