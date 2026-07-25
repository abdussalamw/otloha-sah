from django.shortcuts import get_object_or_404
from rest_framework import serializers
from rest_framework.views import APIView

from apps.entities.models import EntityUserRole
from apps.invitations.models import Invitation
from apps.khatma.models import KhatmaUsers
from apps.recitation.models import Recitation
from apps.tajweed.models import TajweedUserProgress
from apps.users.models import Teacher
from apps.users.models import User, TeacherNarration
from quran_api_client.models import Narration


class CheckValueMixin(APIView):

    def check_request_value(self, obj, request_type):
        if hasattr(obj, request_type) and getattr(obj, request_type) != None and (getattr(obj, request_type) > 0):
            return getattr(obj, request_type)
        return None

    def check_request_value_relationship(self, obj, request_type):
        return hasattr(obj, request_type) and getattr(obj, request_type) != None and (getattr(obj, request_type) > 0)


class UserListSerializer(serializers.ModelSerializer):
    narration = serializers.SerializerMethodField()
    image = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'username', 'image', 'email', 'rate', 'language', 'narration', 'is_a_teacher']

    def get_narration(self, obj):
        narration_id = obj.narration_id
        narration = get_object_or_404(Narration, id=narration_id)
        return str(narration)

    def get_image(self, obj):
        return self.context['request'].build_absolute_uri(obj.profile_image)


class StudentListSerializer(UserListSerializer, CheckValueMixin):
    invitations = serializers.SerializerMethodField()
    relationships = serializers.SerializerMethodField()
    favorite_teacher = serializers.SerializerMethodField()

    class Meta(UserListSerializer.Meta):
        fields = UserListSerializer.Meta.fields + ['favorite_teacher', 'invitations', 'relationships']

    def get_invitations(self, obj):
        return {
            "out_join_entity_request": self.check_request_value(obj, "out_join_entity_request"),
            "in_join_entity_request": self.check_request_value(obj, "in_join_entity_request"),
            "out_friend_request": self.check_request_value(obj, "out_friend_request"),
            "in_friend_request": self.check_request_value(obj, "in_friend_request"),
            "out_supervision_request": self.check_request_value(obj, "out_supervision_request"),
            "in_supervision_request": self.check_request_value(obj, "in_supervision_request"),
        }

    def get_relationships(self, obj):
        return {
            "member_in_entity": self.check_request_value_relationship(obj, "member_in_entity"),
            "supervision": self.check_request_value_relationship(obj, "supervision"),
            "friend": self.check_request_value_relationship(obj, "friend"),
        }

    def get_narrations(self, obj):
        narrations = obj.teachernarration_set.all()
        return TeacherNarrationSerializer(narrations, many=True).data

    def get_favorite_teacher(self, obj):
        if obj.favorite_teacher_id:
            return Teacher.objects.filter(pk=obj.favorite_teacher_id).first().username


class FriendListSerializer(UserListSerializer, CheckValueMixin):
    invitations = serializers.SerializerMethodField()
    relationships = serializers.SerializerMethodField()
    favorite_teacher = serializers.SerializerMethodField()

    class Meta(UserListSerializer.Meta):
        fields = UserListSerializer.Meta.fields + ['favorite_teacher', 'invitations', 'relationships']

    def get_invitations(self, obj):
        return {
            "out_supervision_request": self.check_request_value(obj, "out_supervision_request"),
            "in_supervision_request": self.check_request_value(obj, "in_supervision_request"),
        }

    def get_relationships(self, obj):
        return {
            "supervision": self.check_request_value_relationship(obj, "supervision"),
        }

    def get_favorite_teacher(self, obj):
        if obj.favorite_teacher_id:
            return Teacher.objects.filter(pk=obj.favorite_teacher_id).first().username


