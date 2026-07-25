from django.utils.timezone import now
from django.utils.translation import gettext as _
from rest_framework import serializers

from apps.chat.models import Room, RoomUser, Message, SeenBy
from apps.recitation.models import Recitation, RecitationFault
from apps.recitation.serializers import BaseRecitationSerializer, RecitationFaultSerializer
from apps.records.models import Record
from apps.records.serializers import RecordField
from apps.settings.utils import get_setting
from apps.users.models import User, TeacherProfile, TeacherRecitationPricing
from apps.users.serializers import UserSerializer


class UsersField(serializers.RelatedField):
    def to_representation(self, value):
        return UserSerializer(instance=value).data

    def to_internal_value(self, data):
        if User.objects.filter(pk=data).exists():
            return User.objects.get(pk=data)
        raise serializers.ValidationError(_("User does not exist"))


class BaseRoomSerializer(serializers.ModelSerializer):
    name = serializers.CharField(max_length=255)
    users = UsersField(many=True, queryset=User.objects.all(), required=True)
    unseen_messages_count = serializers.SerializerMethodField()
    peers = serializers.SerializerMethodField()
    owner = UserSerializer(read_only=True)
    last_message = serializers.SerializerMethodField()
    seen_by = serializers.SerializerMethodField()

    class Meta:
        model = Room
        fields = ('id', 'uuid', 'name', 'room_type', 'is_closed', 'created_at', 'updated_at', 'is_group_room',
                  'last_message', 'unseen_messages_count', 'peers', 'owner', 'users', 'seen_by')
        read_only_fields = (
            'room_type', 'is_closed', 'created_at', 'updated_at', 'owner', 'is_group_room', 'last_message',
            'unseen_messages_count', 'peers', 'users', 'seen_by')

    def __init__(self, *args, **kwargs):
        self.room_type = kwargs.pop('room_type', None)  # todo: remove this line
        super(BaseRoomSerializer, self).__init__(*args, **kwargs)
        self.request_user = self.context['user']

    def get_seen_by(self, obj):
        return list(set(SeenBy.objects.filter(
            room=obj,
            message__isnull=True,
            seen_at__isnull=False).values_list('user__id', flat=True)))

    def get_unseen_messages_count(self, obj):
        return obj.unseen_messages(self.request_user).count()

    def get_last_message(self, obj):
        return BaseMessageSerializer(instance=obj.last_message,
                                     context={'user': self.request_user}).data if obj.last_message else None

    def get_peers(self, obj):
        return list(obj.peers(self.request_user).values_list('id', flat=True))

    def create(self, validated_data):
        owner = self.context['user']
        users = validated_data.pop('users')
        room = Room.objects.create(**validated_data, owner=owner)
        RoomUser.objects.create(room=room, user=owner)

        for user in users:
            RoomUser.objects.create(room=room, user=user)

        for user in users:
            SeenBy.objects.create(room=room, user=user, seen_at=None)
        return room


class RecitationField(serializers.RelatedField):
    def to_representation(self, value):
        return BaseRecitationSerializer(instance=value).data

    def to_internal_value(self, data):
        if Recitation.objects.filter(pk=data).exists():
            return Recitation.objects.get(id=data)
        raise serializers.ValidationError(_("Recitation does not exist"))


class RecitationRoomSerializer(BaseRoomSerializer):
    recitation = RecitationField(queryset=Recitation.objects.all(), required=True, source='content_object')

    class Meta(BaseRoomSerializer.Meta):
        model = Room
        fields = BaseRoomSerializer.Meta.fields + ('recitation',)
        read_only_fields = BaseRoomSerializer.Meta.read_only_fields + ('name',)

    def __init__(self, *args, **kwargs):
        super(RecitationRoomSerializer, self).__init__(*args, **kwargs)
        self.fields['name'].required = False

    def validate(self, attrs):
        recitation = attrs.get('content_object', None)
        if not recitation:
            raise serializers.ValidationError(_('Recitation is required!'))

        if recitation.is_closed or recitation.being_evaluated:
            raise serializers.ValidationError(_("This room is {message}!").format(
                message=_('Closed') if recitation.is_closed else _("being evaluated")
            ))

        if self.context['user'] in attrs.get('users'):
            raise serializers.ValidationError(_("You can't send the recitations to yourself!"))

        if self.context['user'].is_a_teacher:
            if any([user.is_a_teacher for user in attrs.get('users')]):
                raise serializers.ValidationError(_("You can't send the to another teacher, as you are a teacher!"))

            # if self.context['user'].teachernarration_set.filter(
            #         is_certified=True, narration_id=int(recitation.narration_id)
            # ).exists():
            #     # and all([user.favorite_teacher == self.context['user'] for user in attrs['users']]):
            #     # TODO Check why we use this condition
            #     raise serializers.ValidationError(_("You can't preform this action"))

            teacher_recitations_today_count = Room.objects.filter(
                created_at__date=now(),
                owner=self.request_user).count()
            general_box_daily_maximum = get_setting(
                'daily_max_number_of_recitations_a_teacher_can_pull_from_general_box')
            if teacher_recitations_today_count >= general_box_daily_maximum:
                raise serializers.ValidationError(_("You have exceeded the max number of recitations today"))

        return attrs

    def create(self, validated_data):
        validated_data['room_type'] = Room.ROOM_TYPE_RECITATION
        validated_data['name'] = validated_data['content_object'].name
        room = super(RecitationRoomSerializer, self).create(validated_data)
        recitation = room.content_object
        recitation.teacher = room.users.get(is_a_teacher=True)
        recitation.being_evaluated = True
        recitation.teacher_assigned_at = now()
        recitation.save()
        return room


