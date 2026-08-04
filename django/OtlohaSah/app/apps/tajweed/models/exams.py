from django.db import models
from django.db.models import Q
from django.utils.translation import gettext_lazy as _

from apps.tajweed import config
from .calendar import CalendarSlot


class ExamReservation(models.Model):
    class Meta:
        verbose_name = _("Exam Reservation")
        verbose_name_plural = _("Exam Reservations")
        constraints = [
            models.UniqueConstraint(fields=['user', 'exam_type', 'status'],
                                    condition=models.Q(status=config.STATUS_PENDING), name='unique_type_pending'),
            models.UniqueConstraint(
                fields=['user', 'status', 'calendar_slot'],
                condition=Q(status=config.STATUS_PENDING) | Q(status=config.STATUS_ACCEPTED),
                name='unique_accepted_or_pending'
            )
        ]

    user = models.ForeignKey('users.User', on_delete=models.CASCADE)
    exam_type = models.CharField(max_length=150, choices=config.RESERVATION_EXAM_TYPES)
    calendar_slot = models.ForeignKey(CalendarSlot, on_delete=models.CASCADE)
    status = models.CharField(max_length=100, choices=config.RESERVATION_STATUS, default=config.STATUS_PENDING,
                              null=True)
    TajweedLevel = 'tajweed.TajweedLevel'
    level = models.ForeignKey(TajweedLevel, on_delete=models.CASCADE, null=False)
    meeting_link = models.URLField(max_length=255, null=True, default=None)
    notes = models.TextField(null=True)
    created_at = models.DateTimeField(auto_now_add=True, null=True)

    def __str__(self):
        return f"ExamReservation {self.user} - {self.exam_type} - {self.status}"
