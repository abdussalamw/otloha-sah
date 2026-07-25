from collections.abc import Iterable

from django.contrib.contenttypes.fields import GenericForeignKey, GenericRelation
from django.db import models
from django.utils.translation import gettext_lazy as _


class Via(models.Model):
    VIA_DATABASE = 'database'
    VIA_EMAIL = 'email'
    VIA_SMS = 'sms'
    VIA_PUSH_NOTIFICATIONS = 'push_notifications'
    VIA_CHOICES = (
        (VIA_DATABASE, _("Normal Notifications")),
        (VIA_EMAIL, _('Email Notifications')),
        (VIA_SMS, _("SMS Notifications")),
        (VIA_PUSH_NOTIFICATIONS, _("Push Notifications")),
    )

    class Meta:
        verbose_name = _('Via')
        verbose_name_plural = _('Via')
        constraints = [
            models.UniqueConstraint(fields=['user', 'slug'], name='unique_user_slug'),
        ]

    name = models.CharField(max_length=50, choices=VIA_CHOICES, verbose_name=_('Name'))
    slug = models.SlugField(max_length=50, verbose_name=_('Slug'))
    is_active = models.BooleanField(default=True)
    user = models.ForeignKey(
        'users.User',
        default=None,
        null=True,
        blank=True,
        on_delete=models.CASCADE,
        related_name='notifications_via_settings',
        verbose_name=_('User'))

    def __str__(self):
        return self.name


class NotificationManager(models.Manager):
    def unseen(self):
        return self.filter(is_seen=False)

    def seen(self):
        return self.filter(is_seen=True)


class Notification(models.Model):
    objects = NotificationManager()

    TARGET_TYPE_LISTING = 'listing'
    TARGET_TYPE_DETAILS = 'details'
    TARGET_TYPES = (
        (TARGET_TYPE_LISTING, TARGET_TYPE_LISTING),
        (TARGET_TYPE_DETAILS, TARGET_TYPE_DETAILS)
    )

    class Meta:
        verbose_name = _('Notification')
        verbose_name_plural = _('Notifications')
        ordering = ['-created_at']
        constraints = [
            models.UniqueConstraint(fields=['user', 'patch_id'], name='unique_user_patch'),
        ]

    text = models.TextField(verbose_name=_('Text'))
    content_type = models.ForeignKey('contenttypes.ContentType', on_delete=models.CASCADE,
                                     verbose_name=_('Content Type'))
    object_id = models.PositiveIntegerField(verbose_name=_('Object ID'))
    content_object = GenericForeignKey('content_type', 'object_id')

    patch_id = models.CharField(_('Patch id'), max_length=255, null=True, blank=True)

    template_name = models.CharField(max_length=255, default='default')
    user = models.ForeignKey('users.User', related_name='notification_receiver', on_delete=models.CASCADE,
                             verbose_name=_('Receiver'))
    sender = models.ForeignKey('users.User', on_delete=models.CASCADE, default=None, null=True, blank=True,
                               verbose_name=_('Sender'))
    target_type = models.CharField(max_length=20, choices=TARGET_TYPES, default=None, null=True, blank=True)
    target_name = models.CharField(max_length=255, default=None, null=True, blank=True)
    is_seen = models.BooleanField(default=False, verbose_name=_('Is seen'))
    is_read = models.BooleanField(default=False, verbose_name=_('Is read'))
    created_at = models.DateTimeField(auto_now_add=True, verbose_name=_('Created at'))

    def __str__(self):
        return self.text

    @property
    def number_of_unseen(self):
        return Notification.objects.unseen().count()

    def mark_as_read(self):
        self.is_read = True
        self.save()


class Notifying(models.Model):
    class Meta:
        abstract = True

    notifications = GenericRelation(Notification, related_query_name='%(class)s_notifications')

    def notify(self, notification, receivers=None, sender=None):
        if receivers is None:
            receivers = []
        if not isinstance(receivers, Iterable):
            receivers = [receivers]
        notification(instance=self, receivers=receivers, sender=sender).send()

    @property
    def get_admin_listing_url(self):
        return "#"

    @property
    def get_site_listing_url(self):
        return "#"


class PushNotificationToken(models.Model):
    class Meta:
        verbose_name = _("Push Notifications Token")
        verbose_name_plural = _("Push Notifications Tokens")

    user = models.ForeignKey('users.User', on_delete=models.CASCADE, verbose_name=_('User'),
                             related_name="push_notification_tokens")
    token = models.TextField(_('Token'))
    device_name = models.CharField(max_length=255, verbose_name=_("Device Name"))