class TeacherListSerializer(serializers.ModelSerializer, CheckValueMixin):
    narrations = serializers.SerializerMethodField()
    invitations = serializers.SerializerMethodField()
    relationships = serializers.SerializerMethodField()
    image = serializers.SerializerMethodField()

    class Meta:
        model = Teacher
        fields = ['id', 'username', 'image', 'email', 'rate', 'language', 'narrations', 'invitations',
                  'relationships', 'is_a_teacher']

    def get_narrations(self, obj):
        narrations = obj.teachernarration_set.all()
        return TeacherNarrationSerializer(narrations, many=True).data

    def get_invitations(self, obj):
        return {
            "out_join_entity_request": self.check_request_value(obj, "out_join_entity_request"),
            "in_join_entity_request": self.check_request_value(obj, "in_join_entity_request"),
            "out_friend_request": self.check_request_value(obj, "out_friend_request"),
            "in_friend_request": self.check_request_value(obj, "in_friend_request"),
            "out_supervision_request": self.check_request_value(obj, "out_supervision_request"),
            "in_supervision_request": self.check_request_value(obj, "in_supervision_request"),
        }

    def get_relationships(self, obj):
        return {
            "member_in_entity": self.check_request_value_relationship(obj, "member_in_entity"),
            "supervision": self.check_request_value_relationship(obj, "supervision"),
            "friend": self.check_request_value_relationship(obj, "friend"),
        }

    def get_image(self, obj):
        return self.context['request'].build_absolute_uri(obj.profile_image)

class BaseUserDetailsSerializer(serializers.ModelSerializer):
    narration = serializers.SerializerMethodField()
    entities = serializers.SerializerMethodField()
    recitation = serializers.SerializerMethodField()
    certified = serializers.SerializerMethodField()
    khatma = serializers.SerializerMethodField()
    tajweed = serializers.SerializerMethodField()
    level = serializers.SerializerMethodField()
    image = serializers.SerializerMethodField()
    invitations = serializers.SerializerMethodField()
    relationships = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ['id', 'recitation', 'khatma', 'tajweed', 'username', 'image', 'rate', 'certified', 'language',
                  'narration', 'bio', 'level', 'narration', 'phone', 'entities', 'favorite_teacher', 'is_a_teacher',
                  'invitations', 'relationships']

    def get_image(self, obj):
        return self.context['request'].build_absolute_uri(obj.profile_image)

    def get_level(self, obj):
        return obj.get_level_text

    def get_narration(self, obj):
        narration_id = obj.narration_id
        narration = get_object_or_404(Narration, id=narration_id)
        return str(narration)

    def get_tajweed(self, obj):
        tajweed = TajweedUserProgress.objects.filter(user=obj)
        return tajweed.count()

    def get_entities(self, obj):
        entities = EntityUserRole.objects.filter(user=obj)
        return entities.count()

    def get_recitation(self, obj):
        recitations = Recitation.objects.filter(owner=obj, result='accepted')
        return recitations.count()

    def get_khatma(self, obj):
        khatma = KhatmaUsers.objects.filter(user=obj)
        return khatma.count()

    def get_certified(self, obj):
        return TeacherNarration.objects.filter(teacher=obj).exists()

    def get_invitations(self, obj):
        return {
            "out_join_entity_request": self.check_request_value(obj, "out_join_entity_request"),
            "in_join_entity_request": self.check_request_value(obj, "in_join_entity_request"),
            "out_friend_request": self.check_request_value(obj, "out_friend_request"),
            "in_friend_request": self.check_request_value(obj, "in_friend_request"),
            "out_supervision_request": self.check_request_value(obj, "out_supervision_request"),
            "in_supervision_request": self.check_request_value(obj, "in_supervision_request"),
        }

    def get_relationships(self, obj):
        return {
            "member_in_entity": self.check_request_value_relationship(obj, "member_in_entity"),
            "supervision": self.check_request_value_relationship(obj, "supervision"),
            "friend": self.check_request_value_relationship(obj, "friend"),
        }


class StudentDetailsSerializer(BaseUserDetailsSerializer):
    favorite_teacher = serializers.SerializerMethodField()
    image = serializers.SerializerMethodField()

    class Meta(BaseUserDetailsSerializer.Meta):
        fields = ['id', 'email', 'birthdate', 'gender', 'recitation', 'khatma', 'username', 'image', 'rate',
                  'language', 'narration', 'bio',
                  'level',
                  'narration', 'phone', 'entities', 'favorite_teacher', 'is_a_teacher']

    def get_favorite_teacher(self, obj):
        if obj.favorite_teacher_id:
            return Teacher.objects.filter(pk=obj.favorite_teacher_id).first().username

    def get_image(self, obj):
        return self.context['request'].build_absolute_uri(obj.profile_image)


