from django.contrib.auth import get_user_model
from django.db import models
from django.utils.translation import gettext_lazy as _

from quran_api_client.models import Narration

UserModel = get_user_model()


class Progress(models.Model):
    user = models.ForeignKey(UserModel, on_delete=models.CASCADE)
    narration = models.ForeignKey(Narration, on_delete=models.CASCADE, verbose_name=_("Narration"))
    accepted = models.IntegerField(_("Accepted Recitations"), default=0)
    rejected = models.IntegerField(_("Rejected Recitations"), default=0)
    pending = models.IntegerField(_("Pending Recitations"), default=0)
    percentage = models.FloatField(_("Progress Percentage"), default=0)
