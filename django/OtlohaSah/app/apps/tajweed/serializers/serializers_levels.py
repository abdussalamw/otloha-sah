from django.db.models import Count, Avg, Q
from rest_framework import serializers

from apps.tajweed.models import TajweedLevel, TajweedLesson, TajweedUserProgress


class LevelStatsSerializer(serializers.ModelSerializer):
    stats = serializers.SerializerMethodField()

    class Meta:
        model = TajweedLevel
        fields = ['stats']

    def get_stats(self, obj):
        return self.context['stats']


class LevelDetailSerializer(serializers.ModelSerializer):
    stats = serializers.SerializerMethodField()

    class Meta:
        model = TajweedLevel
        fields = ['id', 'stats']

    def get_stats(self, obj):
        request = self.context.get('request')
        total_lessons = TajweedLesson.objects.filter(lesson_level=obj).count()
        stats = {
            'total_lessons': total_lessons,
            'total_lessons_read': 0,
            'total_lessons_completed': 0,
            'total_user_rate': None,
        }
        if request is None or not request.user.is_authenticated:
            return stats

        user_stats = TajweedLesson.objects.filter(
            tajweeduserprogress__level=obj,
            tajweeduserprogress__user=request.user,
        ).aggregate(
            total_lessons_read=Count(
                'id',
                filter=Q(tajweeduserprogress__read__gt=0),
            ),
            total_lessons_completed=Count(
                'id',
                filter=Q(tajweeduserprogress__completed=100),
            ),
            total_user_rate=Avg('tajweeduserprogress__rate'),
        )
        stats.update(user_stats)
        return stats


class LevelSerializer(serializers.ModelSerializer):
    completed = serializers.SerializerMethodField()

    class Meta:
        model = TajweedLevel
        fields = ['id', 'name', 'color', 'value', 'completed']

    def get_completed(self, obj):
        request = self.context.get('request')
        if request is None or not request.user.is_authenticated:
            return 0

        avg_completion = TajweedUserProgress.objects.filter(
            user=request.user,
            level_id=obj.id,
        ).aggregate(Avg('completed'))['completed__avg']
        return avg_completion * 100 if avg_completion is not None else 0