class TeacherDetailsSerializer(BaseUserDetailsSerializer):
    image = serializers.SerializerMethodField()

    class Meta(BaseUserDetailsSerializer.Meta):
        fields = ['id', 'khatma', 'username', 'image', 'certified', 'rate', 'language', 'narration', 'bio',
                  'level',
                  'phone', 'narration', 'entities']

    def get_narrations(self, obj):
        narrations = obj.teachernarration_set.all()
        return TeacherNarrationSerializer(narrations, many=True).data

    def get_image(self, obj):
        return self.context['request'].build_absolute_uri(obj.profile_image)


class StudentProfileDetailsSerializer(BaseUserDetailsSerializer, CheckValueMixin):
    invitations = serializers.SerializerMethodField()
    relationships = serializers.SerializerMethodField()
    favorite_teacher = serializers.SerializerMethodField()
    image = serializers.SerializerMethodField()

    class Meta(BaseUserDetailsSerializer.Meta):
        fields = ['id', 'recitation', 'khatma', 'username', 'image', 'rate', 'language', 'narration', 'bio',
                  'level',
                  'narration', 'favorite_teacher', 'entities', 'is_a_teacher', 'invitations', 'relationships']

    def get_invitations(self, obj):
        return {
            "out_join_entity_request": self.check_request_value(obj, "out_join_entity_request"),
            "in_join_entity_request": self.check_request_value(obj, "in_join_entity_request"),
            "out_friend_request": self.check_request_value(obj, "out_friend_request"),
            "in_friend_request": self.check_request_value(obj, "in_friend_request"),
            "out_supervision_request": self.check_request_value(obj, "out_supervision_request"),
            "in_supervision_request": self.check_request_value(obj, "in_supervision_request"),
        }

    def get_relationships(self, obj):
        return {
            "member_in_entity": self.check_request_value_relationship(obj, "member_in_entity"),
            "supervision": self.check_request_value_relationship(obj, "supervision"),
            "friend": self.check_request_value_relationship(obj, "friend"),
        }

    def get_favorite_teacher(self, obj):
        if obj.favorite_teacher_id:
            return Teacher.objects.filter(pk=obj.favorite_teacher_id).first().username

    def get_image(self, obj):
        return self.context['request'].build_absolute_uri(obj.profile_image)


class TeacherProfileDetailsSerializer(BaseUserDetailsSerializer, CheckValueMixin):
    narration = serializers.SerializerMethodField()
    invitations = serializers.SerializerMethodField()
    relationships = serializers.SerializerMethodField()
    image = serializers.SerializerMethodField()

    class Meta(BaseUserDetailsSerializer.Meta):
        fields = ['id', 'username', 'khatma', 'image', 'certified', 'rate', 'language', 'narration', 'bio',
                  'level',
                  'narration', 'entities', 'invitations', 'relationships']

    def get_invitations(self, obj):
        return {
            "out_join_entity_request": self.check_request_value(obj, "out_join_entity_request"),
            "in_join_entity_request": self.check_request_value(obj, "in_join_entity_request"),
            "out_friend_request": self.check_request_value(obj, "out_friend_request"),
            "in_friend_request": self.check_request_value(obj, "in_friend_request"),
            "out_supervision_request": self.check_request_value(obj, "out_supervision_request"),
            "in_supervision_request": self.check_request_value(obj, "in_supervision_request"),
        }

    def get_relationships(self, obj):
        return {
            "member_in_entity": self.check_request_value_relationship(obj, "member_in_entity"),
            "supervision": self.check_request_value_relationship(obj, "supervision"),
            "friend": self.check_request_value_relationship(obj, "friend"),
        }

    def get_narration(self, obj):
        narrations = obj.teachernarration_set.all()
        return TeacherNarrationSerializer(narrations, many=True).data

    def get_image(self, obj):
        return self.context['request'].build_absolute_uri(obj.profile_image)


class TeacherNarrationSerializer(serializers.ModelSerializer):
    class Meta:
        model = TeacherNarration
        fields = ['narration', 'is_certified']


class InvitationSerializer(serializers.ModelSerializer):
    incoming = serializers.SerializerMethodField()

    class Meta:
        model = Invitation
        fields = ("id", "invitation_type", "status", "incoming")

    def get_incoming(self, obj):
        return obj.requestee == self.context['user_id']
