from django.conf import settings
from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.models import AbstractUser
from django.contrib.auth.validators import UnicodeUsernameValidator
from django.core.cache import cache
from django.core.validators import EmailValidator
from django.db import models
from django.db.models import Q, Exists, OuterRef
from django.templatetags.static import static
from django.urls import reverse
from django.utils.datetime_safe import date
from django.utils.translation import gettext_lazy as _, gettext as _
from phonenumber_field.modelfields import PhoneNumberField

from apps.entities.models import Entity
from apps.invitations.models import BlockList, BanedInvitation
from apps.notifications.models import Notifying
from apps.users import config


class UserQuerySet(models.QuerySet):
    def active(self):
        return self.filter(is_active=True)

    def inactive(self):
        return self.filter(is_active=False)

    def filter_by_gender_settings(self, user):
        qs = self.filter(
            Q(gender=user.gender) | Q(settings__key='display_profile_to_opposite_gender', settings__value=True))
        if user.favorite_teacher:
            qs = qs | self.filter(pk=user.favorite_teacher.pk)
        return qs.distinct()

    def students_of(self, user):
        return self.filter(favorite_teacher=user)

    def list_teacher(self):
        return self.filter(is_a_teacher=True)

    def list_student(self):
        return self.filter(is_a_teacher=False)

    def unblocked_and_unblocker_users(self, user):
        from apps.invitations import config
        blocked_users_subquery = BlockList.objects.filter(
            Q(blocker=user.pk, blocker_type=config.INVITATION_USER_TYPE_USER) |
            Q(blocked=user.pk, blocked_type=config.INVITATION_USER_TYPE_USER)
        ).values('blocked', 'blocker')

        unblocked_and_unblocker_users = self.annotate(
            has_block=Exists(blocked_users_subquery.filter(Q(blocked=OuterRef('id')) | Q(blocker=OuterRef('id'))))
        ).exclude(has_block=True)

        return unblocked_and_unblocker_users

    def unbaned_and_unbaner_users_khatma(self, user):
        from apps.invitations import config
        blocked_users_subquery = BanedInvitation.objects.filter(
            Q(blocker=user.pk, blocker_type=config.INVITATION_USER_TYPE_USER,
              invitation_type=config.INVITATION_TYPE_JOIN_KHATMA_REQUEST) |
            Q(blocked=user.pk, blocked_type=config.INVITATION_USER_TYPE_USER,
              invitation_type=config.INVITATION_TYPE_JOIN_KHATMA_REQUEST)
        ).values('blocked', 'blocker', 'invitation_type')

        unbaned_and_unbaner_users = self.annotate(
            has_block=Exists(blocked_users_subquery.filter(Q(blocked=OuterRef('id')) | Q(blocker=OuterRef('id'))))
        ).exclude(has_block=True)

        return unbaned_and_unbaner_users

    def unblocked_and_unblocker_entities(self, user):
        from apps.invitations import config

        blocked_users_subquery = BlockList.objects.filter(
            Q(blocklist__blocker=user.pk, blocklist__blocker_type=config.INVITATION_USER_TYPE_USER,
              blocklist__blocked_type=config.INVITATION_USER_TYPE_ENTITY) |
            Q(blocklist__blocked=user.pk, blocklist__blocked_type=config.INVITATION_USER_TYPE_USER,
              blocklist__blocker_type=config.INVITATION_USER_TYPE_ENTITY)
        ).values('blocked', 'blocker')

        unblocked_and_unblocker_entities = Entity.objects.annotate(
            has_block=Exists(blocked_users_subquery.filter(Q(blocked=OuterRef('id')) | Q(blocker=OuterRef('id'))))
        ).exclude(has_block=True)

        return unblocked_and_unblocker_entities


