from django.utils.translation import gettext as _

from apps.notifications.models import Notification
from apps.notifications.notifications import BaseNotification


class BaseRoomCreatedNotification(BaseNotification):
    via = ("push_notifications",)
    target_type = Notification.TARGET_TYPE_LISTING
    target_name = 'room_created'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.uuid)

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = self.sender.get_full_name
        message["body"] = self.pn_format_message(_("[{sender}] added you to new chat room").format(
            sender=self.sender,
        ))
        message["image"] = self.get_image_url(self.sender.profile_image)
        return message

    def pn_get_data(self):
        data = super().pn_get_data()
        data['room_id'] = str(self.instance.id)
        return data


class RecitationRoomCreatedNotification(BaseNotification):
    via = ("push_notifications",)
    target_type = Notification.TARGET_TYPE_LISTING
    target_name = 'recitation_room_created'

    def get_collapse_key(self):
        return "{}-{}".format(self.target_name, self.instance.uuid)

    def get_message(self):
        if self.sender.is_a_teacher:
            return _("Teacher [{sender}] is evaluating your recitation r'{recitation}'").format(
                sender=self.sender,
                recitation=self.instance.content_object.name
            )
        return _("Student [{sender}] sent \"r'{recitation}'\" to be evaluated").format(
            sender=self.sender,
            recitation=self.instance.content_object.name
        )

    def get_title(self):
        return _("Recitation Is being evaluated") if self.sender.is_a_teacher else _("Recitation Evaluation Request")

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


class MessageCreatedNotification(BaseNotification):
    via = ("push_notifications",)
    target_type = Notification.TARGET_TYPE_LISTING
    target_name = 'message'

    def get_collapse_key(self):
        return f"{self.get_target_name()}-{self.instance.id}"

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = self.sender.get_full_name
        message["body"] = self.instance.text
        message["image"] = self.get_image_url(self.sender.profile_image)
        return message

    def pn_get_data(self):
        data = super().pn_get_data()
        data['room_id'] = str(self.instance.room.id)
        return data


class RoomClosedNotification(BaseNotification):
    via = ("push_notifications",)
    target_type = Notification.TARGET_TYPE_LISTING
    target_name = 'room_closed'

    def get_collapse_key(self):
        return f"{self.get_target_name()}-{self.instance.id}"

    def to_push_notification(self):
        message = super().to_push_notification()
        message["title"] = _("Chat Room Closed")
        message["body"] = self.pn_format_message(_("[{sender}] closed chat room [{room}]!").format(
            sender=self.sender.get_full_name,
            room=self.instance.name
        ))
        message["image"] = self.get_image_url(self.sender.profile_image)
        return message

    def pn_get_data(self):
        data = super().pn_get_data()
        data['room_id'] = str(self.instance.id)
        return data
