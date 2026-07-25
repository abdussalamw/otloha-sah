from datetime import *

from django import forms
from django.contrib.contenttypes.models import ContentType
from django.db import models
from django.urls import reverse
from django.utils.translation import gettext as _
from rest_framework.authtoken.models import Token
from translation.models import TranslatableModel

from apps.files_handler.models import File


# Create your models here.

class Book(TranslatableModel):
    translatable = {
        'name': {'field': forms.CharField},
        'author': {'field': forms.CharField},
    }

    FILE_PROCESSORS = {
        "import_characters": {
            "type": "import_csv",
            "form_class": "apps.tajweed.forms.TajweedCSVForm",
            "method": "apps.tajweed.tasks.process_csv_tajweed",
            "columns": {
                "rule_text": None,
                "character_text": None,
                "character_number": None,
                "verse_number": None,
                "chapter_number": None,
                'word_number': None,
            }
        }
    }

    name = models.JSONField(verbose_name=_('Name'))
    narration = models.ForeignKey("narrations.Narration",
                                  null=True, blank=True,
                                  on_delete=models.SET_NULL,
                                  verbose_name=_('Narrations'))
    author = models.JSONField(verbose_name=_('Author'))

    def __str__(self):
        if self.name:
            return _("{book} Book").format(book=self.translated_name)
        return super(Book, self).__str__()

    @property
    def get_details_url(self):
        return reverse('admin:tajweed:books:details', args=[self.pk])

    @property
    def get_delete_url(self):
        return reverse('admin:softdelete:single-delete', args=['tajweed', 'Book', self.pk]) + '?next={}'.format(
            reverse('admin:tajweed:books:listing'))

    @property
    def get_edit_url(self):
        return reverse('admin:tajweed:books:update', args=[self.pk])

    @property
    def get_translate_url(self):
        return reverse('admin:translation:translate_form', args=['tajweed', 'Book', self.pk]) + '?next={}'.format(
            self.get_details_url)


class Rule(TranslatableModel):
    translatable = {
        'name': {'field': forms.CharField},
        'description': {"field": forms.CharField, "widget": forms.Textarea}
    }

    RED = 'red'
    GREEN = 'grn'
    BLUE = 'blu'
    Yellow = 'ylw'
    ORANGE = 'org'
    BLACK = 'blk'
    WHITE = 'wht'
    PINK = 'pnk'
    BROWN = 'brw'
    GREY = 'gry'
    NAVY = 'nvy'
    AQUA = 'aqu'

    COLORS = (
        (RED, _('Red')),
        (GREEN, _('Green')),
        (BLUE, _('Blue')),
        (Yellow, _('Yellow')),
        (ORANGE, _('Orange')),
        (BLACK, _('Black')),
        (WHITE, _('White')),
        (PINK, _('Pink')),
        (BROWN, _('Brown')),
        (GREY, _('Grey')),
        (NAVY, _('Navy')),
        (AQUA, _('Aqua')),
    )

    rule_number = models.PositiveIntegerField(verbose_name=_('Rule Number'))
    name = models.JSONField(verbose_name=_('Name'))
    description = models.JSONField(blank=True, null=True, verbose_name=_('Description'))
    tajweed_book = models.ForeignKey("Book", on_delete=models.CASCADE)
    color = models.CharField(max_length=50, choices=COLORS)

    def __str__(self):
        if self.name:
            return _("Rule: {rule}, Rule Number: {rule_number}").format(
                rule=self.translated_name,
                rule_number=self.rule_number,
            )
        return super(Rule, self).__str__()


#
# class Verse(models.Model):
#     verse_text = models.CharField(max_length=5000, verbose_name=_('Verse Text'))
#     verse_number = models.PositiveIntegerField(verbose_name=_('Verse Number'))
#     chapter = models.ForeignKey(Chapter, null=True, blank=True, on_delete=models.SET_NULL)
#     chapter_number = models.PositiveIntegerField(verbose_name=_('Chapter Number'))
#     tajweed_book = models.ForeignKey("Book", null=True, blank=True, on_delete=models.SET_NULL)
#
#     def __str__(self):
#         if self.verse_text:
#             return _("Verse Number: {verse_number}, Chapter Number: {chapter_number}").format(
#                 verse_number=self.verse_number,
#                 chapter_number=self.chapter_number,
#             )
#         return super(Verse, self).__str__()
#
#     @cached_property
#     def next_verse(self):
#         verse = Verse.objects.filter(chapter=self.chapter, verse_number=self.verse_number + 1)
#         if verse.exists():
#             return verse.first()
#         else:
#             verse = Verse.objects.filter(chapter_number=self.chapter_number + 1)
#             return verse.order_by('verse_number').first() if verse.exists() else None
#
#     @cached_property
#     def previous_verse(self):
#         verse = Verse.objects.filter(chapter=self.chapter, verse_number=self.verse_number - 1)
#         if verse.exists():
#             return verse.first()
#         else:
#             verse = Verse.objects.filter(chapter_number=self.chapter_number - 1)
#             return verse.order_by('verse_number').first() if verse.exists() else None


class Character(models.Model):
    class Meta:
        verbose_name = _('Character')
        verbose_name_plural = _('Characters')
        ordering = ['chapter_number', 'verse_number', 'word_number', 'character_number']

    character_text = models.CharField(max_length=5000, verbose_name=_('Character Text'))
    rule_text = models.TextField(blank=True, null=True, verbose_name=_('Rule Text'))
    word_text = models.CharField(max_length=1000, verbose_name=_('Word Text'))

    character_number = models.PositiveIntegerField(verbose_name=_('Character Number'))
    word_number = models.PositiveIntegerField(verbose_name=_('Word Number'))
    verse_number = models.PositiveIntegerField(verbose_name=_('Verse Number'))
    chapter_number = models.PositiveIntegerField(verbose_name=_('Chapter Number'))

    word = models.ForeignKey("narrations.Word", null=True, blank=True, on_delete=models.SET_NULL,
                             verbose_name=_('Word'))
    verse = models.ForeignKey("narrations.Verse", null=True, blank=True, on_delete=models.SET_NULL,
                              verbose_name=_('Verse'))
    chapter = models.ForeignKey("chapters.Chapter", null=True, blank=True, on_delete=models.SET_NULL,
                                verbose_name=_('Chapter'))
    book = models.ForeignKey("Book", null=True, blank=True, on_delete=models.SET_NULL,
                             verbose_name=_('Book'))
    rule = models.ForeignKey("Rule", null=True, blank=True, on_delete=models.SET_NULL,
                             verbose_name=_('Rule'))

    def __str__(self):
        return _("Character {character}").format(character=self.character_text)