class UserManager(BaseUserManager):
    use_in_migrations = True

    def get_queryset(self):
        return UserQuerySet(model=self.model, using=self._db)

    def _create_user(self, email, password, **extra_fields):
        """Create and save a User with the given email and password."""
        if not email:
            raise ValueError(_('The given email must be set'))
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, email, password=None, **extra_fields):
        """Create and save a regular User with the given email and password."""
        extra_fields.setdefault('is_staff', False)
        extra_fields.setdefault('is_superuser', False)
        return self._create_user(email, password, **extra_fields)

    def create_superuser(self, email, password, **extra_fields):
        """Create and save a SuperUser with the given email and password."""
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')

        return self._create_user(email, password, **extra_fields)

    def active(self):
        return self.get_queryset().active()

    def inactive(self):
        return self.get_queryset().inactive()

    def filter_by_gender_settings(self, user):
        return self.get_queryset().filter_by_gender_settings(user)

    def students_of(self, user):
        return self.get_queryset().students_of(user)

    def unblocked_and_unblocker_users(self, user):
        return self.get_queryset().unblocked_and_unblocker_users(user)

    def unblocked_and_unblocker_users_khatma(self, user):
        return self.get_queryset().unbaned_and_unbaner_users_khatma(user)

    def unblocked_and_unblocker_entities(self, user):
        return self.get_queryset().unblocked_and_unblocker_entities(user)


class UserUrlsMixin(models.Model):
    class Meta:
        abstract = True

    @property
    def get_user_type_plural(self):
        return dict(config.USER_TYPES_KEYS_PLURAL_REVERSED)[self.get_user_type]

    @property
    def get_edit_url(self):
        return "#"

    @property
    def get_details_url(self):
        return reverse('admin:users:details', args=[self.get_user_type_plural, self.pk])

    @property
    def get_toggle_block_url(self):
        return reverse('admin:users:toggle-block', args=[
            self.get_user_type_plural,
            self.pk,
            "block" if not self.is_blocked else "unblock"
        ])

    @property
    def get_block_url(self):
        return reverse('admin:users:toggle-block', args=[self.get_user_type_plural, self.pk, "block"])

    @property
    def get_unblock_url(self):
        return reverse('admin:users:toggle-block', args=[self.get_user_type_plural, self.pk, "unblock"])


class UserRateAndLevelMixin(models.Model):
    class Meta:
        abstract = True

    rate = models.DecimalField(_("Rate"), default=0.0, max_digits=4, decimal_places=2)
    level = models.SmallIntegerField(_("Level"), choices=config.LEVELS, default=config.LEVEL_BEGINNER)

    def update_user_rate_and_level(self, rate):
        self.rate = rate
        from apps.settings.utils import get_setting
        if rate >= get_setting('min_limit_for_advanced_level'):
            self.level = config.LEVEL_ADVANCED
        elif get_setting('min_limit_for_advanced_level') >= self.rate <= get_setting('min_limit_for_advanced_level'):
            self.level = config.LEVEL_INTERMEDIATE
        else:
            self.level = config.LEVEL_ADVANCED
        self.save()

    @property
    def get_level(self):
        return dict(config.LEVELS)[self.level]

    @property
    def get_level_text(self):
        return dict(config.LEVELS_TEXT)[self.level]


class UserRecitationMixin(models.Model):
    class Meta:
        abstract = True

    narration_id = models.CharField(_("Narration"), max_length=20, default=1, blank=True, null=True)
    recitation_method = models.CharField(
        max_length=50,
        choices=config.RECITATION_METHODS,
        default=config.RECITATION_METHOD_ALL_QURAN)

    # settings
    allow_remarkable_recitations_to_public = models.BooleanField(default=False)
    allow_cross_gender_view = models.BooleanField(default=False)

    @property
    def get_recitation_method(self):
        return dict(config.RECITATION_METHODS)[self.recitation_method] if self.recitation_method else _("Not Available")


class BaseUser(AbstractUser):
    def get_upload_to(self, filename):
        date_image = date.today().strftime("/%Y/%d/%m/")
        return 'users/{}-{}'.format(date_image, filename)

    class Meta:
        abstract = True
        ordering = ['-date_joined']

    username_validator = UnicodeUsernameValidator()
    email_validator = EmailValidator()

    full_name = models.CharField(_("Full Name"), max_length=100, blank=True, null=True)
    email = models.EmailField(_('email address'),
                              validators=[email_validator],
                              unique=True, blank=False, null=False)
    username = models.CharField(_('username'), max_length=150,
                                help_text=_('Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.'),
                                validators=[username_validator],
                                unique=True, blank=False, null=False)
    email_verified_at = models.DateField(blank=True, null=True)

    phone = PhoneNumberField(
        blank=True,
        null=True,
        default=None,
        error_messages={'unique': _("A user with that phone already exists.")})
    phone_verified_at = models.DateTimeField(blank=True, null=True)
    is_blocked = models.BooleanField(_("Is Blocked"), default=False)

    image = models.ImageField(_("Image"), upload_to=get_upload_to, default=None, null=True, blank=True)

    country = models.CharField(_("Country"), max_length=5, blank=True, null=True)

    @property
    def has_password(self):
        return len(self.password) > 0

    @property
    def get_full_name(self):
        if self.full_name:
            return self.full_name
        elif self.first_name and self.last_name:
            return self.first_name + " " + self.last_name
        return self.username

    @property
    def profile_image(self):
        if self.image:
            return self.image.url
        if self.gender:
            return static('defaults/{}.png'.format(self.gender))
        return static('images/logo.png')

    @property
    def is_verified(self):
        return self.email_verified_at is not None


