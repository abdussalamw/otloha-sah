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
        user = self.context['request'].user
        level = obj
        total_lessons = TajweedLesson.objects.filter(lesson_level=level).count()
        stats = TajweedLesson.objects.filter(tajweeduserprogress__level=level,
                                             tajweeduserprogress__user=user).aggregate(
            total_lessons=Count('id'),
            total_lessons_read=Count('id', filter=Q(tajweeduserprogress__read__gt=0)),
            total_lessons_completed=Count('id', filter=Q(tajweeduserprogress__completed=100)),
            total_user_rate=Avg('tajweeduserprogress__rate'),
        )
        stats['total_lessons'] = total_lessons
        return stats


class LevelSerializer(serializers.ModelSerializer):
    completed = serializers.SerializerMethodField()

    class Meta:
        model = TajweedLevel
        fields = ['id', 'name', 'color', 'value', 'completed']

    def get_completed(self, obj):
        if self.context.get('request', None):
            avg_completion = \
                TajweedUserProgress.objects.filter(user=self.context['request'].user, level_id=obj).aggregate(
                    Avg('completed'))[
                    'completed__avg']
            return (avg_completion) * 100 if avg_completion is not None else 0
        return 0
