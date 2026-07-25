from django.db.models import Q
from django.shortcuts import get_object_or_404
from django.utils.translation import gettext as _
from rest_framework import serializers
from rest_framework.exceptions import ValidationError

from apps.entities.models import Entity, EntityUserRole
from apps.entities.permissions import IsEntityOwner
from apps.invitations import config, invitations_handler
from apps.invitations.models import Invitation, BlockList, BanedInvitation
from apps.khatma.models import Khatma
from apps.users.models import User


class RequesteeField(serializers.Field):
    def to_representation(self, value):
        return value

    def to_internal_value(self, data):
        requestee_type = self.context['request'].data.get('requestee_type')
        try:
            if requestee_type == config.INVITATION_USER_TYPE_ENTITY:
                entity = Entity.objects.get(pk=data)
                return entity
            if requestee_type == config.INVITATION_USER_TYPE_KHATMA:
                khatma = Khatma.objects.get(pk=data)
                return khatma
            else:
                user = User.objects.get(pk=data)
                return user
        except (Entity.DoesNotExist, User.DoesNotExist):
            raise ValidationError("Specified entity or user does not exist.")


class InvitationSerializer(serializers.ModelSerializer):
    requestee = RequesteeField()

    class Meta:
        model = Invitation
        fields = ("id", "requester", "requester_type", "requestee", "requestee_type", "invitation_type",)
        read_only_fields = ("requester", "requester_type",)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.handler = None

    def validate(self, attrs):
        request = self.context['request']
        entity_id = request.headers.get('X-Entity-Id', None)
        requester_type = config.INVITATION_USER_TYPE_ENTITY if request.headers.get('X-Entity-Id', None) \
            else config.INVITATION_USER_TYPE_USER

        requestee = attrs.get('requestee')
        invitation_type = attrs.get('invitation_type')
        self.handler = invitations_handler.INVITATION_REQUEST_HANDLER[invitation_type](request)
        status, message = self.handler.check(attrs)
        if not status:
            raise serializers.ValidationError(message)

        if requester_type == config.INVITATION_USER_TYPE_ENTITY:
            if Invitation.objects.filter(
                    Q(requester=entity_id, requestee=requestee.pk,
                      invitation_type=invitation_type)
                    | Q(requester=requestee.pk, requestee=entity_id,
                        invitation_type=invitation_type)).exists():
                raise serializers.ValidationError(_("There is already a pending invitation"))
            if requestee.pk == int(entity_id):
                raise serializers.ValidationError(_("Can not send invitation to yourself"))

        elif requester_type == config.INVITATION_USER_TYPE_USER:
            if requester_type == config.INVITATION_USER_TYPE_USER and Invitation.objects.filter(
                    Q(requester=request.user.pk, requestee=requestee.pk,
                      invitation_type=invitation_type)
                    | Q(requester=requestee.pk, requestee=request.user.pk,
                        invitation_type=invitation_type)).exists():
                raise serializers.ValidationError(_("There is already a pending invitation"))

            if requestee.pk == request.user.pk and attrs.get('requestee_type') == requester_type:
                raise serializers.ValidationError(_("Can not send invitation to yourself"))

        return attrs

    def create(self, validated_data):
        return self.handler.save(validated_data)


class ResponseInvitationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Invitation
        fields = ("id", "requester", "requester_type", "requestee", "requestee_type", "invitation_type",)
        read_only_fields = ("requester", "requester_type", "requestee", "requestee_type", "invitation_type")

    def create(self, validated_data):
        return self.handler.save(validated_data)


