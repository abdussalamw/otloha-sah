from dj_translation.models import TranslationField
from django.contrib.auth import get_user_model
from django.db import models
from django.db.models import F, CheckConstraint, Q
from django.utils.translation import gettext as _

from apps.recitations.models import Recitation

UserModel = get_user_model()


class ReportReason(models.Model):
    class Meta:
        verbose_name = _("Reason")
        verbose_name_plural = _("Reasons")

    reason = TranslationField(default=dict, verbose_name=_("Name"))


class UserRecitationReport(models.Model):
    class Meta:
        verbose_name = _("Report")
        verbose_name_plural = _("Reports")
        constraints = [
            CheckConstraint(
                check=~Q(reporter=F('reportee')),
                name='reporter_not_equal_reportee'
            )
        ]

    reason_text = models.TextField(default=None, verbose_name=_("Reason Text"))
    recitation = models.ForeignKey(Recitation, on_delete=models.SET_NULL, null=True, blank=True, default=None,
                                   verbose_name=_("Recitation"))
    reporter = models.ForeignKey(UserModel, on_delete=models.CASCADE, related_name="reports_by_reporter",
                                 verbose_name=_("Reporter"))
    reportee = models.ForeignKey(UserModel, on_delete=models.CASCADE, related_name="reports_by_reportee",
                                 verbose_name=_("Reportee"))
    is_opened = models.BooleanField(default=True, verbose_name=_("Is Opened"))

    def __str__(self):
        return str(self.pk)
