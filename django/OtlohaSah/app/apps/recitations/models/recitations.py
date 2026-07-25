import uuid

from django.contrib.auth import get_user_model
from django.db import models
from django.db.models import Q
from django.http import Http404
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from rest_framework.exceptions import ValidationError

from apps.khatma.models import KhatmaUsers, Khatma
from apps.notifications.models import Notifying
from apps.recitations import config
from apps.records.models import Record
from apps.tajweed.models import TajweedLessonExample
from apps.users.models import TeacherNarration
from quran_api_client import quran
from quran_api_client.models import Narration, Verse, Chapter

UserModel = get_user_model()


class RecitationQuerySet(models.QuerySet):
    def students_only(self):
        return self.exclude(Q(owner__is_a_teacher=True) | Q(is_teacher_recitation=True))

    def teachers_only(self, user):
        return self.filter_by_gender_settings(user, 'display_teacher_recitations_to_opposite_gender').filter(
            owner__is_a_teacher=True,
            is_teacher_recitation=True,
            khatma__isnull=True,
            tajweed_lesson_example__isnull=True,
        )

    def filter_by_gender_settings(self, user, key):
        return self.filter(
            Q(owner__gender=user.gender) | Q(
                owner__settings__key=key,
                owner__settings__value=True)
        )

    def khatmausers_only(self, user, khatma):
        if not KhatmaUsers.objects.filter(khatma=khatma, user=user).exists():
            raise Http404("User is not part of this khatma or khatma does not exist.")

        return self.filter(
            show_in_box=True,
            khatma=khatma,
            tajweed_lesson_example__isnull=True,
        )

    def filter_by_rate(self, user):
        return self.filter(owner__level__lte=user.level)


class RecitationManager(models.Manager):
    def get_queryset(self):
        return RecitationQuerySet(model=self.model, using=self._db)

    def general(self, user):
        certified_narrations = user.teachernarration_set.filter(is_certified=True).values_list('narration_id',
                                                                                               flat=True)
        certified_narrations = [str(item) for item in certified_narrations]
        return self.get_queryset() \
            .filter_by_rate(user) \
            .filter_by_gender_settings(user, 'display_general_box_recitations_to_opposite_gender') \
            .students_only() \
            .filter(
            evaluating=False,
            evaluated_at=None,
            result=0,
            show_in_box=True,
            khatma__isnull=True,
            narration_id__in=certified_narrations
        )

    def user_remarkable(self, user, show_in_remarkable=True):
        return self.get_queryset().filter_by_gender_settings(
            user, 'display_remarkable_recitations_to_opposite_gender').students_only().filter(
            is_remarkable=True,
            show_in_remarkable=show_in_remarkable,
        )

    def teachers_only(self, user):
        return self.get_queryset().teachers_only(user)

    def certified_teachers(self, user, show_in_box=True):
        return self.get_queryset().teachers_only(user).filter(
            show_in_box=show_in_box,
            owner__teachernarration__is_certified=True,
            owner__teachernarration__narration_id=models.Subquery(
                TeacherNarration.objects.filter(
                    teacher=models.OuterRef('owner'),
                ).values('narration_id')[:1]
            )
        )

    def tajweed_recitations(self, user, owner=None):
        certified_narrations = user.teachernarration_set.filter(is_certified=True).values_list('narration_id',
                                                                                               flat=True)
        certified_narrations = [str(item) for item in certified_narrations]
        return self.get_queryset().filter_by_gender_settings(
            user, 'display_general_box_recitations_to_opposite_gender'
        ).students_only().filter(
            evaluating=False,
            evaluated_at=None,
            result=0,
            show_in_box=True,
            khatma__isnull=True,
            tajweed_lesson_example=True,
            narration_id__in=certified_narrations
        )

    def khatma_users(self, user, khatma, owner=None):
        return self.get_queryset().filter_by_gender_settings(
            user, 'display_general_box_recitations_to_opposite_gender').khatmausers_only(user, khatma)


class VerseData(models.Model):
    class Meta:
        abstract = True

    verses = models.ManyToManyField(Verse, verbose_name=_("Verses"))
    chapter = models.ForeignKey(Chapter, on_delete=models.CASCADE, verbose_name=_("Chapter"))
    narration = models.ForeignKey(Narration, on_delete=models.CASCADE, verbose_name=_("Narration"))
    # verses_number = ArrayField(models.IntegerField(), verbose_name=_("Verses Numbers"))  # max=20
    page_number = models.IntegerField(_("Page Number"))


class RatingData(models.Model):
    class Meta:
        abstract = True

    teacher_rate = models.DecimalField(default=0.0, max_digits=4, decimal_places=2, verbose_name=_("Teacher Rate"))
    owner_rate = models.DecimalField(_("Owner Rate"), default=0.0, max_digits=4, decimal_places=2, )
    owner_review = models.TextField(_("Owner Review"), default=None, null=True, blank=True)


