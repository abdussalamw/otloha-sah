from uuid import uuid4

from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.db import models
from django.utils.translation import gettext_lazy as _

from apps.notifications.models import Notifying
from apps.records.models import Record
from apps.users.models import User


class RoomManager(models.Manager):
    def unseen_rooms(self, user):
        SeenBy.objects.filter(user=user, seen_at__isnull=True, message__isnull=True)
        return super().get_queryset()


class Room(Notifying):
    ROOM_TYPE_NORMAL = 'normal'
    ROOM_TYPE_RECITATION = 'recitation'
    ROOM_TYPE_KHATMA = 'khatma'
    ROOM_TYPES = (
        (ROOM_TYPE_NORMAL, _("Normal")),
        (ROOM_TYPE_RECITATION, _("Recitation")),
        (ROOM_TYPE_KHATMA, _("Khatma")),
    )

    class Meta:
        verbose_name = _("Room")
        verbose_name_plural = _("Rooms")

    objects = RoomManager()

    uuid = models.UUIDField(default=uuid4, editable=False, unique=True)
    name = models.CharField(max_length=255, verbose_name=_("Name"), null=True, blank=True, default=None)
    room_type = models.CharField(max_length=20, choices=ROOM_TYPES, default=ROOM_TYPE_NORMAL)
    users = models.ManyToManyField(User, through="RoomUser", related_name='rooms')
    owner = models.ForeignKey(User, on_delete=models.CASCADE, related_name='owned_rooms')
    seen_by = models.ManyToManyField(User, through="SeenBy", related_name='seen_rooms')
    is_closed = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True)

    content_type = models.ForeignKey(ContentType, on_delete=models.SET_NULL, blank=True, null=True)
    object_id = models.PositiveIntegerField(null=True, blank=True)
    content_object = GenericForeignKey()

    def __str__(self):
        return self.name or str(self.uuid)

    @property
    def is_group_room(self):
        return self.users.count() > 2

    @property
    def last_message(self):
        return self.messages.filter(is_sent=True).order_by('-sent_at').first()

    def unseen_messages(self, user):
        return SeenBy.objects.filter(room=self, user=user, seen_at__isnull=True)
        # self.messages.exclude(seen_by__user=user, is_sent=True, user=user)

    def peers(self, user):
        return self.users.exclude(pk=user.pk)


class RoomUser(models.Model):
    room = models.ForeignKey(Room, on_delete=models.CASCADE, related_name="room_users")
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="room_users")
    is_online = models.BooleanField(default=False)


class Message(Notifying):
    class Meta:
        verbose_name = _('Message')
        verbose_name_plural = _('Messages')

    room = models.ForeignKey(Room, on_delete=models.CASCADE, related_name="messages")
    reply_to = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name="replies")
    text = models.TextField(null=True, blank=True)
    record = models.ForeignKey(Record, on_delete=models.CASCADE, null=True, blank=True)

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="messages")
    seen_by = models.ManyToManyField(User, through='SeenBy', related_name='seen_by')

    is_sent = models.BooleanField(default=False)
    sent_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True)


class SeenBy(models.Model):
    class Meta:
        verbose_name = _('Message Seen')
        verbose_name_plural = _('Message Seen')

    room = models.ForeignKey(Room, on_delete=models.CASCADE, related_name="room_messages")
    message = models.ForeignKey(Message, on_delete=models.CASCADE, null=True, blank=True, default=None,
                                related_name="message_seen_by")
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="seen_messages")
    seen_at = models.DateTimeField(default=None, blank=True, null=True)
