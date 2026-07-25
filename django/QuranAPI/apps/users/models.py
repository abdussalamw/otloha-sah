from datetime import date

from django.conf import settings
from django.contrib.auth.base_user import AbstractBaseUser, BaseUserManager
from django.contrib.auth.models import AbstractUser
from django.contrib.auth.models import Group
from django.contrib.auth.validators import UnicodeUsernameValidator
from django.core.mail import send_mail
from django.db import models
from django.dispatch import receiver
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from django_rest_passwordreset.signals import reset_password_token_created


class UserManager(BaseUserManager):
    """Define a model manager for User model with no username field."""
    use_in_migrations = True

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


class User(AbstractUser):
    GENDER_MALE = 'male'
    GENDER_FEMALE = 'female'
    GENDERS = (
        (GENDER_MALE, _('Male')),
        (GENDER_FEMALE, _('Female')))

    IS_ACTIVE = (
        (True, _('Yes')),
        (False, _('No')))

    IS_STAFF = (
        (True, _('Yes')),
        (False, _('No')))

    def get_upload_to(self, filename):
        date_image = date.today().strftime("/%Y/%d/%m/")
        return 'users/{}-{}'.format(date_image, filename)

    class Meta:
        order_with_respect_to = "username"

    objects = UserManager()

    EMAIL_FIELD = 'email'
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['phone']

    username_validator = UnicodeUsernameValidator()
    username = models.CharField(_('username'), max_length=150,
                                help_text=_('Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.'),
                                validators=[username_validator])
    email = models.EmailField(_('email address'), unique=True, blank=False, null=False)

    email_verified_at = models.DateTimeField(blank=True, null=True)
    birth_date = models.DateTimeField(blank=True, null=True)
    phone = models.CharField(
        max_length=20,
        blank=False,
        null=False,
        unique=True,
        verbose_name=_("phone"),
        error_messages={'unique': _("A user with that phone already exists.")})
    phone_verified_at = models.DateTimeField(blank=True, null=True)
    gender = models.CharField(max_length=100, blank=True, null=True, choices=GENDERS)
    locale = models.CharField(max_length=100, default=settings.LANGUAGE_ARABIC, blank=False, null=False,
                              choices=settings.LANGUAGES)
    image = models.ImageField(upload_to=get_upload_to, default='default/images/profile.png', null=True, blank=True)
    groups = models.ManyToManyField(Group, verbose_name=_("group"), blank=True)

    def __str__(self):
        return self.username

    @property
    def get_profile_url(self):
        return reverse("admin:users:update", kwargs={"user_id": self.id})

    # @property
    # def get_detail_url(self):
    #     return reverse('users:details', args=[self.id])

    @property
    def is_verified(self):
        return self.phone_verified_at is not None and self.email_verified_at is not None


@receiver(reset_password_token_created)
def password_reset_token_created(sender, instance, reset_password_token, *args, **kwargs):

    email_plaintext_message = "{}?token={}".format(reverse('api-v1:users:auth:password_reset:reset-password-request'),
                                                   reset_password_token.key)

    send_mail(
        # title:
        "Password Reset for {title}".format(title="QuranAPI"),
        # message:
        email_plaintext_message,
        # from:
        "noreply@somehost.local",
        # to:
        [reset_password_token.user.email]
    )
