import json
import sys
import traceback

from asgiref.sync import sync_to_async
from channels.db import database_sync_to_async
from channels.generic.websocket import AsyncWebsocketConsumer
from django.contrib.auth.models import AnonymousUser
from django.utils.timezone import now
from django.utils.translation import gettext as _

from apps.chat.models import Room, SeenBy, RoomUser
from apps.chat.notifications import MessageCreatedNotification, RoomClosedNotification
from apps.chat.serializers import RecitationRoomSerializer, BaseRoomSerializer, BaseMessageSerializer, \
    RecitationMessageSerializer
from apps.settings.utils import get_setting
from apps.users.models import User


def get_trace():
    parts = ["Traceback (most recent call last):\n"]
    parts.extend(traceback.format_stack(limit=25)[:-2])
    parts.extend(traceback.format_exception(*sys.exc_info())[1:])
    return "".join(parts)


ROOM_SERIALIZER_CHOICES = {
    Room.ROOM_TYPE_RECITATION: RecitationRoomSerializer,
    Room.ROOM_TYPE_NORMAL: BaseRoomSerializer
}


class AsyncSerializerHelper:

    @staticmethod
    def get_room_serializer(room_type, *args, **kwargs):
        return ROOM_SERIALIZER_CHOICES[room_type](*args, **kwargs)

    @staticmethod
    @sync_to_async
    def serialize_room(room, user):
        return AsyncSerializerHelper.get_room_serializer(
            room_type=room.room_type, instance=room, context={"user": user}).data

    @staticmethod
    def get_messages_serializer(room, *args, **kwargs):
        data = kwargs.get('data', {})
        if room.room_type == Room.ROOM_TYPE_RECITATION and 'recitation' in data:
            return RecitationMessageSerializer(*args, **kwargs)
        return BaseMessageSerializer(*args, **kwargs)

    @staticmethod
    @sync_to_async
    def serialize_messages(room, messages):
        return AsyncSerializerHelper.get_messages_serializer(room=room, instance=messages, many=True).data

    @staticmethod
    @sync_to_async
    def serialize_message(room, message):
        return AsyncSerializerHelper.get_messages_serializer(room=room, instance=message).data


