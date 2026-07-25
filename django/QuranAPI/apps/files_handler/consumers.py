import json

from asgiref.sync import async_to_sync
from channels.generic.websocket import WebsocketConsumer


class ProcessProgressConsumer(WebsocketConsumer):
    room_group_name = 'process_progress'

    def connect(self):
        self.accept()
        async_to_sync(self.channel_layer.group_add)(self.room_group_name, self.channel_name)

    def disconnect(self, close_code):
        async_to_sync(self.channel_layer.group_discard)(self.room_group_name, self.channel_name)

    def receive(self, text_data=None, **kwargs):
        text_data_json = json.loads(text_data)
        message = text_data_json['message']
        async_to_sync(self.channel_layer.group_send)(
            self.room_group_name,
            {'type': 'send_progress', 'message': message}
        )

    def send_progress(self, event):
        message = event['message']
        self.send(text_data=json.dumps({
            'message': message
        }))
