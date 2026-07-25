from django.core.exceptions import ValidationError
from django.db import models


class CalendarSlot(models.Model):
    class Meta:
        unique_together = ('date', 'time_from')

    date = models.DateField()
    time_from = models.TimeField(null=True)
    time_to = models.TimeField()
    available_slots = models.PositiveIntegerField()
    reserved_slots = models.PositiveIntegerField(default=0, null=True)

    def __str__(self):
        return (f"{self.date} "
                f"{self.time_from} to {self.time_to}")

    def clean(self):
        if self.reserved_slots and self.available_slots:
            if self.reserved_slots > self.available_slots:
                raise ValidationError("Reserved slots cannot exceed available slots.")
