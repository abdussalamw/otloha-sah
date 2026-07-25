from django.db.models import Avg, Q, Count
from rest_framework import serializers

from apps.tajweed.models import TajweedUserProgress
from apps.tajweed.models.calendar import CalendarSlot
from apps.tajweed.models.lessons import TajweedLesson, TajweedLessonExample, TajweedVideoUrl
from apps.tajweed.models.levels import TajweedLevel, UserLevelPassed
from quran_api_client.models import Verse


class TajweedLevelSerializer(serializers.ModelSerializer):
    class Meta:
        model = TajweedLevel
        fields = ['id', 'name', 'color', 'value']

    def all_levels_user_stats(self):
        request = self.context['request']

        stats = TajweedLesson.objects.filter(tajweeduserprogress__user=request.user.pk).aggregate(
            total_lessons=Count('tajweeduserprogress__id'),
            total_lessons_read=Count('tajweeduserprogress__id', filter=Q(tajweeduserprogress__read__gt=0)),
            total_lessons_completed=Count('tajweeduserprogress__id', filter=Q(tajweeduserprogress__completed=100)),
            total_user_rate=Avg('tajweeduserprogress__rate'),
        )
        return stats

    def level_user_stats(self):
        request = self.context['request']
        level = self.context['kwargs']['pk']
        stats = TajweedLesson.objects.filter(
            tajweeduserprogress__user=request.user.pk,
        ).aggregate(
            total_lessons=Count('id', filter=Q(tajweeduserprogress__level=level)),
            total_lessons_read=Count('tajweeduserprogress__id', filter=Q(tajweeduserprogress__read__gt=0,
                                                                         tajweeduserprogress__level=level)),
            total_lessons_completed=Count('tajweeduserprogress__id', filter=Q(tajweeduserprogress__completed=100,
                                                                              tajweeduserprogress__level=level)),
            total_user_rate=Avg('tajweeduserprogress__rate', filter=Q(tajweeduserprogress__level=level)),
        )

        return stats


# 3
class TajweedLessonSerializer(serializers.ModelSerializer):
    class Meta:
        model = TajweedLesson
        fields = ['id', 'title', 'content', 'lesson_level', 'parent', ]

    def lesson_user_stats(self):
        request = self.context['request']
        lesson_id = self.context['kwargs']['lesson']
        lesson = TajweedLesson.objects.get(id=lesson_id)
        stats = lesson.get_descendants(include_self=True).filter(
            tajweeduserprogress__user=request.user.pk).aggregate(
            total_lessons=Count('tajweeduserprogress__id'),
            total_lessons_read=Count('tajweeduserprogress__id', filter=Q(tajweeduserprogress__read__gt=0)),
            total_lessons_completed=Count('tajweeduserprogress__id', filter=Q(tajweeduserprogress__completed=100)),
            total_user_rate=Avg('tajweeduserprogress__rate')
        )

        return stats


class TajweedVideoUrlSerializer(serializers.ModelSerializer):
    class Meta:
        model = TajweedVideoUrl
        fields = ['url']


class TajweedLessonExampleSerializer(serializers.ModelSerializer):
    class Meta:
        model = TajweedLessonExample
        fields = ['id', 'title', 'narration', 'chapter', 'verse_text', 'record', 'lesson', 'verse_number']
        read_only_fields = ['id', 'lesson']


class LessonProgressSerializer(serializers.ModelSerializer):
    class Meta:
        model = TajweedUserProgress
        fields = ['read']


class CalendarSlotSerializer(serializers.ModelSerializer):
    remaining_slots = serializers.SerializerMethodField()

    def get_remaining_slots(self, obj):
        return obj.available_slots - obj.reserved_slots

    class Meta:
        model = CalendarSlot
        fields = ['id', 'date', 'time_from', 'time_to', 'available_slots', 'reserved_slots', 'remaining_slots']


class UserLevelPassedSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserLevelPassed
        fields = ['user', 'level', 'rate', 'exam_record']


class VerseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Verse
        fields = ['text']

    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['text'] = ''.join(instance.text)
        return representation
