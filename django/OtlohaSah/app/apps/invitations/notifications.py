from django.utils.translation import gettext

from apps.notifications.models import Notification
from apps.notifications.notifications import BaseNotification


class FriendRequestNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'friend_request'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return gettext("[{sender}] sent you a friend request").format(
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


class JoinEntityRequestNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'join_entity_request'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return gettext("[{sender}] sent you join request.").format(
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


class JoinKhatmaRequestNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'join_khatma_request'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return gettext("[{sender}] sent you join khatma request.").format(
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


class SupervisionRequestNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'supervision_request'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return gettext("[{sender}] sent you a supervision request.").format(
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


class MergeRequestNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'entity_merge_request'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return gettext("[{sender}] sent you a merge request.").format(
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


class AcceptResponseNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'accepted'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return gettext("[{sender}] Your request accepted successfully").format(
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


class RejectResponseNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'rejected'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return gettext("[{sender}] Your request rejected successfully.").format(
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


class DeleteResponseNotification(BaseNotification):
    via = (
        "database",
        "push_notifications"
    )
    target_type = Notification.TARGET_TYPE_DETAILS
    target_name = 'deleted'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.id)

    def get_message(self):
        return gettext("[{sender}] Your request accepted successfully.").format(
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
