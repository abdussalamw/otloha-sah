from dj_translation.models import TranslationField, TranslatedValue
from django.core.validators import MinValueValidator, MaxValueValidator
from django.db import models
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from mptt.fields import TreeForeignKey
from mptt.models import MPTTModel

from quran_api_client.models import Narration, Chapter
from .levels import TajweedLevel


class TajweedLesson(MPTTModel):
    SEARCH_INDEX = {
        "fields": {
            "id": "A",
            "title": "B",
            "lesson_level": "C",
            "parent": "C",
        }
    }
    @property
    def get_details_url(self):
        return reverse('admin:tajweed:lessons:details', args=[self.pk])

    title = TranslationField(default=dict, verbose_name=_("Title"), unique=True)
    content = TranslationField(verbose_name=_("Content"), rich_text=True, null=True, default=dict)
    lesson_level = models.ForeignKey(TajweedLevel, on_delete=models.CASCADE, verbose_name=_("Tajweed Level"))
    parent = TreeForeignKey('self', on_delete=models.SET_NULL, null=True, blank=True,
                            verbose_name=_("Parent Lesson"))

    def __str__(self):
        return TranslatedValue(self.title).translate()

    class Meta:
        verbose_name = _("Tajweed Lesson")
        verbose_name_plural = _("Tajweed Lessons")


class TajweedLessonExample(models.Model):
    SEARCH_INDEX = {
        "fields": {
            "id": "A",
            "title": "B",
            "verse_number": "C",
            "lesson__lesson_level": "C",
            "chapter": "C",
        }
    }
    class Meta:
        verbose_name = _("Tajweed Lesson Example")
        verbose_name_plural = _("Tajweed Lesson Examples")

    def get_upload_to(self, filename):
        return 'tajweed/tajweed_verses/{}/{}'.format(self.chapter.pk, self.verse_number)

    title = TranslationField(max_length=255, unique=True, verbose_name=_("Title"), default=dict)
    record = models.URLField(max_length=200, blank=True, null=True, verbose_name=_("record"))
    verse_number = models.PositiveIntegerField(db_index=True, verbose_name=_('Verse Number'))
    lesson = models.ForeignKey(TajweedLesson, on_delete=models.CASCADE, verbose_name=_("Lesson"))
    narration = models.ForeignKey(Narration, on_delete=models.CASCADE, related_name="Narration",
                                  blank=True, null=True)
    verse_text = models.TextField(blank=True, null=True, verbose_name=_('Verse Text'))
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE, related_name="Chapter",
                                blank=True, null=True)

    def __str__(self):
        return TranslatedValue(self.title).translate()


class TajweedVideoUrl(models.Model):
    url = models.URLField(max_length=200, verbose_name=_("Video URL"))
    lesson = models.ForeignKey(TajweedLesson, on_delete=models.CASCADE, verbose_name=_("Video lesson"))

    def __str__(self):
        return TranslatedValue(self.url).translate()

    class Meta:
        verbose_name = _("Tajweed Video URL")
        verbose_name_plural = _("Tajweed Video URLs")


class TajweedUserProgress(models.Model):
    user = models.ForeignKey('users.User', on_delete=models.CASCADE)
    level = models.ForeignKey(TajweedLevel, on_delete=models.CASCADE)
    lesson = models.ForeignKey(TajweedLesson, on_delete=models.CASCADE)
    read = models.IntegerField(default=0, validators=[MinValueValidator(0), MaxValueValidator(100)], null=True,
                               blank=True)
    completed = models.IntegerField(default=0, validators=[MinValueValidator(0), MaxValueValidator(100)], null=True,
                                    blank=True)
    rate = models.IntegerField(default=0, validators=[MinValueValidator(0), MaxValueValidator(10)], null=True,
                               blank=True)
    parent = models.ForeignKey(TajweedLesson, on_delete=models.SET_NULL, null=True, blank=True,
                               verbose_name=_("Parent Lesson User Progress"), related_name='progress_parent')

    class Meta:
        unique_together = ('user_id', 'lesson', 'level')

    def __str__(self):
        return str(self.lesson)
