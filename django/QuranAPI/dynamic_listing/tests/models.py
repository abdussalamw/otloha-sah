from django.db import models
from django.template.defaulttags import now


class CategoryTestModel(models.Model):
    id = models.BigAutoField(primary_key=True)
    name = models.CharField(max_length=255)  # search


class ProductTestModel(models.Model):
    COLORS = (
        ('red', "Red"),
        ('green', "Green"),
        ('blur', "Blue"),
    )
    BOOLEAN_CHOICES = (('false', 'False'), ('true', 'True'),)

    id = models.BigAutoField(primary_key=True)
    name = models.CharField(max_length=255)  # search
    uuid = models.UUIDField()  # filter range / sort
    price = models.IntegerField(default=0)  # filter range / sort
    is_active = models.BooleanField()  # filter range / sort
    is_available = models.BooleanField(choices=BOOLEAN_CHOICES)  # filter range / sort
    color = models.CharField(max_length=255, choices=COLORS, default='red')  # search
    date_of_production = models.DateField(default=now, blank=True)
    time_of_production = models.TimeField(default=now, blank=True)
    is_published = models.DateTimeField(default=now, blank=True)  # IsoDateTimeFilter / DurationFilter
    category = models.ForeignKey(CategoryTestModel, related_name="categories", on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_created=True, default=now, blank=True)
    updated_at = models.DateTimeField(auto_now=True, null=True, blank=True)
