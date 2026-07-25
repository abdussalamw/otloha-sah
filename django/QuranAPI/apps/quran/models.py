import uuid as uuid
from datetime import *

from django import forms
from django.contrib.contenttypes.fields import GenericRelation
from django.contrib.contenttypes.models import ContentType
from django.db import models
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from rest_framework.authtoken.models import Token
from softdelete.models import SoftDeletionModel
from translation.models import TranslatableModel

from apps.chapters.models import ChapterModel, Chapter
from apps.files_handler.models import File
from apps.narrations.models import Narration, Verse
from apps.parts.models import Part
from apps.recitations.models import Recitation, Reciter, RecitationVerse
from apps.translations.models import Translation, TranslationVerse


class Book(TranslatableModel):
    class Meta:
        verbose_name = _('Book')
        verbose_name_plural = _('Books')

    translatable = {
        'name': {"field": forms.CharField},
    }

    FILE_PROCESSORS = {
        "pages": {
            "type": "import_zip",
            "method": 'apps.quran.tasks.process_zip_file',
        }
    }

    created_at = models.DateTimeField(auto_now_add=True, blank=True)
    updated_at = models.DateTimeField(auto_now=True, null=True, blank=True)
    name = models.JSONField(verbose_name=_('Name'))
    is_active = models.BooleanField(default=False)
    narration = models.ForeignKey('narrations.Narration', on_delete=models.CASCADE, related_name="narration_books")
    chapters = models.ManyToManyField('chapters.Chapter', through="BookChapter")

    def __str__(self):
        return self.translated_name

    @property
    def get_edit_url(self):
        return reverse("admin:books:update", args=[self.pk])

    @property
    def get_translate_url(self):
        return "{}?next={}".format(
            reverse("admin:translation:translate_form", args=["quran", "Book", self.pk]),
            reverse("admin:books:details", args=[self.pk])
        )

    @property
    def get_delete_url(self):
        return "{}?next={}".format(
            reverse("admin:softdelete:single-delete", args=["quran", "Book", self.pk]),
            reverse("admin:books:listing")
        )


class BookChapter(models.Model):
    def get_upload_to(self, filename):
        return 'books/{}/chapters/{}/{}'.format(self.book.pk, self.uuid, filename)

    uuid = models.UUIDField(default=uuid.uuid4, editable=False)
    text_image = models.FileField(upload_to=get_upload_to, verbose_name=_('File'))
    header_image = models.FileField(upload_to=get_upload_to, verbose_name=_('File'))
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    chapter = models.ForeignKey('chapters.Chapter', on_delete=models.CASCADE)


class BookPattern(models.Model):
    class Meta:
        verbose_name = _('Book Pattern Image')
        verbose_name_plural = _('Book Patterns Image')

    PART_NAME_TYPE = 'part_name'
    CHAPTER_NAME_TYPE = 'chapter_name'
    MARKER_TYPE = 'marker'
    FRAME_TYPE = 'frame'
    PATTERN_TYPES = (
        (PART_NAME_TYPE, _('Part Name')),
        (CHAPTER_NAME_TYPE, _('Chapter Name')),
        (MARKER_TYPE, _('Marker')),
        (FRAME_TYPE, _('Frame'))
    )

    def get_upload_to(self, filename):
        return 'books/{}/patterns/{}/{}'.format(self.book.pk, self.uuid, filename)

    uuid = models.UUIDField(default=uuid.uuid4, editable=False)
    file = models.ImageField(upload_to=get_upload_to, verbose_name=_('Image'))
    book = models.ForeignKey(Book, on_delete=models.CASCADE, verbose_name=_('Book'))
    type = models.CharField(max_length=50, choices=PATTERN_TYPES, verbose_name=_('Type'))

    @property
    def get_edit_url(self):
        return reverse("admin:books:update", args=[self.pk])

    @property
    def get_delete_url(self):
        return "{}?next={}".format(
            reverse("admin:softdelete:single-delete", args=["quran", "BookPattern", self.pk]),
            reverse("admin:books:patterns:listing", args=[self.book_id])
        )


class Page(models.Model):
    def get_upload_to(self, filename):
        return 'books/{}/pages/{}/{}'.format(self.book.pk, self.uuid, filename)

    class Meta:
        ordering = ('book_id', 'page_number',)
        verbose_name = _('Page')
        verbose_name_plural = _('Pages')

    id = models.BigAutoField(primary_key=True)
    uuid = models.UUIDField(default=uuid.uuid4, editable=False)
    image = models.ImageField(upload_to=get_upload_to, blank=True, null=True, verbose_name=_('Image'))
    page_number = models.PositiveIntegerField(verbose_name=_("Page Number"))
    sub_part = models.PositiveIntegerField(blank=True, null=True, verbose_name=_("Sub Part"))
    narration = models.ForeignKey(Narration, on_delete=models.SET_NULL, related_name="narration_pages", blank=True,
                                  null=True, verbose_name=_('Narration'))
    book = models.ForeignKey(Book, on_delete=models.CASCADE, related_name="book_pages", blank=True, null=True,
                             verbose_name=_('Book'))
    part = models.ForeignKey(Part, on_delete=models.SET_NULL, related_name="part_pages", blank=True, null=True,
                             verbose_name=_('Part'))
    chapters = GenericRelation(ChapterModel, related_query_name="chapter_pages", verbose_name=_('Chapters'))

    def __str__(self):
        return str(self.page_number)


class Glyph(models.Model):
    id = models.BigAutoField(primary_key=True)
    chapter = models.ForeignKey("chapters.Chapter", on_delete=models.SET_NULL, related_name='chapter_glyphs',
                                blank=True, null=True, verbose_name=_('Chapter'))
    page = models.ForeignKey(Page, on_delete=models.SET_NULL, related_name='page_glyphs', blank=True, null=True,
                             verbose_name=_('Page'))
    verse = models.ForeignKey(Verse, on_delete=models.SET_NULL, related_name='verse_glyphs', blank=True, null=True,
                              verbose_name=_('Verse'))
    line_number = models.PositiveIntegerField(verbose_name=_('Line Number'))
    position = models.PositiveIntegerField(verbose_name=_('Position'), null=True, blank=True)
    min_x = models.IntegerField(verbose_name=_('Min X'))
    max_x = models.IntegerField(verbose_name=_('Max X'))
    min_y = models.IntegerField(verbose_name=_('Min Y'))
    max_y = models.IntegerField(verbose_name=_('Max Y'))
