from django.contrib.contenttypes.fields import GenericRelation
from django.db import models
from django.db.models import Q
from django.urls import reverse
from django.utils.translation import gettext_lazy as _

from apps.chat.models import Message
from apps.notifications.models import Notifying
from apps.recitation.notifications import RecitationAddedToGeneralNotification, \
    RecitationAddedToRemarkableRecitationsNotification
from apps.records.models import Record
from apps.users.models import User, TeacherNarration
from quran_api_client import quran


class RecitationQuerySet(models.QuerySet):
    def students_only(self):
        return self.exclude(Q(Q(owner__is_a_teacher=True) | Q(is_teacher_recitation=True)))

    def teachers_only(self, user):
        return self.filter_by_gender_settings(user, 'display_teacher_recitations_to_opposite_gender').filter(
            owner__is_a_teacher=True,
            is_teacher_recitation=True)

    def filter_by_gender_settings(self, user, key):
        return self.filter(
            Q(gender=user.gender) | Q(
                owner__settings__key=key,
                owner__settings__value=True)
        )

    def accepted(self):
        return self.filter(result='accepted')

    def remarkable(self, is_remarkable=True):
        return self.filter(is_remarkable=is_remarkable)

    def rejected(self):
        return self.filter(result='rejected')

    def filter_by_rate(self, user):
        return self.filter(owner__level__lte=user.level)


