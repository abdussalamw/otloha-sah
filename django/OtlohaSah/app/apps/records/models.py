import uuid as uuid

from django.contrib.auth import get_user_model
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.db import models

UserModel = get_user_model()


class Record(models.Model):
    def get_upload(self, filename):
        return 'records/{}/{}'.format(self.uuid, filename)

    class Meta:
        ordering = ('created_at',)

    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE, blank=True, null=True)
    object_id = models.PositiveIntegerField(null=True)
    content_object = GenericForeignKey()

    uuid = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    record = models.FileField(upload_to=get_upload, null=True, blank=True)
    wave = models.FileField(upload_to=get_upload, null=True, blank=True)
    duration = models.DurationField(null=True, blank=True)

    private = models.BooleanField(default=False)
    allowed_users = models.ManyToManyField(UserModel)
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True)
