from rest_framework import permissions
from rest_framework.generics import get_object_or_404

from apps.entities.models import Entity, EntityUserRole


class IsEntityOwner(permissions.BasePermission):

    def has_permission(self, request, view):
        entity_id = request.headers.get('X-Entity-Id', None)
        if not entity_id:
            return False
        entity = get_object_or_404(Entity, pk=entity_id)
        if entity.entityuserrole_set.filter(role=EntityUserRole.ROLE_CHOICE_OWNER, user=request.user).exists():
            request.entity = entity
            return True
        return False
