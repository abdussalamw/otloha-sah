from django.db import models
from django.utils.translation import gettext_lazy as _
from rest_framework.exceptions import ValidationError

from apps.invitations import config
from apps.notifications.models import Notifying


class Invitation(Notifying):
    class Meta:
        verbose_name = _("Invitation")
        verbose_name_plural = _("Invitations")
        indexes = [
            models.Index(fields=['requester', 'requestee', 'invitation_type']),
        ]

    requester = models.PositiveIntegerField(verbose_name='invitations_sent')
    requester_type = models.CharField(max_length=32, choices=config.INVITATION_USER_TYPES,
                                      default=config.INVITATION_USER_TYPE_USER)
    requestee = models.PositiveIntegerField(verbose_name='invitations_received')
    requestee_type = models.CharField(max_length=32, choices=config.INVITATION_USER_TYPES,
                                      default=config.INVITATION_USER_TYPE_USER)

    invitation_type = models.CharField(max_length=50, choices=config.INVITATION_TYPES)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True)

    def __str__(self):
        return f"{self.requester} -> {self.requestee}"


class BlockList(models.Model):
    class Meta:
        verbose_name = _("BlockList")
        verbose_name_plural = _("BlockLists")
        indexes = [
            models.Index(fields=['blocker', 'blocked']),
        ]

    blocker = models.PositiveIntegerField(verbose_name='blocking_user')
    blocker_type = models.CharField(max_length=32, choices=config.INVITATION_USER_TYPES,
                                    default=config.INVITATION_USER_TYPE_USER)
    blocked = models.PositiveIntegerField(verbose_name='blocked_user')
    blocked_type = models.CharField(max_length=32, choices=config.INVITATION_USER_TYPES,
                                    default=config.INVITATION_USER_TYPE_USER)

    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)

    def clean(self):
        self.validate_unique_block()

    def validate_unique_block(self):
        if BlockList.objects.filter(blocker=self.blocker, blocked=self.blocked).exclude(pk=self.pk).exists():
            raise ValidationError('This user is already blocked.')

    def __str__(self):
        return f"{self.blocker} -> {self.blocked}"


class BanedInvitation(models.Model):
    class Meta:
        verbose_name = _("RequestBlock")
        verbose_name_plural = _("RequestBlocks")
        indexes = [
            models.Index(fields=['blocker', 'blocked']),
        ]

    blocker = models.PositiveIntegerField(verbose_name='blocking_user')
    blocker_type = models.CharField(max_length=32, choices=config.INVITATION_USER_TYPES,
                                    default=config.INVITATION_USER_TYPE_USER)
    blocked = models.PositiveIntegerField(verbose_name='blocked_user')
    blocked_type = models.CharField(max_length=32, choices=config.INVITATION_USER_TYPES,
                                    default=config.INVITATION_USER_TYPE_USER)
    invitation_type = models.CharField(max_length=50, choices=config.INVITATION_TYPES)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)

    def clean(self):
        self.validate_unique_block()

    def validate_unique_block(self):
        if BanedInvitation.objects.filter(blocker=self.blocker, blocked=self.blocked).exclude(pk=self.pk).exists():
            raise ValidationError('This user is already blocked.')

    def __str__(self):
        return f"{self.blocker} -> {self.blocked}"

