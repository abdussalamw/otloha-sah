from django import forms
from django.contrib.contenttypes.fields import GenericRelation
from django.db import models
from django.utils.translation import gettext_lazy as _
from translation.models import TranslatableModel

from apps.chapters.models import ChapterModel


class Part(TranslatableModel):
    translatable = {
        'name': {"field": forms.CharField},
        'alias': {"field": forms.CharField},
    }

    name = models.JSONField()
    alias = models.JSONField(blank=True, null=True)
    part_number = models.PositiveIntegerField()
    chapter = GenericRelation(ChapterModel, related_query_name="part")
    is_active = models.BooleanField(default=True, verbose_name=_("Is Active"))
    created_at = models.DateTimeField(auto_now_add=True, verbose_name=_("Created At"))
    updated_at = models.DateTimeField(auto_now=True, verbose_name=_("Updated At"))

    def __str__(self):
        if self.name:
            return self.translated_name
        return super(Part, self).__str__()