class BlockListSerializer(serializers.ModelSerializer):
    class Meta:
        model = BlockList
        fields = ("id", "blocker", "blocker_type", "blocked", "blocked_type")
        read_only_fields = ("blocker", "blocker_type")

    def validate(self, attrs):
        request = self.context['request']
        blocker = request.user.pk
        blocker_type = config.INVITATION_USER_TYPE_USER
        entity_id = request.headers.get('X-Entity-Id', None)
        if entity_id:
            blocker = entity_id
            blocker_type = config.INVITATION_USER_TYPE_ENTITY

            if not Entity.objects.filter(id=entity_id).exists():
                raise serializers.ValidationError(_("Your entity does not exist"))

            if attrs.get('blocked_type') == config.INVITATION_USER_TYPE_USER:
                if not User.objects.filter(id=attrs.get('blocked')).exists():
                    raise serializers.ValidationError(_("This user does not exist"))
                EntityUserRole.objects.filter(user_id=attrs.get('blocked'), entity_id=blocker).delete()

            if attrs.get('blocked_type') == config.INVITATION_USER_TYPE_ENTITY and not Entity.objects.filter(
                    id=attrs.get('blocked')).exists():
                raise serializers.ValidationError(_("This entity does not exist"))

        else:
            if not User.objects.filter(id=blocker).exists():
                raise serializers.ValidationError(_("This user does not exist"))

            if attrs.get('blocked_type') == config.INVITATION_USER_TYPE_ENTITY:
                if not Entity.objects.filter(id=attrs.get('blocked')).exists():
                    raise serializers.ValidationError(_("This entity does not exist"))
                EntityUserRole.objects.filter(user_id=blocker, entity_id=attrs.get('blocked')).delete()

            if attrs.get('blocked_type') == config.INVITATION_USER_TYPE_USER:
                if not User.objects.filter(id=attrs.get('blocked')).exists():
                    raise serializers.ValidationError(_("This user does not exist"))

                user = get_object_or_404(User, pk=blocker)
                friend = get_object_or_404(User, pk=attrs.get('blocked'))
                user.connections.remove(friend)
                if user.favorite_teacher == friend:
                    user.favorite_teacher = None
                    user.save()
                if friend.favorite_teacher == user:
                    friend.favorite_teacher = None
                    friend.save()

        if BlockList.objects.filter(blocker=blocker, blocked=attrs.get('blocked')).exists():
            raise serializers.ValidationError(_("This actor is already blocked"))

        attrs['blocker'] = blocker
        attrs['blocker_type'] = blocker_type
        return attrs


class BanedInvitationSerializer(serializers.ModelSerializer):
    class Meta:
        model = BanedInvitation
        fields = ("id", "blocker", "blocker_type", "blocked", "blocked_type", "invitation_type",)
        read_only_fields = ("blocker", "blocker_type")

    def validate(self, attrs):
        request = self.context['request']
        blocker = request.user.pk
        entity_id = request.headers.get('X-Entity-Id', None)
        blocker_type = config.INVITATION_USER_TYPE_USER
        if entity_id:
            blocker = entity_id
            blocker_type = config.INVITATION_USER_TYPE_ENTITY
            if not Entity.objects.filter(id=entity_id).exists():
                raise serializers.ValidationError(_("Your entity does not exist"))
            elif not IsEntityOwner().has_permission(request, self):
                raise serializers.ValidationError(_("You are not the owner of this entity"))
        else:
            if not User.objects.filter(id=blocker).exists():
                raise serializers.ValidationError(_("This user does not exist"))
        self.handel_invitation_type(attrs)
        if attrs.get('blocked_type') == config.INVITATION_USER_TYPE_USER and not User.objects.filter(
                id=attrs.get('blocked')).exists():
            raise serializers.ValidationError(_("This user does not exist"))

        if attrs.get('blocked_type') == config.INVITATION_USER_TYPE_ENTITY and not Entity.objects.filter(
                id=attrs.get('blocked')).exists():
            raise serializers.ValidationError(_("This entity does not exist"))

        if BanedInvitation.objects.filter(blocker=blocker, blocked=attrs.get('blocked'), blocker_type=blocker_type,
                                          blocked_type=attrs.get('blocked_type'),
                                          invitation_type=attrs.get('invitation_type')).exists():
            raise serializers.ValidationError(_("This actor is already baned"))

        attrs['blocker'] = blocker
        attrs['blocker_type'] = blocker_type

        return attrs

    def handel_invitation_type(self, attrs):
        request = self.context['request']
        entity_id = request.headers.get('X-Entity-Id', None)
        invitation_type = attrs.get('invitation_type')
        blocked_type = attrs.get("blocked_type")
        entity_id and self.validate_entity_block_request(invitation_type, blocked_type)
        not entity_id and self.validate_user_block_request(invitation_type, blocked_type)

    @staticmethod
    def validate_entity_block_request(blocked_type, invitation_type):
        if ((blocked_type == config.INVITATION_USER_TYPE_ENTITY and invitation_type \
             not in config.ENTITY_TO_ENTITY_ALLOWED_INVITATION_TYPES)
                or invitation_type not in config.ENTITY_ALLOWED_INVITATION_TYPES):
            raise serializers.ValidationError(_("Wrong invitation type."))

    @staticmethod
    def validate_user_block_request(invitation_type, blocked_type):
        if (invitation_type not in config.USER_ALLOWED_INVITATION_TYPES or
                (blocked_type == config.INVITATION_USER_TYPE_ENTITY and invitation_type \
                 not in config.USER_TO_ENTITY_ALLOWED_INVITATION_TYPES) or (
                        blocked_type == config.INVITATION_USER_TYPE_USER and invitation_type \
                        not in config.USER_TO_USER_ALLOWED_INVITATION_TYPES)):
            raise serializers.ValidationError(_("Wrong invitation type."))
