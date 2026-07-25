from datetime import timedelta

from django.db import models
from django.utils import timezone
from django.utils.translation import gettext_lazy as _


class SignalLog(models.Model):
    class Meta:
        indexes = [
            models.Index(fields=['signal_name']),
            models.Index(fields=['created_at']),
        ]

    signal_name = models.CharField(max_length=100)
    time_taken = models.FloatField()
    created_at = models.DateTimeField(auto_now_add=True, verbose_name=_("Created At"))

    def __str__(self):
        return f"{self.signal_name} - {self.time_taken}"


class APILog(models.Model):
    class Meta:
        indexes = [
            models.Index(fields=['created_at']),
            models.Index(fields=['code', 'url_path', 'method']),

        ]

    view_name = models.CharField(max_length=100)
    url_path = models.CharField(max_length=255)
    code = models.CharField(max_length=3)
    method = models.CharField(max_length=10)
    db_hits = models.IntegerField(default=0)
    queries = models.TextField(default=None, null=True, blank=True)
    time_taken = models.FloatField()
    created_at = models.DateTimeField(auto_now_add=True, verbose_name=_("Created At"))

    def __str__(self):
        return f"{self.view_name}"

    def clean(self):
        if timezone.now().weekday() == 0 and timezone.now().hour == 0 and timezone.now().minute == 0:
            self.cleanup_old_logs()

    @classmethod
    def cleanup_old_logs(cls):
        three_months_ago = timezone.now() - timedelta(days=90)
        while cls.objects.filter(created_at__lt=three_months_ago).count() > 0:
            cls.objects.filter(created_at__lt=three_months_ago).order_by('id')[:100000].delete()
