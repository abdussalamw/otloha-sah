from django.shortcuts import get_object_or_404
from rest_framework import serializers

from apps.entities.models import Entity
from apps.entities.serializers import EntitySerializer
from apps.invitations.models import Invitation, BlockList, BanedInvitation
from apps.users.models import User
from apps.users_profiles.serializers.serializers import UserListSerializer


class InvitationProfileSerializer(serializers.ModelSerializer):
    requestee_data = serializers.SerializerMethodField()

    class Meta:
        model = Invitation
        fields = ("id", "invitation_type", "requestee_data",)

    def get_requestee_data(self, obj):
        requestee_id = obj.requestee
        if obj.requestee_type == 'user':
            requestee = get_object_or_404(User, id=requestee_id)
            serializer = UserListSerializer(requestee)
            return serializer.data
        elif obj.requestee_type == 'entity':
            requestee = get_object_or_404(Entity, id=requestee_id)
            serializer = EntitySerializer(requestee)
            return serializer.data


class BlockListProfileSerializer(serializers.ModelSerializer):
    profile_data = serializers.SerializerMethodField()

    class Meta:
        model = BlockList
        fields = ("id", "profile_data")

    def get_profile_data(self, obj):
        blocked_id = obj.blocked
        if obj.blocked_type == 'user':
            blocked = get_object_or_404(User, id=blocked_id)
            serializer = UserListSerializer(blocked)
            return serializer.data
        elif obj.blocked_type == 'entity':
            blocked = get_object_or_404(Entity, id=blocked_id)
            serializer = EntitySerializer(blocked)
            return serializer.data


class BanedInvitationProfileSerializer(serializers.ModelSerializer):
    profile_data = serializers.SerializerMethodField()

    class Meta:
        model = BanedInvitation
        fields = ("id", "invitation_type", "profile_data")

    def get_profile_data(self, obj):
        blocked_id = obj.blocked
        if obj.blocked_type == 'user':
            blocked = get_object_or_404(User, id=blocked_id)
            serializer = UserListSerializer(blocked)
            return serializer.data
        elif obj.blocked_type == 'entity':
            blocked = get_object_or_404(Entity, id=blocked_id)
            serializer = EntitySerializer(blocked)
            return serializer.data


class InvitationReceivedProfileSerializer(serializers.ModelSerializer):
    requester_data = serializers.SerializerMethodField()

    class Meta:
        model = Invitation
        fields = ("id", "invitation_type", "requester_data",)

    def get_requester_data(self, obj):
        requester_id = obj.requester
        if obj.requester_type == 'user':
            requester = get_object_or_404(User, id=requester_id)
            serializer = UserListSerializer(requester, context=self.context)
            return serializer.data
        elif obj.requester_type == 'entity':
            requester = get_object_or_404(Entity, id=requester_id)
            serializer = EntitySerializer(requester, context=self.context)
            return serializer.data
