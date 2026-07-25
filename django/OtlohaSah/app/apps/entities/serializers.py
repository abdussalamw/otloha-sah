from django.db import transaction
from rest_framework import serializers

from apps.entities.models import Entity, EntityUserRole
from apps.users_profiles.serializers.serializers import CheckValueMixin


class EntityListSerializer(serializers.ModelSerializer, CheckValueMixin):
    invitations = serializers.SerializerMethodField()
    relationships = serializers.SerializerMethodField()

    class Meta:
        model = Entity
        fields = ['id', 'name', 'org_name', 'phone', 'bio', 'email', 'logo', 'invitations', 'relationships']
        read_only_fields = ['id']

    def check_request_value(self, obj, request_type):
        if hasattr(obj, request_type) and getattr(obj, request_type) != None and (getattr(obj, request_type) > 0):
            return getattr(obj, request_type)
        return None

    def get_invitations(self, obj):
        return {
            "out_join_entity_request": self.check_request_value(obj, "out_join_entity_request"),
            "in_join_entity_request": self.check_request_value(obj, "in_join_entity_request"),
            "out_entity_merge_request": self.check_request_value(obj, "out_entity_merge_request"),
            "in_entity_merge_request": self.check_request_value(obj, "in_entity_merge_request"),
        }

    def get_relationships(self, obj):
        return {
            "member_in_entity": self.check_request_value_relationship(obj, "member_in_entity"),
        }


class EntitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Entity
        fields = ['id', 'name', 'org_name', 'phone', 'bio', 'email', 'logo']
        read_only_fields = ['id']

    @transaction.atomic
    def create(self, validated_data):
        try:
            entity_instance = super().create(validated_data)
            self.assign_owner(self.context['request'], entity_instance)
            return entity_instance
        except Exception as e:
            raise serializers.ValidationError({"message": f"You are not allowed to do this action!."})

    def assign_owner(self, request, entity_instance):
        data = {"user": request.user.pk, "entity": entity_instance.pk, "role": 'owner'}
        owner_serializer = EntityAddOwnerSerializer(data=data)
        owner_serializer.is_valid(raise_exception=True)
        owner_serializer.save()


class EntityUserRoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = EntityUserRole
        fields = ['id', 'user', 'role']

        def __init__(self, *args, **kwargs):
            self.entity = kwargs.pop('entity')
            super().__init__(*args, **kwargs)

        def update(self, instance, validated_data):
            pass


class EntityAddOwnerSerializer(serializers.ModelSerializer):
    class Meta:
        model = EntityUserRole
        fields = ('id', 'user', 'entity', 'role')
