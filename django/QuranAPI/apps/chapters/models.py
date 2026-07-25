from django import forms
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.contrib.postgres.indexes import GinIndex
from django.contrib.postgres.search import SearchVectorField
from django.db import models
from django.urls import reverse
from django.utils.functional import cached_property
from django.utils.translation import gettext as _
from pyarabic import araby
from pyarabic.normalize import normalize_searchtext
from translation.models import TranslatableModel

# Create your models here.
from apps.narrations.models import Narration


class ChapterManager(models.Manager):
    use_in_migrations = True

    def fill_searchable_text(self, *args, **kwargs):
        items = self.all()
        if len(kwargs.keys()) > 0:
            items = items.filter(**kwargs)

        for item in items:
            name = ' '.join([val for lang, val in item.name.items()])
            item.searchable_name = araby.strip_diacritics(normalize_searchtext(name))
            item.save()


class Chapter(TranslatableModel):
    ORIGIN_MAKKIAH = "makkiah"
    ORIGIN_MADANIA = "madania"

    ORIGINS = (
        (ORIGIN_MAKKIAH, _("in Makkah")),
        (ORIGIN_MADANIA, _("in El Madina"))
    )

    # define translatable
    translatable = {
        'name': {"field": forms.CharField},
    }
    SEARCH_INDEX = {
        "fields": {
            "searchable_name": "A"
        }
    }
    class Meta:
        verbose_name = _("Chapter")
        verbose_name_plural = _("Chapters")
        indexes = [
            GinIndex(fields=["search_vector"]),
        ]

    objects = ChapterManager()

    name = models.JSONField(verbose_name=_('Name'))
    searchable_name = models.TextField(blank=True, null=True, verbose_name=_('Searchable Name'))
    origin = models.CharField(max_length=50, choices=ORIGINS, verbose_name=_("Origin"))
    chapter_number = models.PositiveIntegerField(db_index=True, verbose_name=_("Chapter Number"))
    is_active = models.BooleanField(default=True, verbose_name=_("Is Active"))

    search_vector = SearchVectorField(null=True)

    def __str__(self):
        if self.name:
            return self.translated_name
        return super(Chapter, self).__str__()

    @property
    def get_delete_url(self):
        return reverse('admin:softdelete:single-delete', args=['chapters', 'Chapter', self.pk]) + '?next={}'.format(
            reverse('admin:chapters:listing'))

    @property
    def get_edit_url(self):
        return reverse('admin:chapters:update', args=[self.pk])

    @property
    def get_translate_url(self):
        return reverse('translation:translate_form', args=['chapters', 'Chapter', self.pk]) + '?next={}'.format(
            reverse('admin:chapters:listing'))

    @cached_property
    def chapter_metadata(self):
        narration_data = {}
        for narration in Narration.objects.filter(is_active=True):
            narration_verses = narration.narration_verses.filter(chapter_id=self.id)
            narration_verses_ordered = narration_verses.order_by('chapter__chapter_number', 'verse_number')
            from_page = narration_verses_ordered.first().page_number if narration_verses_ordered.count() else 0
            to_page = narration_verses_ordered.last().page_number if narration_verses_ordered.count() else 0
            narration_data[narration.id] = {
                "number_of_verses": narration_verses.count(),
                "from_page": from_page,
                "to_page": to_page
            }
        return narration_data


class ChapterModel(models.Model):
    object_id = models.PositiveIntegerField(null=True)
    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE, blank=True, null=True)
    content_object = GenericForeignKey('content_type', 'object_id')
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE)
