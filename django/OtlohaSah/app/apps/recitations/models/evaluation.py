import uuid

from django.db import models
from django.utils.translation import gettext_lazy as _

from .recitations import Recitation
from .. import config
from ...records.models import Record


class Evaluation(models.Model):
    SEARCH_INDEX = {
        "fields": {
            "id": "A",
            "recitation__result": "B",
            "recitation__owner__username": "C",
            "recitation__owner__first_name": "C",
            "recitation__owner__last_name": "C",
            "recitation__owner__email": "C",
            "recitation__teacher__username": "C",
            "recitation__teacher__first_name": "C",
            "recitation__teacher__last_name": "C",
            "recitation__teacher__email": "C"
        }
    }

    def get_upload(self, filename):
        return 'recitations/{}/evaluations/{}'.format(self.recitation.uuid, self.uuid, filename)

    class Meta:
        verbose_name = _("Evaluation")
        verbose_name_plural = _("Evaluations")

    uuid = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    recitation = models.ForeignKey(Recitation, on_delete=models.CASCADE)

    # evaluation text
    note = models.CharField(max_length=400, verbose_name=_("Text"))
    # record
    record = models.OneToOneField(Record, on_delete=models.SET_NULL, null=True, blank=True, verbose_name=_("Record"))

    is_fault = models.BooleanField(_("Is Fault"), default=False)
    fault_type = models.CharField(max_length=50, choices=config.FAULT_TYPES, null=True, blank=True)
    error_text = models.TextField()
    position_from = models.IntegerField(null=True, blank=True)
    position_to = models.IntegerField(null=True, blank=True)
