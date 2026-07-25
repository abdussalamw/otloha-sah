from django.contrib.contenttypes.models import ContentType
from django.utils.translation import deactivate

from apps.notifications.models import Via
from .tasks import send_pn_multicast_message, send_email, send_database_notification


class BaseVia:
    name = None

    def __init__(self, notification):
        self.notification = notification

    def send(self):
        pass

    def check_receiver_via(self, receiver):
        receiver_via = receiver.notifications_via_settings.filter(slug=self.name)
        if receiver_via.exists():
            return receiver_via.first().is_active

        Via.objects.create(
            user=receiver,
            slug=self.name,
            is_active=True,
            name=dict(Via.VIA_CHOICES).get(self.name),
        )
        return True

    def group_receivers_by_language(self):
        pass


class DatabaseVia(BaseVia):
    name = Via.VIA_DATABASE

    def group_receivers_by_language(self):
        receivers_by_language = {}

        receivers = self.notification.get_receivers()
        # for backward compatibility we are validating for updated get receivers
        if any(receivers) and isinstance(receivers[0], dict) and 'notification_slugs' in receivers[0]:
            for receiver in receivers:
                if self.name in receiver['notification_slugs']:
                    language = receiver['language']

                    if language not in receivers_by_language:
                        receivers_by_language[language] = []

                    receivers_by_language[language].append(receiver['id'])

            return receivers_by_language

        # OLD APPROCH
        for receiver in receivers:
            if not self.check_receiver_via(receiver):
                continue

            language = receiver.language

            if language not in receivers_by_language:
                receivers_by_language[language] = []

            receivers_by_language[language].append(receiver.id)

        return receivers_by_language

    def send(self):
        receivers_by_language = self.group_receivers_by_language()

        content_type = ContentType.objects.get_for_model(self.notification.instance)

        for language, receivers_list in receivers_by_language.items():
            data = {
                "language": language,
                "receivers": receivers_list,
                "notification": {
                    "text": self.notification.to_database(),
                    "target_type": self.notification.target_type,
                    "target_name": self.notification.get_target_name(),
                    "content_type_id": content_type.id,
                    "object_id": self.notification.instance.id,
                    "sender_id": self.notification.get_sender().id if self.notification.get_sender() else None,
                    "template_name": self.notification.template_name
                },
            }
            if Via.VIA_PUSH_NOTIFICATIONS in self.notification.via:
                data['to_push_notification'] = True
                data['pn_notification'] = self.notification.to_push_notification()
                data['pn_data'] = self.notification.pn_get_data()
                data['collapse_key'] = self.notification.get_collapse_key()

            # send_database_notification.delay(**data)

            deactivate()


class EmailVia(BaseVia):
    name = Via.VIA_EMAIL

    def group_receivers_by_language(self):
        receivers_by_language = {}

        for receiver in self.notification.get_receivers():
            if not self.check_receiver_via(receiver):
                continue
            language = receiver.language
            if language not in receivers_by_language:
                receivers_by_language[language] = []

            receivers_by_language[language].append(receiver.email)

        return receivers_by_language

    def send(self):
        receivers_by_language = self.group_receivers_by_language()

        for language, receivers_list in receivers_by_language.items():
            receivers = [receiver.email for receiver in receivers_list]
            send_email.delay(
                language,
                receivers,
                self.notification.to_email(),
            )
        deactivate()


class SMSVia(BaseVia):
    def send(self):
        pass


class PushNotificationVia(BaseVia):
    name = Via.VIA_PUSH_NOTIFICATIONS

    def group_receivers_by_language(self):
        receivers_by_language = {}

        for receiver in self.notification.get_receivers():
            if not self.check_receiver_via(receiver):
                continue

            language = receiver.language
            tokens = list(receiver.push_notification_tokens.values_list('token', flat=True))
            if not len(tokens):
                continue

            if language not in receivers_by_language:
                receivers_by_language[language] = []

            receivers_by_language[language].append(tokens)

        return receivers_by_language

    def send(self):
        receivers_by_language = self.group_receivers_by_language()
        for language, tokens_list in receivers_by_language.items():
            send_pn_multicast_message.delay(
                language=language,
                tokens_list=tokens_list,
                notification=self.notification.to_push_notification(),
                pn_data=self.notification.pn_get_data(),
                collapse_key=self.notification.get_collapse_key()
            )

        deactivate()
