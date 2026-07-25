from django.db import models
from django.utils.translation import gettext_lazy as _

from apps.notifications.models import Notifying
from .user import User, UserManager, UserQuerySet
from .. import config


class TeacherManager(UserManager):
    def get_queryset(self, *args, **kwargs):
        return UserQuerySet(self.model, using=self._db).filter(is_a_teacher=True)


class Teacher(User):
    objects = TeacherManager()

    class Meta:
        proxy = True
        verbose_name = config.USER_TYPE_TEACHER_VERBOSE_NAME
        verbose_name_plural = config.USER_TYPE_TEACHER_VERBOSE_NAME_PLURAL
        default_permissions = ['change', 'view']
        permissions = (
            ("toggle_block_teacher", _("Can toggle block teacher")),
        )


class TeacherProfile(models.Model):
    TEACHER_TYPE_VOLUNTEER = "volunteer"
    TEACHER_TYPE_PAID = "paid"
    TEACHER_TYPE = (
        (TEACHER_TYPE_VOLUNTEER, _("Volunteer")),
        (TEACHER_TYPE_PAID, _("Paid"))
    )

    STATUS_PENDING = "pending"
    STATUS_APPROVED = "approved"
    STATUS_REJECTED = "rejected"
    STATUS_CHOICES = (
        (STATUS_PENDING, _('Pending')),
        (STATUS_APPROVED, _('Approved')),
        (STATUS_REJECTED, _('Rejected')),
    )

    def get_upload_to(self, filename):
        return "teachers/{}/cv/{}".format(self.teacher.id, filename)

    class Meta:
        default_permissions = []
        permissions = (
            ("suspend_teacherprofile", _("Can Suspend Teacher Profile")),
            ("unsuspend_teacherprofile", _("Can Unsuspend Teacher Profile")),
            ("reject_teacherprofile", _("Can Reject Teacher Profile")),
            ("approve_teacherprofile", _("Can Approve Teacher Profile")),
            ("toggle_reply_on_every_verse_in_recitation_teacherprofile",
             _("Can Toggle Reply On Every Verse In Recitation Teacher Profile")),
        )

    teacher = models.OneToOneField(Teacher, on_delete=models.CASCADE)
    teacher_type = models.CharField(_("Teacher Type"), max_length=50, choices=TEACHER_TYPE,
                                    default=TEACHER_TYPE_VOLUNTEER)
    status = models.CharField(_("Status"), max_length=50, choices=STATUS_CHOICES, default=STATUS_PENDING)
    cv = models.FileField(_("C.V."), upload_to=get_upload_to, null=True, blank=True)
    education_degree = models.CharField(_("Education Degree"), max_length=1000)
    can_reply_on_every_verse_in_recitation = models.BooleanField(_("Can Reply On Every Verse In Recitation"),
                                                                 default=False)
    is_active = models.BooleanField(_("Is Active"), default=False)
    created_at = models.DateTimeField(_("Created At"), auto_now_add=True, null=True, blank=True)
    updated_at = models.DateTimeField(_("Updated At"), auto_now=True, null=True, blank=True)

    def __str__(self):
        return str(self.teacher)

    @property
    def get_teacher_type(self):
        return dict(self.TEACHER_TYPE)[self.teacher_type] if self.teacher_type else _("Not Available")

    @property
    def get_status(self):
        return dict(self.STATUS_CHOICES)[self.status] if self.status else _("Not Available")


class TeacherNarration(Notifying):
    def get_upload_to(self, filename):
        return "teachers/{}/certifications/{}".format(self.teacher.id, filename)

    class Meta:
        verbose_name = _("Teacher Narration")
        verbose_name_plural = _("Teacher Narrations")
        default_permissions = ()
        permissions = (
            ("toggle_certification_teachernarration", _("Can Toggle Certification Teacher Narration")),
        )

    teacher = models.ForeignKey(Teacher, on_delete=models.CASCADE)
    teacherprofile = models.ForeignKey(TeacherProfile, on_delete=models.CASCADE)
    narration = models.ForeignKey('quran_api_client.Narration', on_delete=models.CASCADE)
    is_certified = models.BooleanField(_("Is Certified"), default=False)
    certified_at = models.DateTimeField(_("Certified At"), default=None, null=True, blank=True)
    certification = models.FileField(_("Certification"), upload_to=get_upload_to, default=None, null=True, blank=True)
    remaining_required_recitations = models.IntegerField(_("Remaining Required Recitations"), default=0)
    is_complete = models.BooleanField(_("Is Complete"), default=False)


class TeacherRecitationPricing(Notifying):
    class Meta:
        verbose_name = _("Teacher Recitation Pricing")
        verbose_name_plural = _("Teacher Recitations Pricing")
        ordering = ('-created_at',)
        default_permissions = []
        permissions = (
            ("complete_teacherrecitationpricing", _("Can Complete Teacher Recitation Pricing")),
        )

    teacher = models.ForeignKey(Teacher, on_delete=models.CASCADE, verbose_name=_("Teacher"))
    recitation = models.PositiveIntegerField(verbose_name=_("Recitation ID"))
    recitation_name = models.CharField(_("Recitation Name"), max_length=1000, default=None, null=True, blank=True)
    created_at = models.DateTimeField(_("Created At"), auto_now_add=True, null=True, blank=True)

    price = models.FloatField(default=0.0, verbose_name=_("Price"))
    is_paid = models.BooleanField(default=False, verbose_name=_("Is Paid"))
    paid_at = models.DateTimeField(_("Paid At"), default=None, null=True, blank=True)

    def save(self, *args, **kwargs):
        if not self.id:
            from apps.settings.utils import get_setting
            self.price = get_setting("teacher_pricing_per_recitation")
        super(TeacherRecitationPricing, self).save(*args, **kwargs)


class TeacherFiles(models.Model):
    def get_upload_to(self, filename):
        return "teachers/{}/{}".format(self.teacher_profile.teacher.id, filename)

    FILE_TYPES = (
        ('cv', _('CV')),
        ('certifications', _('Certification')),
        ('application_recitation', _('Application Recitation'))
    )

    class Meta:
        default_permissions = []

    file_type = models.CharField(choices=FILE_TYPES, max_length=100)
    file = models.FileField(upload_to=get_upload_to)
    teacher_profile = models.ForeignKey('TeacherProfile', on_delete=models.CASCADE)

    @property
    def get_file_type(self):
        return dict(self.FILE_TYPES)[self.file_type]