class RecitationManager(models.Manager):
    def get_queryset(self):
        return RecitationQuerySet(model=self.model, using=self._db)

    def general_box(self, user, show_in_general=True):
        certified_narrations = user.teachernarration_set.filter(is_certified=True).values_list('narration_id',
                                                                                               flat=True)
        certified_narrations = [str(item) for item in certified_narrations]
        return self.get_queryset().filter_by_rate(user).filter_by_gender_settings(
            user, 'display_general_box_recitations_to_opposite_gender'
        ).students_only().filter(
            evaluated_at__isnull=True,
            being_evaluated=False,
            show_in_general=show_in_general,
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

    def certified_teachers_only(self, user):
        return self.get_queryset().teachers_only(user).filter(
            owner__teachernarration__is_certified=True,
            owner__teachernarration__narration_id=models.Subquery(
                TeacherNarration.objects.filter(
                    teacher=models.OuterRef('owner'),
                ).values('narration_id')[:1]
            )
        )

    def accepted(self):
        return self.get_queryset().accepted()

    def rejected(self):
        return self.get_queryset().rejected()

    def reported(self):
        return self.get_queryset().filter(result='reported')

    def evaluated(self, user):
        return self.get_queryset().filter(evaluated_at__isnull=False, teacher=user)


class Recitation(Notifying):
    OBJECT_PERMISSIONS = (
        ('view_recitation_{}', 'Can view recitation {}'),
        ('update_recitation_{}', 'Can update recitation {}'),
        ('delete_recitation_{}', 'Can delete recitation {}'),
    )

    GENDER_MALE = 'male'
    GENDER_FEMALE = 'female'
    GENDERS = (
        (GENDER_MALE, 'Male'),
        (GENDER_FEMALE, 'Female'))

    RESULT_ACCEPTED = 'accepted'
    RESULT_REJECTED = 'rejected'
    RESULT_REPORTED = 'reported'
    RESULT_CHOICES = (
        (RESULT_ACCEPTED, _('Accepted')),
        (RESULT_REJECTED, _('Rejected')),
        (RESULT_REPORTED, _('Reported')),
    )

    MESSAGES = {
        "finished": _('recitation marked as finished'),
        "already_finished": _('recitation is already finished'),
        "added_to_general": _('recitation added to general list'),
        "removed_from_general": _('recitation removed from general list'),
        "added_to_remarkable": _('recitation added to remarkable list'),
        "removed_from_remarkable": _('recitation removed from remarkable list'),
        "forbidden": _('you don\'t have permission to preform this action')
    }

    SEARCH_INDEX = {
        "fields": {
            "id": "A",
            "name": "B",
            "owner__username": "C",
            "owner__first_name": "C",
            "owner__last_name": "C",
            "owner__email": "C",
            "teacher__username": "C",
            "teacher__first_name": "C",
            "teacher__last_name": "C",
            "teacher__email": "C"
        }
    }

    class Meta:
        ordering = ['-created_at']
        default_permissions = (
            'create', 'view_any',
        )

    objects = RecitationManager()

    # recitation meta data
    name = models.CharField(max_length=400, null=True, blank=True, verbose_name=_("Name"))
    narration_id = models.CharField(max_length=200, null=True, blank=True, verbose_name=_("Narration"))
    verse_ids = models.TextField(null=True, blank=True, verbose_name=_("Verses"))
    chapter_id = models.CharField(max_length=50, null=True, blank=True, verbose_name=_("Chapter"))
    # recitation records
    records = GenericRelation(Record)
    # user info
    owner = models.ForeignKey(User, on_delete=models.CASCADE, related_name="recitations", verbose_name=_("Owner"))
    teacher = models.ForeignKey(User, on_delete=models.CASCADE, related_name="recitations_teacher", null=True,
                                blank=True, verbose_name=_("Teacher"))
    gender = models.CharField(max_length=200, choices=GENDERS, null=True, blank=True, verbose_name=_("Gender"))
    is_child = models.BooleanField(default=False, verbose_name=_("Is Child"))
    is_teacher_recitation = models.BooleanField(default=False, verbose_name=_("Is A Teacher Recitation"))
    # timestamps
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True, verbose_name=_("Updated At"))
    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True, verbose_name=_("Created At"))

    # Rating
    teacher_rate = models.DecimalField(default=0.0, max_digits=4, decimal_places=2, verbose_name=_("Teacher Rate"))
    owner_rate = models.DecimalField(_("Owner Rate"), default=0.0, max_digits=4, decimal_places=2, )
    owner_review = models.TextField(_("Owner Review"), default=None, null=True, blank=True)

    # STATUSES
    teacher_assigned_at = models.DateTimeField(_("Teacher Assigned At"),
                                               default=None, null=True, blank=True)
    result = models.CharField(_("Result"), max_length=20, choices=RESULT_CHOICES, null=True, blank=True)
    archived_at = models.DateTimeField(_("Archived At"), null=True, blank=True)
    is_remarkable = models.BooleanField(_("Is Remarkable"), default=False)
    conversation_started = models.BooleanField(_("Conversation Started"), default=False)
    being_evaluated = models.BooleanField(_("Being Evaluated"), default=False)
    evaluated_at = models.DateTimeField(_("Evaluated At"), null=True, blank=True)
    is_closed = models.BooleanField(_("Is Closed"), default=False)
    closed_at = models.DateTimeField(_("Closed At"), null=True, blank=True)
    # Recitations Settings
    show_in_general = models.BooleanField(_("Show In General Box"), default=False)
    show_in_remarkable = models.BooleanField(_("Show In Remarkable Box"), default=False)
    room = GenericRelation('chat.Room', related_query_name='recitation_room', verbose_name=_("Room"))

    def save(self, *args, **kwargs):
        self.is_child = self.owner.get_age <= 14
        self.gender = self.owner.gender
        return super().save(*args, **kwargs)

    def __str__(self):
        return str(self.name)

    @property
    def get_verses_list(self):
        return self.verse_ids.replace('[', '').replace(']', '').split(',')

    @property
    def get_verses(self):
        verses = []

        if self.verse_ids:
            for verse_id in self.get_verses_list:
                if verse_id:
                    verses.append(quran.verse(self.narration_id, verse_id))
        return verses

    @property
    def get_verses_numbers_list(self):
        verses_numbers = []
        for verse in self.get_verses:
            if verse:
                verses_numbers.append(verse.verse_number)
        return verses_numbers

    @property
    def get_result(self):
        return dict(self.RESULT_CHOICES).get(self.result)

    @property
    def get_details_url(self):
        return reverse('admin:recitations:details', args=[self.id])

    @property
    def get_delete_url(self):
        return reverse('admin:recitations:delete', args=[self.id])

    def toggle_show_in_general(self, user):
        if user != self.owner:
            return self.MESSAGES.get("forbidden"), False

        if self.show_in_general:
            self.show_in_general = False
            message = self.MESSAGES.get("removed_from_general")
        else:
            self.show_in_general = True
            message = self.MESSAGES.get("added_to_general")
            self.notify(RecitationAddedToGeneralNotification, sender=self.owner)
        self.save()
        return message, True

    def toggle_show_in_remarkable(self, user):
        if user != self.owner:
            return self.MESSAGES.get("forbidden"), False

        if not self.is_remarkable:
            return self.MESSAGES.get("forbidden"), False

        if self.show_in_remarkable:
            self.show_in_remarkable = False
            message = self.MESSAGES.get("removed_from_remarkable")
        else:
            self.show_in_remarkable = True
            message = self.MESSAGES.get("added_to_remarkable")
            self.notify(RecitationAddedToRemarkableRecitationsNotification, sender=self.owner)

        self.save()
        return message, True


class RecitationFault(models.Model):
    FAULT_TYPE_TAJWEED = 'tajweed'
    FAULT_TYPE_WORD = 'word'
    FAULT_TYPE_PRONUNCIATION = 'pronunciation'

    FAULT_TYPES = (
        (FAULT_TYPE_TAJWEED, _('Tajweed')),
        (FAULT_TYPE_WORD, _('Word')),
        (FAULT_TYPE_PRONUNCIATION, _('Pronunciation')),
    )

    class Meta:
        verbose_name = _('Message Fault')
        verbose_name_plural = _('Message Faults')

    recitation = models.ForeignKey(Recitation, on_delete=models.CASCADE)
    message = models.OneToOneField(Message, on_delete=models.CASCADE)
    fault_type = models.CharField(max_length=50, choices=FAULT_TYPES, null=True, blank=True)
    error_text = models.TextField()
    position_from = models.IntegerField(null=True, blank=True)
    position_to = models.IntegerField(null=True, blank=True)

    def __str__(self):
        return self.error_text

    @property
    def get_fault_type(self):
        return dict(self.FAULT_TYPES).get(self.fault_type)
