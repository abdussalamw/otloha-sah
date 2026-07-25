from dj_translation.models import TranslationField, TranslatedValue
from django.db import models
from django.utils.translation import gettext_lazy as _


class Narration(models.Model):
    name = models.JSONField(verbose_name=_('Name'))
    description = models.JSONField(blank=True, null=True, verbose_name=_('Description'))

    def __str__(self):
        return _('{} Narration').format(self.name)


from django.db import models
from django.utils.translation import gettext_lazy as _


class Chapter(models.Model):
    name = models.JSONField(verbose_name=_('Name'))
    origin = models.CharField(max_length=50, verbose_name=_("Origin"))
    chapter_number = models.PositiveIntegerField(db_index=True, verbose_name=_("Chapter Number"))

    class Meta:
        ordering = ['chapter_number']

    def __str__(self):
        return self.name


class Part(models.Model):
    SEARCH_INDEX = {
        "fields": {
            "name": "A",
            "is_active": "A",
            "alias": "B",
            "part_number": "C",
        }
    }

    name = TranslationField(verbose_name=_('Name'), default=dict)
    alias = TranslationField(verbose_name=_('Alias'), default=dict)
    part_number = models.PositiveIntegerField(verbose_name=_("Part Number"))
    is_active = models.BooleanField(default=True, verbose_name=_("Is Active"))
    chapters = models.ManyToManyField('Chapter', related_name='part_chapters', verbose_name=_('Chapters'))

    class Meta:
        ordering = ("id",)

    def __str__(self):
        return TranslatedValue(self.name).get()


class Verse(models.Model):
    class Meta:
        ordering = ['chapter_number', 'verse_number']

    text = models.TextField(blank=True, null=True, verbose_name=_('Text'))
    line_start = models.PositiveIntegerField(verbose_name=_('Line Start'))
    line_end = models.PositiveIntegerField(verbose_name=_('Line End'))
    verse_number = models.PositiveIntegerField(db_index=True, verbose_name=_('Verse Number'))
    page_number = models.PositiveIntegerField(verbose_name=_('Page Number'), blank=True, null=True)
    chapter_number = models.PositiveIntegerField(verbose_name=_('Chapter Number'), blank=True, null=True)
    part_number = models.PositiveIntegerField(verbose_name=_('Part Number'), blank=True, null=True)
    narration = models.ForeignKey(Narration, on_delete=models.CASCADE, related_name='narration_verses')
    chapter = models.ForeignKey(Chapter, on_delete=models.SET_NULL, related_name='chapter_verses',
                                blank=True, null=True)

    def __str__(self):
        return self.text
