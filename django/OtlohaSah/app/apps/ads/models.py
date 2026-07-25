import uuid as uuid

from django.db import models
from django.urls import reverse
from django.utils.translation import gettext_lazy as _


class Ad(models.Model):
    def get_upload(self, filename):
        return 'promotions/{}/{}'.format(self.uuid, filename)

    class Meta:
        verbose_name = _('Ad')
        verbose_name_plural = _('Ads')

    uuid = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    title = models.CharField(_('Title'), max_length=255, )
    url = models.URLField(_('URL'), max_length=255, null=True, blank=True)
    image = models.ImageField(_('Image'), upload_to=get_upload)
    is_active = models.BooleanField(_('is Active'), default=True)
    created_at = models.DateTimeField(_('Created At'), auto_now_add=True)
    updated_at = models.DateTimeField(_('Updated At'), auto_now_add=True)

    def __str__(self):
        return self.title

    @property
    def get_edit_url(self):
        return reverse('admin:ads:update', args=[self.id])

    @property
    def get_toggle_active_url(self):
        return reverse('admin:ads:toggle-active', args=[self.id])

    def toggle_active(self):
        self.is_active = not self.is_active
        self.save()
        return self.is_active, _('Suspend') if self.is_active else _('Unsuspend')

    # @property
    # def get_delete_url(self):
    #     return reverse('admin:ads:delete', args=[self.id])
