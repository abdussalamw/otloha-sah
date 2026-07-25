from django.db import models
from django.db.models import Exists, OuterRef, Q

from apps.invitations import config
from apps.invitations.models import BlockList


class EntityQuerySet(models.QuerySet):
    def unblocked_unblocker_entities(self, user):
        blocked_entities_subquery = BlockList.objects.filter(
            Q(blocker=user.pk, blocker_type=config.INVITATION_USER_TYPE_USER,
              blocked_type=config.INVITATION_USER_TYPE_ENTITY) |
            Q(blocked=user.pk, blocked_type=config.INVITATION_USER_TYPE_USER,
              blocker_type=config.INVITATION_USER_TYPE_ENTITY)
        ).values('blocked', 'blocker')

        unblocked_unblocker_entities = self.annotate(
            has_block=Exists(blocked_entities_subquery.filter(Q(blocked=OuterRef('id')) | Q(blocker=OuterRef('id'))))
        ).exclude(has_block=True)

        return unblocked_unblocker_entities

class EntityManager(models.Manager):

    def get_queryset(self):
        return EntityQuerySet(model=self.model, using=self._db)

    def unblocked_unblocker_entities(self, user):
        return self.get_queryset().unblocked_unblocker_entities(user)
