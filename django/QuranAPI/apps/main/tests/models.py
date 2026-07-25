from django.db import models
from django.utils.timezone import now


class TestModel(models.Model):
    id = models.BigAutoField(primary_key=True)
    title = models.JSONField(blank=True, null=True)
    created_at = models.DateTimeField(auto_created=True, default=now, blank=True)
    updated_at = models.DateTimeField(auto_now=True, null=True, blank=True)