class AsyncDatabaseHelper:
    @staticmethod
    @database_sync_to_async
    def get_user(**kwargs):
        return User.objects.get(**kwargs)

    @staticmethod
    @database_sync_to_async
    def get_room(**kwargs):
        return Room.objects.get(**kwargs)

    @staticmethod
    @database_sync_to_async
    def mark_room_as_seen(room, user):
        SeenBy.objects.filter(user=user, room=room, seen_at__isnull=True).update(seen_at=now())

    @staticmethod
    @database_sync_to_async
    def get_room_users(room):
        room_users = RoomUser.objects.filter(room=room)
        users = set()
        for room_user in room_users:
            users.add(room_user.user)
        return users

    @staticmethod
    @database_sync_to_async
    def get_all_messages(user, room):
        queryset = room.messages.all()
        if room.room_type == Room.ROOM_TYPE_RECITATION and not user.is_a_teacher:
            queryset = queryset.filter(is_sent=True)

        return queryset.order_by('sent_at', 'created_at')

    @staticmethod
    @database_sync_to_async
    def create_message(room, user, data):
        try:
            if room.room_type == Room.ROOM_TYPE_RECITATION:
                recitation = room.content_object
                if (recitation.teacher.teacherprofile.teacher_type == 'paid'
                        and not recitation.conversation_started
                        and room.messages.count() >= get_setting("max_number_of_replies_for_paid_teacher")):
                    return {
                        "type": "form_errors",
                        "message": {
                            "non_field_errors": [_('You have exceeded the max number of replies for a paid teacher')]
                        }
                    }, None
            data = {**data, "room": room.pk}
            serializer = AsyncSerializerHelper.get_messages_serializer(room=room, data=data, context={"user": user})
            if serializer.is_valid():
                message = serializer.save()
                return {"type": "add_message", "message": serializer.data}, message

            return {"type": "form_errors", "message": serializer.errors}, None
        except Exception as e:
            print(e)
            print(get_trace())

    @staticmethod
    def check_message_exists(room, message_id):
        message = room.messages.filter(id=message_id)
        if not message.exists():
            return False, {"type": "not_found", "message": {"error": _("Message not found")}}
        return True, message.first()

    @staticmethod
    @database_sync_to_async
    def update_message(room, user, data):
        try:
            exists, message = AsyncDatabaseHelper.check_message_exists(room, data['id'])
            if not exists:
                return message, None
            if user != message.user:
                return {
                    "type": "form_errors",
                    "message": {
                        "non_field_errors": [_('You are not allowed to delete the messages you don\'t own!')]
                    }
                }, None
            serializer = AsyncSerializerHelper.get_messages_serializer(
                room=room, data=data, instance=message, context={"user": user}
            )
            if serializer.is_valid():
                message = serializer.save()
                return {"type": "edit_message", "message": serializer.data}, message

            return {"type": "form_errors", "message": serializer.errors}, None
        except Exception as e:
            print(e)
            print(get_trace())

    @staticmethod
    @database_sync_to_async
    def delete_message(room, user, message_id):
        try:
            exists, message = AsyncDatabaseHelper.check_message_exists(room, message_id)
            if not exists:
                return message
            if user != message.user:
                return {
                    "type": "form_errors",
                    "message": {
                        "non_field_errors": [_('You are not allowed to delete the messages you don\'t own!')]
                    }
                }
            message.delete()
            return {"type": "delete_message", "message": {"id": message_id}}
        except Exception as e:
            print(e)
            print(get_trace())

    @staticmethod
    @database_sync_to_async
    def close_room(room, user):
        if room.room_type == Room.ROOM_TYPE_RECITATION and user != room.content_object.teacher:
            return {
                "type": "form_errors",
                "message": {
                    "non_field_errors": [
                        _('You are not allowed to close the room, the teacher only can close the room')
                    ]
                }
            }
        elif room.room_type == Room.ROOM_TYPE_NORMAL and user != room.owner:
            return {
                "type": "form_errors",
                "message": {
                    "non_field_errors": [
                        _('You are not allowed to close the room, the room owner only can close the room')
                    ]
                }
            }

        if room.is_closed:
            return {"type": "form_error", "message": {"message": _("room is already closed")}}

        room.is_closed = True
        room.save()

        if room.room_type == Room.ROOM_TYPE_RECITATION:
            room.content_object.closed_at = now()
            room.content_object.is_closed = True
            room.content_object.save()

        return {"type": 'close_room', "message": {'message': _("Chat room closed!")}}

    @staticmethod
    @database_sync_to_async
    def notify_offline_users_with_new_message(user, room_users, online_users, message):
        try:
            offline_users = [user for user in room_users if user.id not in online_users]
            message.notify(MessageCreatedNotification, sender=user, receivers=offline_users)
        except Exception as e:
            print(e)
            print(get_trace())

    @staticmethod
    @database_sync_to_async
    def notify_users_with_closed_group(room, user, room_users):
        try:
            room.notify(RoomClosedNotification, sender=user, receivers=room_users)
        except Exception as e:
            print(e)
            print(get_trace())


