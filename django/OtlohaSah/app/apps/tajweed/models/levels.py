from dj_translation.models import TranslationField, TranslatedValue
from django.core.validators import MinValueValidator, MaxValueValidator
from django.db import models
from django.utils.translation import gettext_lazy as _

from .exams import ExamReservation


class TajweedLevel(models.Model):
    name = TranslationField(default=dict, verbose_name=_("Name"), unique=True)
    color = models.CharField(max_length=64, verbose_name=_("Color"), unique=True)
    value = models.PositiveIntegerField(default=0, unique=True)

    def __str__(self):
        return TranslatedValue(self.name).translate()

    class Meta:
        verbose_name = _("Tajweed Level")
        verbose_name_plural = _("Tajweed Levels")

    SEARCH_INDEX = {
        "fields": {
            "color": "A",
        }
    }


class UserLevelPassed(models.Model):
    class Meta:
        unique_together = ('user', 'level')

    user = models.ForeignKey('users.User', on_delete=models.CASCADE, verbose_name=_("User"))
    level = models.ForeignKey(TajweedLevel, on_delete=models.CASCADE, verbose_name=_("Tajweed Level"))
    rate = models.IntegerField(default=0, validators=[MinValueValidator(0), MaxValueValidator(10)], null=True)
    exam_record = models.ForeignKey(ExamReservation, on_delete=models.CASCADE, verbose_name=_("Tajweed Exam Record"))
    created_at = models.DateTimeField(auto_now_add=True, null=True)

    def __str__(self):
        return f"UserLevelsPassed {self.user} - {self.level} - Rate: {self.rate}"
