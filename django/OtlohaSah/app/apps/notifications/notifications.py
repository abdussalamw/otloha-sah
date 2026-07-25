from django.contrib.contenttypes.models import ContentType
from django.contrib.sites.models import Site
from django.templatetags.static import static
from django.utils.translation import gettext as _

from .models import Via
from .via import DatabaseVia, EmailVia, PushNotificationVia, SMSVia


class BaseNotification:
    VIA = {
        Via.VIA_DATABASE: DatabaseVia,
        Via.VIA_EMAIL: EmailVia,
        Via.VIA_SMS: SMSVia,
        Via.VIA_PUSH_NOTIFICATIONS: PushNotificationVia
    }

    via = ()
    target_type = None
    target_name = None
    template_name = "default"
    collapse_key = None

    def __init__(self, instance=None, sender=None, receivers=None):

        self.sender = sender

        self.receivers = receivers
        if receivers is None:
            self.receivers = []

        if instance:
            self.instance = instance
            self.content_type = ContentType.objects.get_for_model(self.instance)

    def get_collapse_key(self):
        return self.collapse_key

    def get_target_name(self):
        return self.target_name

    def get_sender(self):
        return self.sender

    def get_receivers(self):
        return self.receivers

    def send(self):
        via_classes = list(self.via)

        if Via.VIA_DATABASE in via_classes and Via.VIA_PUSH_NOTIFICATIONS in via_classes:
            via_classes.remove(Via.VIA_PUSH_NOTIFICATIONS)

        for item in via_classes:
            self.VIA[item](notification=self).send()

    def to_database(self):
        return None

    def to_sms(self):
        pass

    def to_email(self):
        return {
            "subject": "",
            "message": ""
        }

    def get_image_url(self, image):
        site = Site.objects.get(pk=1)
        return f"https://{site.domain}{image}"

    def pn_format_message(self, message):
        return message.replace("[", "").replace("]", "").replace("r'", "").replace("'", "")

    def pn_get_data(self):
        return {
            "target_type": self.target_type,
            "target_name": self.get_target_name(),
        }

    def to_push_notification(self):
        return {
            "title": _("Otloha Sah"),
            "body": "",
            "icon": self.get_image_url(static('images/app_icon.png'))
        }