class ChatRoomConsumer(AsyncWebsocketConsumer):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.room_type = None
        self.room_uuid = None
        self.group_name = None
        self.user = None
        self.room = None
        self.room_users = set()
        self.connected_users = set()
        self.messages = None

    @sync_to_async
    def check_room_accessibility(self):
        return (
                self.room_type == Room.ROOM_TYPE_RECITATION
                and (not self.room.content_object.evaluated_at and self.user != self.room.content_object.teacher)
        ) or not self.user in self.room_users

    async def set_room_variables(self):
        self.room_type = self.scope['url_route']['kwargs']['room_type']
        self.room_uuid = self.scope['url_route']['kwargs']['room_uuid']
        self.group_name = f"room-{self.room_type}-{self.room_uuid}"
        self.user = await AsyncDatabaseHelper.get_user(id=self.scope['user'].id)
        self.room = await AsyncDatabaseHelper.get_room(uuid=self.room_uuid)

    async def connect(self):
        try:
            if not isinstance(self.scope['user'], AnonymousUser):
                await self.set_room_variables()

                if self.room.is_closed:
                    await self.close()

                self.room_users = await AsyncDatabaseHelper.get_room_users(self.room)

                if await self.check_room_accessibility():
                    await self.close()

                else:
                    await self.channel_layer.group_add(self.group_name, self.channel_name)
                    await self.accept()
                    self.messages = await AsyncDatabaseHelper.get_all_messages(self.user, self.room)
                    await AsyncDatabaseHelper.mark_room_as_seen(self.room, self.user)
                    self.connected_users.add(self.user.id)

                    serialized_room = await AsyncSerializerHelper.serialize_room(self.room, self.user)
                    serialized_messages = await AsyncSerializerHelper.serialize_messages(self.room, self.messages)

                    await self.send(text_data=json.dumps({
                        "type": "initialize",
                        "message": {
                            "room": serialized_room,
                            "messages": serialized_messages
                        }
                    }))

        except Exception as e:
            print(e)
            print(get_trace())

    async def disconnect(self, close_code):
        if self.user.id in self.connected_users:
            self.connected_users.remove(self.user.id)

        await self.channel_layer.group_discard(self.group_name, self.channel_name)

    async def receive(self, text_data=None, **kwargs):
        try:
            data = json.loads(text_data)
            message_type = data.get('type')
            message = data.get("message")

            if message_type == 'typing':
                await self.channel_layer.group_send(self.group_name, {'type': 'typing', "message": message})

            elif message_type == 'online_users':
                await self.channel_layer.group_send(self.group_name, {'type': 'online_users', "message": message})

            elif message_type == 'add_message':
                result, message = await AsyncDatabaseHelper.create_message(room=self.room, user=self.user, data=message)
                if result.get('type') == 'form_errors':
                    await self.send(text_data=json.dumps(result))
                else:
                    await self.channel_layer.group_send(self.group_name, result)
                    if message and message.is_sent:
                        await AsyncDatabaseHelper.notify_offline_users_with_new_message(self.user, self.room_users,
                                                                                        self.connected_users,
                                                                                        message)

            elif message_type == 'delete_message':
                result = await AsyncDatabaseHelper.delete_message(self.room, self.user, message['id'])
                if result.get('type') == 'not_found' or result.get('type') == 'form_error':
                    await self.send(text_data=json.dumps(result))
                else:
                    self.messages = await AsyncDatabaseHelper.get_all_messages(self.user, self.room)
                    await self.channel_layer.group_send(self.group_name, result)

            elif message_type == 'edit_message':
                result, message = await AsyncDatabaseHelper.update_message(room=self.room, user=self.user, data=message)
                if result.get('type') == 'not_found' or result.get('type') == 'form_error':
                    await self.send(text_data=json.dumps(result))
                else:
                    await self.channel_layer.group_send(self.group_name, result)

            if message_type == 'close_room':
                result = await AsyncDatabaseHelper.close_room(room=self.room, user=self.user)
                if result.get('type') == 'form_errors':
                    await self.send(text_data=json.dumps(result))
                else:
                    await self.channel_layer.group_send(self.group_name, result)
                    await  AsyncDatabaseHelper.notify_users_with_closed_group(
                        room=self.room, user=self.user, room_users=self.room_users
                    )
                    await self.channel_layer.group_discard(self.group_name, self.channel_name)

        except Exception as e:
            print(e)
            print(get_trace())

    async def online_users(self, event):
        await self.send(text_data=json.dumps({'type': 'online_users', 'message': event['message']}))

    async def typing(self, event):
        await self.send(text_data=json.dumps({'type': 'online_users', 'message': event['message']}))

    async def form_errors(self, event):
        await self.send(text_data=json.dumps({'type': 'form_errors', 'message': event['message']}))

    async def add_message(self, event):
        await self.send(text_data=json.dumps({'type': 'add_message', 'message': event['message']}))

    async def not_found(self, event):
        await self.send(text_data=json.dumps({'type': 'close_room', 'message': event['message']}))

    async def delete_message(self, event):
        await self.send(text_data=json.dumps({'type': 'delete_message', 'message': event['message']}))

    async def edit_message(self, event):
        await self.send(text_data=json.dumps({'type': 'edit_message', 'message': event['message']}))

    async def close_room(self, event):
        await self.send(text_data=json.dumps({'type': 'close_room', 'message': event['message']}))
