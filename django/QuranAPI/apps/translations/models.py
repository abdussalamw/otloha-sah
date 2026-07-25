from django import forms
from django.db import models
from django.utils.translation import gettext_lazy as _
from translation.models import TranslatableModel

from app import settings
from apps.chapters.models import Chapter
from apps.narrations.models import Narration


class Translation(TranslatableModel):
    class Meta:
        verbose_name = _("Translation")
        verbose_name_plural = _("Translations")

    translatable = {
        'name': {"field": forms.CharField},
        'author': {"field": forms.CharField},
    }
    FILE_PROCESSORS = {
        "verses": {
            "type": "import_csv",
            "form_class": 'apps.translations.forms.TranslationCSVForm',
            "method": 'apps.translations.tasks.process_csv',
            "columns": {
                'text': None,
                "verse_number": None,
                "chapter_number": None,
            }
        },
    }
    name = models.JSONField(verbose_name=_('Name'), null=True)
    language = models.CharField(max_length=50, choices=settings.LANGUAGES)
    author = models.JSONField(verbose_name=_('Author'))
    narration = models.ForeignKey(Narration, on_delete=models.SET_NULL, blank=True, null=True,
                                  verbose_name=_('Narration'))

    def __str__(self):
        if self.name:
            return _("{}, translated to {}").format(self.translated_name, self.language)
        return super(Translation, self).__str__()


class TranslationVerse(models.Model):
    class Meta:
        verbose_name = _("Translation Verse")
        verbose_name_plural = _("Translation Verses")

    text = models.TextField()
    translation = models.ForeignKey("Translation", on_delete=models.CASCADE)
    chapter = models.ForeignKey(Chapter, related_name='chapter_translation_verse',
                                null=True, blank=True, on_delete=models.SET_NULL)
    page_number = models.PositiveIntegerField(blank=True, null=True, verbose_name=_('Page Number'))
    chapter_number = models.PositiveIntegerField(verbose_name=_('Chapter Number'))
    verse_number = models.PositiveIntegerField(verbose_name=_('Verse Number'))
    verse = models.ForeignKey('narrations.Verse', on_delete=models.SET_NULL, blank=True, null=True,
                              verbose_name=_('Verse'))
