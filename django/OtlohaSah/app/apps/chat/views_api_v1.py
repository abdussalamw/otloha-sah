from django.db.models import Count, OuterRef, Subquery, F, Max
from django.http import Http404
from django.utils.translation import gettext as _
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.pagination import PageNumberPagination
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.chat.models import Room
from apps.chat.notifications import BaseRoomCreatedNotification, RecitationRoomCreatedNotification
from apps.chat.serializers import RecitationRoomSerializer, BaseRoomSerializer, RecitationMessageSerializer, \
    BaseMessageSerializer
from apps.recitation.models import Recitation


class RoomPagination(PageNumberPagination):
    page_size = 10  # Number of rooms per page
    page_size_query_param = 'page_size'
    max_page_size = 100


class RoomAPIView(APIView):
    permission_classes = (IsAuthenticated,)
    pagination_class = RoomPagination


    def check_room_type(self, room_type):
        if room_type not in list(dict(Room.ROOM_TYPES).keys()):
            raise Http404

    def get_room_serializer(self, room_type, *args, **kwargs):
        if room_type == Room.ROOM_TYPE_RECITATION:
            return RecitationRoomSerializer(*args, **kwargs)
        elif room_type == Room.ROOM_TYPE_NORMAL:
            return BaseRoomSerializer(*args, **kwargs)

    def get(self, request, room_type, *args, **kwargs):
        self.check_room_type(room_type)
        rooms = request.user.rooms.all()
        if room_type == Room.ROOM_TYPE_RECITATION:
            rooms = rooms.filter(room_type=Room.ROOM_TYPE_RECITATION)
            recitations = Recitation.objects.filter(
                pk__in=rooms.values_list('object_id', flat=True),
                evaluated_at__isnull=False)

            rooms_without_messages = rooms.filter(room_type=room_type).annotate(
                messages_count=Count('messages__pk'),
            ).filter(messages_count=0)

            recitations_query = Recitation.objects.filter(pk=OuterRef('object_id'))
            evaluated_rooms = rooms_without_messages.filter(
                object_id__in=recitations.values_list('pk', flat=True)
            ).annotate(sent_at=Subquery(recitations_query.values('evaluated_at')[:1]))

            unevaluated_rooms = rooms_without_messages.exclude(
                pk__in=evaluated_rooms.values_list('pk', flat=True)
            ).annotate(sent_at=F("created_at"))

            rooms_with_messages = rooms.exclude(
                pk__in=rooms_without_messages.values_list('pk', flat=True)
            ).annotate(sent_at=Max('messages__sent_at'))

            rooms_with_sent_messages = rooms_with_messages.filter(sent_at__isnull=False)
            rooms_with_not_sent_messages = rooms_with_messages.filter(
                sent_at__isnull=True
            ).annotate(sent_at=F("created_at"))

            rooms = list(evaluated_rooms) + list(unevaluated_rooms) + list(rooms_with_sent_messages) + list(
                rooms_with_not_sent_messages)

            rooms.sort(key=lambda x: x.sent_at, reverse=True)

        paginator = self.pagination_class()
        paginated_rooms = paginator.paginate_queryset(rooms, request)

        serializer = self.get_room_serializer(room_type, paginated_rooms, many=True, context={'user': request.user})
        return paginator.get_paginated_response(serializer.data)

    def post(self, request, room_type, *args, **kwargs):

        self.check_room_type(room_type)
        serializer = self.get_room_serializer(room_type, data=request.data, context={'user': request.user})
        if serializer.is_valid():
            room = serializer.save()

            if room_type == Room.ROOM_TYPE_RECITATION:
                room.notify(
                    RecitationRoomCreatedNotification,
                    sender=request.user,
                    receivers=room.peers(request.user)
                )
            elif room_type == Room.ROOM_TYPE_NORMAL:
                room.notify(
                    BaseRoomCreatedNotification,
                    sender=request.user,
                    receivers=room.peers(request.user)
                )

            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_422_UNPROCESSABLE_ENTITY)

    def delete(self, request, room_type, pk, *args, **kwargs):
        self.check_room_type(room_type)
        if room_type in [Room.ROOM_TYPE_RECITATION, Room.ROOM_TYPE_KHATMA]:
            return Response({"message": _("You can't delete this room!")}, status=status.HTTP_403_FORBIDDEN)

        room = get_object_or_404(Room, pk=pk)
        room.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class RoomDetailsAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get_room_serializer(self, room, *args, **kwargs):
        if room.room_type == Room.ROOM_TYPE_RECITATION:
            return RecitationRoomSerializer(instance=room, *args, **kwargs)
        elif room.room_type == Room.ROOM_TYPE_NORMAL:
            return BaseRoomSerializer(instance=room, *args, **kwargs)

    def get_messages_serializer(self, room, messages):
        if room.room_type == Room.ROOM_TYPE_RECITATION:
            return RecitationMessageSerializer(messages, many=True)
        return BaseMessageSerializer(messages, many=True)

    def user_can_view_room(self, user, room):
        permissions = [
            user in room.users.all(),
            room.room_type == Room.ROOM_TYPE_RECITATION and user in [
                room.content_object.teacher, room.content_object.owner
            ],
            room.room_type == Room.ROOM_TYPE_RECITATION and user == room.content_object.owner.favorite_teacher,
            user.is_a_teacher
        ]
        return any(permissions)

    def get(self, request, room_type, pk, *args, **kwargs):
        room = get_object_or_404(Room, pk=pk)
        if not self.user_can_view_room(request.user, room):
            return Response({
                "message": _("You are not allowed to access this room!")
            }, status=status.HTTP_403_FORBIDDEN)

        messages = room.messages.all()
        return Response({
            "room": self.get_room_serializer(room, context={"user": request.user}).data,
            "messages": self.get_messages_serializer(room, messages).data
        })
