from rest_framework import serializers

from apps.khatma.models import Khatma, KhatmaUsers

from django.db.models import Count, F, ExpressionWrapper, FloatField, Q
from rest_framework import serializers

from apps.recitations import config
from apps.users_profiles.serializers.serializers import UserListSerializer


class KhatmaUsersDetailsSerializer(serializers.ModelSerializer):
    user_data = serializers.SerializerMethodField()

    class Meta:
        model = KhatmaUsers
        fields = [
            'khatma',
            'user_data',
            'is_teacher',
            'from_chapter',
            'to_chapter',
            'from_verse',
            'to_verse',
            'created_at',
        ]

    def get_user_data(self, obj):
        return UserListSerializer(obj.user, context=self.context).data


class KhatmaDetailsSerializer(serializers.ModelSerializer):
    khatma_users = KhatmaUsersDetailsSerializer(many=True, read_only=True, source='khatmausers_set')
    created_by = serializers.SerializerMethodField()

    class Meta:
        model = Khatma
        fields = [
            'id',
            'from_part',
            'to_part',
            'narration',
            'status',
            'active',
            'created_by',
            'created_at',
            'khatma_users',
        ]

    def get_created_by(self, obj):
        return UserListSerializer(obj.created_by, context=self.context).data


class UserProgressKhatamatSerializer(serializers.ModelSerializer):
    total_recitations = serializers.IntegerField()
    total_verses = serializers.IntegerField()
    percentage_finished = serializers.FloatField()
    accepted_count = serializers.IntegerField()
    rejected_count = serializers.IntegerField()
    pending_count = serializers.IntegerField()

    class Meta:
        model = KhatmaUsers
        fields = (
            'khatma_id', 'total_recitations', 'total_verses',
            'percentage_finished', 'accepted_count', 'rejected_count', 'pending_count'
        )

    @classmethod
    def setup_eager_loading(cls, queryset):
        return queryset.select_related('khatma', 'from_verse', 'to_verse')

    @classmethod
    def annotate_progress(cls, queryset):
        queryset = queryset.annotate(
            total_recitations=Count('recitation'),
            total_verses=F('to_verse__verse_number') - F('from_verse__verse_number'),
            percentage_finished=ExpressionWrapper(
                F('total_recitations') * 1.0 / F('total_verses'),
                output_field=FloatField()
            ),
            accepted_count=Count('recitation__id', filter=Q(recitation__result=config.RECITATIONS_RESULT_ACCEPTED)),
            rejected_count=Count('recitation__id', filter=Q(recitation__result=config.RECITATIONS_RESULT_REJECTED)),
            pending_count=Count('recitation__id', filter=Q(recitation__result=config.RECITATIONS_RESULT_PENDING))
        )
        return queryset


class UserProgresskhatmaSerializer(serializers.ModelSerializer):
    total_recitations = serializers.IntegerField()
    total_verses = serializers.IntegerField()
    percentage_finished = serializers.FloatField()
    accepted_count = serializers.IntegerField()
    rejected_count = serializers.IntegerField()
    pending_count = serializers.IntegerField()

    class Meta:
        model = KhatmaUsers
        fields = (
            'user_id', 'khatma_id', 'total_recitations', 'total_verses',
            'percentage_finished', 'accepted_count', 'rejected_count', 'pending_count'
        )

    @classmethod
    def setup_eager_loading(cls, queryset):
        return queryset.select_related('khatma', 'from_verse', 'to_verse')

    @classmethod
    def annotate_progress(cls, queryset):
        queryset = queryset.annotate(
            total_recitations=Count('recitation'),
            total_verses=F('to_verse__verse_number') - F('from_verse__verse_number'),
            percentage_finished=ExpressionWrapper(
                F('total_recitations') * 1.0 / F('total_verses'),
                output_field=FloatField()
            ),
            accepted_count=Count('recitation__id', filter=Q(recitation__result=config.RECITATIONS_RESULT_ACCEPTED)),
            rejected_count=Count('recitation__id', filter=Q(recitation__result=config.RECITATIONS_RESULT_REJECTED)),
            pending_count=Count('recitation__id', filter=Q(recitation__result=config.RECITATIONS_RESULT_PENDING))
        )
        return queryset
