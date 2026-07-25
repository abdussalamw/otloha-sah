from django.core.validators import EmailValidator
from django.db import models
from django.utils.translation import gettext_lazy as _
from phonenumber_field.modelfields import PhoneNumberField

from apps.entities.entity import EntityManager, EntityQuerySet
from apps.notifications.models import Notifying


class Entity(Notifying):
    objects = EntityManager.from_queryset(EntityQuerySet)()

    SEARCH_INDEX = {
        "fields": {
            "id": "A",
            "email": "A",
            "phone": "A",
            "name": "A",
            "org_name": "A",
        }
    }

    class Meta:
        verbose_name = _("Entity")
        verbose_name_plural = _("Entities")
        indexes = [
            models.Index(fields=['name'], name='name_index')
        ]

    email_validator = EmailValidator()

    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=128)
    org_name = models.CharField(max_length=32, null=True, unique=True)
    phone = PhoneNumberField(
        blank=True,
        null=True,
        default=None,
        error_messages={'unique': _("A user with that phone already exists.")})

    phone_verified = models.BooleanField(default=False)
    email = models.EmailField(_('email address'),
                              validators=[email_validator],
                              unique=True, blank=False, null=True)
    email_verified = models.BooleanField(default=False)
    logo = models.ImageField(upload_to='entity_logos/', null=True, blank=True)
    bio = models.CharField(_("Bio"), max_length=100, null=True, blank=True)

    created_at = models.DateTimeField(auto_now_add=True, blank=True, null=True)
    updated_at = models.DateTimeField(auto_now=True, blank=True, null=True)

    def __str__(self):
        return self.name


class EntityUserRole(models.Model):
    ROLE_CHOICE_OWNER = 'owner'
    ROLE_CHOICE_MODERATOR = 'moderator'
    ROLE_CHOICE_USER = 'user'
    ROLE_CHOICES = (
        (ROLE_CHOICE_OWNER, _('Owner')),
        (ROLE_CHOICE_MODERATOR, _('Moderator')),
        (ROLE_CHOICE_USER, _('User')),
    )
    user = models.ForeignKey("users.User", on_delete=models.CASCADE)
    entity = models.ForeignKey(Entity, on_delete=models.CASCADE)
    role = models.CharField(max_length=32, choices=ROLE_CHOICES, default=ROLE_CHOICE_USER)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['user', 'entity'], name='unique_user_entity'),

            models.UniqueConstraint(fields=['entity', 'role'], condition=models.Q(role='owner'), name='unique_owner'),
            models.UniqueConstraint(fields=['entity', 'role'], condition=models.Q(role='moderator'),
                                    name='unique_moderator'),
            models.UniqueConstraint(fields=['entity', 'user'], condition=models.Q(role='owner'),
                                    name='user_owner_unique'),
            models.UniqueConstraint(fields=['user'], condition=models.Q(role='owner'), name='user_owner_constraint'),
        ]
