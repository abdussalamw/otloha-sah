import uuid as uuid
from datetime import *

from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.db import models
from django.db.models.signals import post_delete
from django.dispatch import receiver
from django.utils.translation import gettext_lazy as _
from translation.models import TranslatableModel

from apps.files_handler.custom_model_fields import GenericFileField


class File(models.Model):
    def get_upload_to(self, filename):
        return 'files/{}/{}'.format(self.uuid, filename)

    STATUS_PENDING = "pending"
    STATUS_PROCESSING = "processing"
    STATUS_PROCESSED = "processed"
    STATUS_CHOICES = (
        (STATUS_PENDING, _("Pending")),
        (STATUS_PROCESSING, _("Processing")),
        (STATUS_PROCESSED, _("Processed")),
    )
    TYPE_IMPORT_CSV = "import_csv"
    TYPE_IMPORT_ZIP = "import_zip"
    PROCESS_TYPES = (
        (TYPE_IMPORT_ZIP, _("Import Zip")),
        (TYPE_IMPORT_CSV, _("Import CSV")),
    )

    uuid = models.UUIDField(default=uuid.uuid4, editable=False)
    file = GenericFileField(upload_to=get_upload_to, max_upload_size=429916160,
                            content_types=['application/vnd.ms-excel', 'text/csv', 'application/zip',
                                           'application/x-7z-compressed', 'application/vnd.rar'],
                            verbose_name=_('file'))
    file_name = models.CharField(null=True, blank=True, max_length=200, verbose_name=_('File Name'))
    status = models.CharField(max_length=50, verbose_name=_('Status'), choices=STATUS_CHOICES, default=STATUS_PENDING)
    is_processed = models.BooleanField(default=False, verbose_name=_('Is Processed'))
    process_name = models.CharField(max_length=50, verbose_name=_('Process Name'), default=None, null=True, blank=True)
    process_type = models.CharField(max_length=50, choices=PROCESS_TYPES, default=TYPE_IMPORT_ZIP,
                                    verbose_name=_('Process Type'))
    created_at = models.DateTimeField(auto_now_add=True, verbose_name=_('created at'))

    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE, blank=True, null=True)
    object_id = models.PositiveIntegerField(null=True)
    content_object = GenericForeignKey('content_type', 'object_id')

    columns = models.JSONField(verbose_name=_('columns'), null=True, blank=True)
    user_choice_columns = models.JSONField(verbose_name=_('User Columns'), null=True, blank=True)

    def __str__(self):
        return self.file_name if self.file_name else self.file.path


@receiver(post_delete, sender=File)
def post_save_image(sender, instance, *args, **kwargs):
    try:
        instance.file.delete(save=False)
    except:
        pass