class ResultData(models.Model):
    class Meta:
        abstract = True

    result = models.IntegerField(_("Result"), choices=config.RECITATIONS_RESULT, default=0)
    is_remarkable = models.BooleanField(_("Is Remarkable"), default=False)
    evaluating = models.BooleanField(_("Being Evaluated"), default=False)
    evaluated_at = models.DateTimeField(_("Evaluated At"), null=True, blank=True)
    is_closed = models.BooleanField(_("Is Closed"), default=False)
    closed_at = models.DateTimeField(_("Closed At"), null=True, blank=True)


class RecordData(models.Model):
    def get_upload(self, filename):
        return 'recitations/{}/{}'.format(self.uuid, filename)

    class Meta:
        abstract = True

    uuid = models.UUIDField(default=uuid.uuid4, editable=False, unique=True)
    record = models.FileField(_("Record"), upload_to=get_upload)
    waveform = models.TextField()
    duration = models.DurationField()


class Config(models.Model):
    class Meta:
        abstract = True

    show_in_box = models.BooleanField(_("Show In Box"), default=False)
    show_in_remarkable = models.BooleanField(_("Show In Remarkable Recitations"), default=False)


class Recitation(VerseData, ResultData, RatingData, Config, Notifying):
    SEARCH_INDEX = {
        "fields": {
            "id": "A",
            "name": "B",
            "result": "B",
            "owner__username": "C",
            "owner__rate": "C",
            "owner__gender": "C",
            "owner__first_name": "C",
            "owner__last_name": "C",
            "owner__email": "C",
            "teacher__username": "C",
            "teacher__first_name": "C",
            "teacher__last_name": "C",
            "teacher__email": "C",
            "updated_at": "C",
            "created_at": "C",
            "archived_at": "C",
        }
    }
    MESSAGES = {
        "finished": _('recitation marked as finished'),
        "already_finished": _('recitation is already finished'),
        "teacher_removed_from_recitation": _('teacher removed from recitation successfully'),
        "favorite_teacher_assigned": _('favorite teacher assigned successfully'),
        "added_to_general": _('recitation added to general list'),
        "removed_from_general": _('recitation removed from general list'),
        "added_to_remarkable": _('recitation added to remarkable list'),
        "removed_from_remarkable": _('recitation removed from remarkable list'),
        "forbidden": _('you don\'t have permission to preform this action')
    }

    class Meta:
        verbose_name = _("Recitation")
        verbose_name_plural = _("Recitations")

    objects = RecitationManager()

    name = models.CharField(max_length=400, verbose_name=_("Name"))
    record = models.OneToOneField(Record, on_delete=models.SET_NULL, null=True, blank=True, verbose_name=_("Record"))
    owner = models.ForeignKey(
        UserModel,
        on_delete=models.CASCADE,
        verbose_name=_("Owner"))

    teacher = models.ForeignKey(
        UserModel,
        on_delete=models.CASCADE,
        related_name="of_recitations",
        null=True, blank=True, default=None, verbose_name=_("Teacher"))

    khatma = models.ForeignKey(
        Khatma,
        null=True,
        blank=True,
        on_delete=models.CASCADE,
        verbose_name=_("Khatma")
    )

    tajweed_lesson_example = models.ForeignKey(
        TajweedLessonExample,
        null=True,
        blank=True,
        on_delete=models.CASCADE,
        verbose_name=_("Tajweed Lesson Example")
    )
    is_teacher_recitation = models.BooleanField(default=False, verbose_name=_("Is A Teacher Recitation"))

    # timestamps
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True, verbose_name=_("Updated At"))
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True, verbose_name=_("Created At"))
    archived_at = models.DateTimeField(_("Archived At"), null=True, blank=True)

    @property
    def get_verses_list(self):
        return list(self.verses.all().values_list('id', flat=True))

    @property
    def get_verses(self):
        verses = []
        for verse_id in self.get_verses_list:
            if verse_id:
                verses.append(quran.verse(self.narration, verse_id))
        return verses

    @property
    def get_verses_numbers_list(self):
        return [verse.verse_number for verse in self.get_verses if verse]

    @property
    def get_delete_urls(self):
        return reverse('admin:new-recitations:delete', args=[self.id])

    @property
    def get_details_url(self):
        return reverse('admin:new-recitations:details', args=[self.id])

    @property
    def get_results(self):
        return dict(config.RECITATIONS_RESULT).get(self.result)

    def clean(self):
        if self.khatma is not None and self.tajweed_lesson_example is not None:
            raise ValidationError("Only one of Khatma User and Tajweed Lesson Example can be set.")
        super().clean()
