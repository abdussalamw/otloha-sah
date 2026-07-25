from datetime import timedelta

import mutagen
from django.core.files.uploadedfile import UploadedFile
from django.db.models.signals import pre_save
from django.dispatch import receiver

from apps.recitations.models import Recitation


@receiver(signal=pre_save, sender=Recitation)
def has_record_pre_save_receiver(instance, update_fields, **kwargs):
    file_was_updated = False
    if hasattr(instance.record, 'file') and isinstance(instance.record.file, UploadedFile):
        file_was_updated = True

    if update_fields and "record" in update_fields:
        file_was_updated = True

    if file_was_updated:
        # read audio file metadata
        audio_info = mutagen.File(instance.record).info
        # set audio duration in seconds, so we can access it in database
        instance.duration = timedelta(seconds=audio_info.length)
