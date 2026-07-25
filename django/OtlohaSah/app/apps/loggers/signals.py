from django.db.models.signals import pre_save
from django.dispatch import receiver

from apps.loggers.models import APILog


@receiver(pre_save, sender=APILog)
def api_log_pre_save(sender, instance, **kwargs):
    instance.clean()
