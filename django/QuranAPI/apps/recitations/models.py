from datetime import *

from django import forms
from django.contrib.contenttypes.models import ContentType
from django.db import models
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from translation.models import TranslatableModel

from apps.chapters.models import Chapter
from apps.files_handler.models import File
from apps.narrations.models import Narration


class Reciter(TranslatableModel):
    class Meta:
        verbose_name = _('Reciter')
        verbose_name_plural = _('Reciters')

    translatable = {
        'name': {"field": forms.CharField},
    }

    name = models.JSONField(null=False, blank=False, verbose_name=_('Name'))
    created_at = models.DateField(auto_now_add=True, verbose_name=_('Created At'))
    updated_at = models.DateTimeField(auto_now=True, verbose_name=_('Updated At'))

    def __str__(self):
        if self.name:
            return self.translated_name
        return super(Reciter, self).__str__()


class Recitation(TranslatableModel):
    class Meta:
        verbose_name = _('Recitation')
        verbose_name_plural = _('Recitations')

    translatable = {
        'name': {"field": forms.CharField},
    }

    FILE_PROCESSORS = {
        "verses": {
            "type": "import_zip",
            "form_class": "apps.recitations.forms.ProcessNarrationCSVForm",
            "method": "apps.recitations.tasks.process_files",
        },
    }

    name = models.JSONField(null=True, blank=True, verbose_name=_('Name'))
    narration = models.ForeignKey(Narration, on_delete=models.SET_NULL, related_name="narration_recitation",
                                  blank=True, null=True)
    reciter = models.ForeignKey(Reciter, on_delete=models.CASCADE, related_name="reciter_recitation")

    def __str__(self):
        if self.name:
            return "{} {} {} {}".format(_("recitation"), self.narration.translated_name, _('by shaikh'),
                                        self.reciter.translated_name)
        return super(Recitation, self).__str__()

    @property
    def get_delete_url(self):
        return reverse('admin:softdelete:single-delete', args=['recitations', 'Recitation', self.pk]) + \
               '?next={}'.format(reverse('admin:recitations:listing'))

    @property
    def get_details_url(self):
        return reverse('admin:recitations:details', args=[self.pk])

    @property
    def get_edit_url(self):
        return reverse('admin:recitations:update', args=[self.pk])

    @property
    def get_translate_url(self):
        return reverse('translation:translate_form', args=['recitations', 'Recitation', self.pk]) + '?next={}'.format(
            self.get_details_url)


class RecitationVerse(models.Model):
    def get_upload_to(self, filename):
        return 'recitations/{}/recitation_verses/{}'.format(self.recitation.pk, filename)

    recitation = models.ForeignKey(Recitation, on_delete=models.CASCADE)
    record = models.FileField(upload_to=get_upload_to, blank=True, null=True)
    verse_number = models.PositiveIntegerField(blank=True, null=True)
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
