import uuid as uuid

from django import forms
from django.contrib.postgres.indexes import GinIndex
from django.contrib.postgres.search import SearchVectorField
from django.db import models
from django.urls import reverse
from django.utils.translation import gettext as _
from pyarabic import araby
from pyarabic.normalize import normalize_searchtext
from softdelete.models import SoftDeletionModel
from translation.models import TranslatableModel


class Narration(TranslatableModel, SoftDeletionModel):
    translatable = {
        'name': {'field': forms.CharField},
        'description': {'field': forms.CharField, 'widget': forms.Textarea}
    }

    FILE_PROCESSORS = {
        "verses": {
            "type": "import_csv",
            "form_class": "apps.narrations.forms.ProcessNarrationCSVForm",
            "method": "apps.narrations.tasks.process_verses_csv",
            "columns": {
                "line_start": 4,
                "line_end": 5,
                "part": 1,
                "text": 7,
                "verse_number": 6,
                "chapter": 2,
                "page": 3
            }
        },
        "words": {
            "type": "import_csv",
            "form_class": "apps.narrations.forms.ProcessNarrationWordsCSVForm",
            "method": "apps.narrations.tasks.process_words_csv",
            "columns": {
                "text": 6,
                "verse_number": 2,
                "chapter_number": 0,
                "number": 1,
                "position_in_line": 5,
                "line_number": 3,
                "page_number": 4
            }
        }
    }

    def get_upload_to(self, filename):
        return 'narrations/{}'.format(self.id, filename)

    class Meta:
        ordering = ('id',)
        verbose_name = _("Narration")
        verbose_name_plural = _("Narrations")

    name = models.JSONField(verbose_name=_('Name'))
    description = models.JSONField(blank=True, null=True, verbose_name=_('Description'))
    number_of_pages = models.IntegerField(null=True, blank=True)
    is_active = models.BooleanField(default=True, verbose_name=_("Is Active"))
    created_at = models.DateTimeField(auto_now_add=True, null=True, verbose_name=_('Created At'))
    updated_at = models.DateTimeField(auto_now=True, null=True, verbose_name=_('Updated At'))
    chapters = models.ManyToManyField('chapters.Chapter', through="ChapterNarration")
    json_file = models.FileField(upload_to='narrations/', null=True, blank=True)

    def __str__(self):
        if self.name:
            return self.translated_name
        return super(Narration, self).__str__()

    @property
    def get_delete_url(self):
        return reverse('admin:softdelete:single-delete', args=['narrations', 'Narration', self.pk]) + '?next={}'.format(
            reverse('admin:narrations:listing'))

    @property
    def get_edit_url(self):
        return reverse('admin:narrations:update', args=[self.pk])

    @property
    def get_translate_url(self):
        return reverse('translation:translate_form', args=['narrations', 'Narration', self.pk]) + '?next={}'.format(
            reverse('admin:narrations:details', args=[self.pk]))

    def do_toggle_active(self):
        self.is_active = not self.is_active
        self.save()
        return True, _("Narration is now {}".format("active" if self.is_active else "inactive"))

    def do_generate_json_file(self):
        from apps.narrations.tasks import create_narration_json_file
        create_narration_json_file.delay(self.id)
        return True, _("JSON file generated")


class VerseManager(models.Manager):
    use_in_migrations = True

    def fill_searchable_text(self, *args, **kwargs):

        items = self.all()
        if len(kwargs.keys()) > 0:
            items = items.filter(**kwargs)

        for item in items:
            item.searchable_text = araby.strip_diacritics(normalize_searchtext(item.text)).replace(' ', '')
            item.save()


class Verse(models.Model):
    SEARCH_INDEX = {
        "fields": {
            "text": "B",
            "searchable_text": "C"
        }
    }

    def get_upload_to(self, filename):
        return 'narrations/verses/{}/{}'.format(self.uuid, filename)

    class Meta:
        verbose_name = _('Verse')
        verbose_name_plural = _('Verses')
        indexes = [
            GinIndex(fields=["search_vector"]),
        ]

    objects = VerseManager()

    uuid = models.UUIDField(default=uuid.uuid4, editable=False)
    text = models.TextField(blank=True, null=True, verbose_name=_('Text'))
    searchable_text = models.TextField(blank=True, null=True, verbose_name=_('Searchable Text'))
    line_start = models.PositiveIntegerField(verbose_name=_('Line Start'))
    line_end = models.PositiveIntegerField(verbose_name=_('Line End'))
    verse_number = models.PositiveIntegerField(db_index=True, verbose_name=_('Verse Number'))
    page_number = models.PositiveIntegerField(verbose_name=_('Page Number'), blank=True, null=True)
    chapter_number = models.PositiveIntegerField(verbose_name=_('Chapter Number'), blank=True, null=True)
    part_number = models.PositiveIntegerField(verbose_name=_('Part Number'), blank=True, null=True)
    image = models.ImageField(upload_to=get_upload_to, blank=True, null=True)
    narration = models.ForeignKey(Narration, on_delete=models.CASCADE, related_name='narration_verses')
    chapter = models.ForeignKey("chapters.Chapter", on_delete=models.SET_NULL, related_name='chapter_verses',
                                blank=True, null=True)
    part = models.ForeignKey("parts.Part", on_delete=models.SET_NULL, related_name="part_verses", blank=True, null=True)
    pages = models.ManyToManyField("quran.Page")

    search_vector = SearchVectorField(null=True)

    def __str__(self):
        return _("Verse Number {verse_number}").format(verse_number=self.verse_number)


class ChapterNarration(models.Model):
    narration = models.ForeignKey(Narration, on_delete=models.CASCADE)
    chapter = models.ForeignKey('chapters.Chapter', on_delete=models.CASCADE)
    number_of_verses = models.PositiveIntegerField()
    from_page = models.PositiveIntegerField()
    to_page = models.PositiveIntegerField()


class Word(models.Model):
    class Meta:
        verbose_name = _("Word")
        verbose_name_plural = _("Words")
        ordering = ('chapter_number', 'verse_number', 'number')

    text = models.TextField(blank=True, null=True, verbose_name=_('Text'))
    number = models.PositiveIntegerField(verbose_name=_('Number'), blank=True, null=True)
    chapter_number = models.PositiveIntegerField(verbose_name=_('Chapter Number'), blank=True, null=True)
    verse_number = models.PositiveIntegerField(verbose_name=_('Chapter Number'), blank=True, null=True)
    position_in_line = models.PositiveIntegerField(verbose_name=_('Position In Line'), blank=True, null=True)
    line_number = models.PositiveIntegerField(verbose_name=_('Line Number'), blank=True, null=True)
    page_number = models.PositiveIntegerField(verbose_name=_('Page Number'), blank=True, null=True)
    narration = models.ForeignKey(Narration, on_delete=models.CASCADE, related_name='narration_verse_words')
    verse = models.ForeignKey(Verse, on_delete=models.CASCADE, related_name='verse_words')