class User(BaseUser, UserUrlsMixin, UserRateAndLevelMixin, UserRecitationMixin, Notifying,
           ):
    SEARCH_INDEX = {
        "fields": {
            "id": "A",
            "email": "A",
            "phone": "A",
            "username": "A",
            "first_name": "A",
            "last_name": "A",
            "bio": "B",
            "favorite_teacher__id": "B",
            "favorite_teacher__email": "B",
            "favorite_teacher__username": "B",
            "favorite_teacher__full_name": "B",
            "favorite_teacher__first_name": "B",
            "favorite_teacher__last_name": "B",
            "favorite_teacher__bio": "C",
        }
    }

    class Meta:
        verbose_name = _('User')
        verbose_name_plural = _('Users')
        ordering = ('-date_joined',)
        default_permissions = []

    EMAIL_FIELD = 'email'
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['phone']
    AUTHENTICATION_FIELDS = ['email', 'username', 'phone']

    objects = UserManager()

    birthdate = models.DateField(_("Birthdate"), blank=True, null=True, default=None)
    gender = models.CharField(_("Gender"), max_length=100, blank=False, null=False, choices=config.GENDERS)
    language = models.CharField(_("Language"), max_length=100, default=settings.LANGUAGE_ARABIC,
                                choices=settings.LANGUAGES)

    bio = models.CharField(_("Bio"), max_length=50, null=True, blank=True)
    is_a_teacher = models.BooleanField(_("Is A Teacher"), default=False)
    favorite_teacher = models.ForeignKey('Teacher', null=True, on_delete=models.SET_NULL,
                                         verbose_name=_("Favorite Teacher"))
    connections = models.ManyToManyField('self', related_name='user_connections', verbose_name=_('Connections'))

    def __str__(self):
        return self.username

    @property
    def get_age(self):
        key = "user_{}_age".format(self.id)
        if cache.get('key', None) and self.birthdate:
            return cache.get('key')
        today = date.today()
        age = today.year - self.birthdate.year - ((today.month, today.day) < (self.birthdate.month, self.birthdate.day))
        cache.set(key, age)
        return age

    @property
    def get_gender(self):
        return dict(config.GENDERS)[self.gender] if self.gender else _("Not Available")

    def get_language(self):
        return dict(settings.LANGUAGES)[self.language]

    @property
    def get_user_type(self):
        if self.is_a_teacher:
            return config.USER_TYPE_TEACHER
        elif self.is_staff:
            return config.USER_TYPE_ADMIN
        return config.USER_TYPE_STUDENT

    def is_member_of_entity(self, entity):
        return self.entityuserrole_set.filter(entity=entity).exists()

    def is_owner_of_entity(self, entity):
        return self.entityuserrole_set.filter(entity=entity, role='owner').exists()

    def is_moderator_of_entity(self, entity):
        return self.entityuserrole_set.filter(entity=entity, role='moderator').exists()

    def has_privileges_of_entity(self, entity):
        return self.entityuserrole_set.filter(entity=entity, role__in=['owner', 'moderator']).exists()


class UserProgress(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    narration_id = models.CharField(max_length=200, null=True, blank=True)
    accepted_recitations = models.IntegerField(default=0)
    rejected_recitations = models.IntegerField(default=0)
    pending_recitations = models.IntegerField(default=0)
    number_of_recitations = models.IntegerField(default=0)
    progress = models.JSONField(default=dict)
    recitation_percentage = models.FloatField(default=0)
