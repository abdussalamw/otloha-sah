from django import forms
from django.db import models
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from translation.models import TranslatableModel

from apps.narrations.models import Narration


class Explanation(TranslatableModel):
    class Meta:
        verbose_name = _('Explanation')
        verbose_name_plural = _('Explanations')

    translatable = {
        'name': {"field": forms.CharField},
    }

    FILE_PROCESSORS = {
        "verses": {
            "type": "import_csv",
            "form_class": 'apps.explanations.forms.ExplanationCSVForm',
            "method": 'apps.explanations.tasks.process_csv',
            "columns": {
                'text': None,
                "verse_number": None,
                "chapter_number": None,
                "page_number": None,
            }
        },
    }

    name = models.JSONField(null=True, blank=True, verbose_name=_('Explanation Name'))
    narration = models.ForeignKey(Narration, on_delete=models.SET_NULL, related_name="explanation_narration",
                                  blank=True, null=True, verbose_name=_('Narration'))

    def __str__(self):
        if self.name:
            return self.translated_name
        return super(Explanation, self).__str__()

    @property
    def get_delete_url(self):
        return reverse('admin:softdelete:single-delete',
                       args=['explanations', 'Explanation', self.pk]) + '?next={}'.format(
            reverse('admin:explanations:listing'))

    @property
    def get_edit_url(self):
        return reverse('admin:explanations:update', args=[self.pk])

    @property
    def get_details_url(self):
        return reverse('admin:explanations:details', args=[self.pk])

    @property
    def get_translate_url(self):
        return reverse('translation:translate_form', args=['explanations', 'Explanation', self.pk]) + '?next={}'.format(
            self.get_details_url)


class ExplanationVerse(TranslatableModel):
    class Meta:
        verbose_name = _('Explanation Verse')
        verbose_name_plural = _('Explanation Verses')

    translatable = {
        'text': {"field": forms.CharField},
    }

    explanation = models.ForeignKey(Explanation, on_delete=models.CASCADE)
    verse_number = models.PositiveIntegerField(blank=True, null=True, verbose_name=_('Verse Number'))
    chapter_number = models.PositiveIntegerField(blank=True, null=True, verbose_name=_('Chapter Number'))
    page_number = models.PositiveIntegerField(blank=True, null=True, verbose_name=_('Page Number'))
    text = models.JSONField(verbose_name=_('Tafseer Text'), null=True, blank=True)
    chapter = models.ForeignKey('chapters.Chapter', on_delete=models.SET_NULL, blank=True, null=True,
                                verbose_name=_('Chapter'))
    verse = models.ForeignKey('narrations.Verse', on_delete=models.SET_NULL, blank=True, null=True,
                              verbose_name=_('Verse'))
