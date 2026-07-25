from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.db import models
from django.utils.translation import gettext_lazy as _

from .user import User


class Invitation(models.Model):
    INVITATION_TYPE_FRIEND_REQUEST = 'friend_request'
    INVITATION_TYPE_REQUEST_TO_JOIN_ENTITY = 'request_to_join_entity'
    INVITATION_TYPE_REQUEST_SUPERVISION = 'request_supervision'
    INVITATION_TYPE_REQUEST_MERGE = 'request_merge'
    INVITATION_TYPES = (
        (INVITATION_TYPE_REQUEST_TO_JOIN_ENTITY, _("Request to join entity")),
        (INVITATION_TYPE_REQUEST_SUPERVISION, _("Request supervision")),
        (INVITATION_TYPE_REQUEST_MERGE, _("Request to merge")),
        (INVITATION_TYPE_FRIEND_REQUEST, _("Friend request")),
    )

    STATUS_PENDING = "pending"
    STATUS_REJECTED = "rejected"
    STATUS_ACCEPTED = "accepted"
    STATUS_CHOICES = (
        (STATUS_PENDING, _("Pending")),
        (STATUS_REJECTED, _("Rejected")),
        (STATUS_ACCEPTED, _("Accepted"))
    )

    class Meta:
        verbose_name = _("Invitation")
        verbose_name_plural = _("Invitations")
        default_permissions = []

    addresser = models.ForeignKey(User, on_delete=models.CASCADE, related_name="addresser")
    addressee = models.ForeignKey(User, on_delete=models.CASCADE, related_name="addressee")
    invitation_type = models.CharField(max_length=255, choices=INVITATION_TYPES)
    status = models.CharField(max_length=255, choices=STATUS_CHOICES)
    prevent_upcoming_invitations = models.BooleanField(default=False)
    content_type = models.ForeignKey(ContentType, on_delete=models.SET_NULL, blank=True, null=True)
    object_id = models.PositiveIntegerField(null=True, blank=True)
    content_object = GenericForeignKey()
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
