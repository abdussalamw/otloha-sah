from django.utils.translation import gettext as _

from apps.chat.models import RoomUser
from apps.chat.serializers import RecitationRoomSerializer, BaseRoomSerializer, RecitationMessageSerializer, \
    BaseMessageSerializer


class MessageService:
    user = None
    room = None
    room_users = None

    def __init__(self, room, user, *args, **kwargs):
        self.room = room
        self.user = user
        self.room_users = RoomUser.objects.filter(room=self.room)

    def get_room_serializer(self, *args, **kwargs):
        if self.room.room_type == self.room.ROOM_TYPE_RECITATION:
            return RecitationRoomSerializer(room_type=self.room.room_type, *args, **kwargs)
        elif self.room.room_type == self.room.ROOM_TYPE_NORMAL:
            return BaseRoomSerializer(*args, **kwargs)

    def get_messages_serializer(self, *args, **kwargs):
        data = kwargs.get('data', {})
        if self.room.room_type == self.room.ROOM_TYPE_RECITATION and 'recitation' in data:
            return RecitationMessageSerializer(*args, **kwargs)
        return BaseMessageSerializer(*args, **kwargs)

    def list(self, **kwargs):
        return self.room.messages.filter(**kwargs).order_by('-sent_at', '-created_at')

    def add(self, data):
        data = {**data['message'], "room": self.room.pk}
        serializer = self.get_messages_serializer(data=data, context={"user": self.user})
        if serializer.is_valid():
            serializer.save()

            # rooms_updated(self.room_users, serializer.data)
            return {"type": "add_message", "message": serializer.data}
        return {"type": "form-errors", "message": serializer.errors}

    def remove(self, data):
        if not self.room.messages.filter(id=data['message']['id']):
            return {"type": "not_fount", "message": {"error": _("Message not found")}}
        message = self.room.messages.get(id=data['message']['id'])
        message.delete()
        # self.get_messages()
        return {"type": "delete_message", "message": data['message']}

    def edit(self, data):
        if not self.room.messages.filter(id=data['message']['id']):
            return {"type": "not_fount", "message": {"error": _("Message not found")}}
        message = self.room.messages.get(id=data['message']['id'])
        if self.user == message.user:
            serializer = self.get_messages_serializer(instance=message, data=data['message'])
            if serializer.is_valid():
                serializer.save()
                # self.get_messages()
                return {"type": "edit_message", "message": serializer.data}
            return {"type": "form-errors", "message": serializer.errors}
        return {"type": "not-allowed"}

    def typing(self, data):
        return {"type": "typing", "message": data['message']}
