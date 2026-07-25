import json
import sys
import traceback

from asgiref.sync import async_to_sync
from channels.generic.websocket import WebsocketConsumer
from django.contrib.auth.models import AnonymousUser

from apps.notifications.serializers import BaseNotificationSerializer


def get_trace():
    parts = ["Traceback (most recent call last):\n"]
    parts.extend(traceback.format_stack(limit=25)[:-2])
    parts.extend(traceback.format_exception(*sys.exc_info())[1:])
    return "".join(parts)


class MainConsumer(WebsocketConsumer):
    def connect(self):
        if isinstance(self.scope['user'], AnonymousUser):
            self.close()

        self.user = self.scope['user']
        self.group_name = "{}-main-group".format(self.user.id)
        async_to_sync(self.channel_layer.group_add)(self.group_name, self.channel_name)
        self.accept()

    def disconnect(self, close_code):
        pass

    def receive(self, text_data=None, **kwargs):
        data = json.loads(text_data)
        method = getattr(self, data['type'])
        message = method(data)
        async_to_sync(self.channel_layer.group_send)(self.group_name, {
            "type": 'handle_send', "message": message
        })

    def handle_send(self, event):
        self.send(text_data=json.dumps(event['message']))

    # def rooms_updated(self, data):
    #     try:
    #         unseen_messages = self.user.seen_messages.filter(message__isnull=False, seen_at__isnull=True).exclude(
    #             message__is_sent=False)
    #
    #         self.send(text_data=json.dumps({
    #             "type": "rooms_updated",
    #             "message": {
    #                 "unseen_count": unseen_messages.count(),
    #             }
    #         }))
    #
    #         self.send(text_data=json.dumps({
    #             "type": "new_message",
    #             "message": data['message']['message']
    #         }))
    #     except Exception as e:
    #         print(e)
    #         print(get_trace())

    # def get_updates(self, data):
    #     try:
    #         unseen_messages = self.user.seen_messages.filter(message__isnull=False, seen_at__isnull=True).exclude(
    #             message__is_sent=False)
    #
    #         self.send(text_data=json.dumps({
    #             "type": "get_updates",
    #             "message": {
    #                 "unseen_count": unseen_messages.count(),
    #             }
    #         }))
    #     except Exception as e:
    #         print(e)
    #         print(get_trace())

    def progress_updated(self, data):
        self.send(text_data=json.dumps({
            "type": "progress_updated",
            "message": data['message']
        }))