class BaseMessageSerializer(serializers.ModelSerializer):
    room = serializers.PrimaryKeyRelatedField(queryset=Room.objects.all(), required=True)
    seen_by = serializers.SerializerMethodField()
    reply_to = serializers.PrimaryKeyRelatedField(queryset=Message.objects.all(), required=False)
    record = RecordField(queryset=Record.objects.all(), required=False)
    fault = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = Message
        fields = ('id', 'room', 'reply_to', 'text', 'record', 'user', 'seen_by', 'is_sent', 'sent_at', 'fault')
        read_only_fields = ('user', 'seen_by', 'is_sent', 'sent_at', 'fault')

    def __init__(self, *args, **kwargs):
        super(BaseMessageSerializer, self).__init__(*args, **kwargs)

    def get_seen_by(self, obj):
        return list(set(SeenBy.objects.filter(message=obj, seen_at__isnull=False).values_list('user__id', flat=True)))

    def get_fault(self, obj):
        return RecitationFaultSerializer(obj.recitationfault).data if hasattr(obj, 'recitationfault') else None

    def create(self, validated_data):
        room = validated_data.get('room')
        is_sent = True
        if room.room_type == Room.ROOM_TYPE_RECITATION:
            is_sent = True if room.content_object.evaluated_at else False
        message = Message.objects.create(**validated_data, user=self.context['user'], sent_at=now(), is_sent=is_sent)
        for user in room.users.exclude(pk=self.context['user'].pk):
            SeenBy.objects.create(room=room, user=user, message=message, seen_at=None)
        if 'record' in validated_data and validated_data['record']:
            validated_data['record'].content_object = message
            validated_data['record'].allowed_users.set(room.users.all())
            validated_data['record'].save()
        return message


class RecitationMessageSerializer(BaseMessageSerializer):
    recitation = serializers.BooleanField(required=True, write_only=True)
    fault_type = serializers.ChoiceField(choices=RecitationFault.FAULT_TYPES,
                                         required=False,
                                         write_only=True)
    error_text = serializers.CharField(required=False, write_only=True)
    position_from = serializers.IntegerField(required=False, write_only=True)
    position_to = serializers.IntegerField(required=False, write_only=True)

    class Meta(BaseMessageSerializer.Meta):
        fields = BaseMessageSerializer.Meta.fields + (
            'recitation', 'fault_type', 'error_text', 'position_from', 'position_to')

    # def validate(self, attrs):
    # #     if attrs.get('recitation', False) and not attrs.get('fault_type', None):
    # #         raise serializers.ValidationError(_('Fault type is required'))
    # #
    #     if attrs.get('error_text', None) and not attrs.get('fault_type', None):
    #         raise serializers.ValidationError(_('Fault type is required'))
    #     return attrs

    def create(self, validated_data):
        data = {
            'room': validated_data.get('room'),
            'user': self.context['user'],
            'text': validated_data.get('text'),
            'record': validated_data.get('record'),
            'sent_at': None,
            'is_sent': False
        }
        message = Message.objects.create(**data)
        recitation = message.room.content_object
        if "fault_type" in validated_data:
            # TODO check this condition
            fault_data = {"recitation": recitation, "message": message, 'fault_type': validated_data.get('fault_type')}
            if 'error_text' in validated_data:
                fault_data['error_text'] = validated_data.get('error_text')
            if 'position_from' in validated_data:
                fault_data['position_from'] = validated_data.get('position_from')
            if 'position_to' in validated_data:
                fault_data['position_to'] = validated_data.get('position_to')

            RecitationFault.objects.create(**fault_data)
        return message
