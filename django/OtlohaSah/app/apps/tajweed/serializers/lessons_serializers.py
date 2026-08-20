from rest_framework import serializers

from apps.tajweed.models import TajweedLesson, TajweedVideoUrl, TajweedLessonExample, TajweedUserProgress


class VideoUrlSerializer(serializers.ModelSerializer):
    class Meta:
        model = TajweedVideoUrl
        fields = ['url']


class LessonExampleSerializer(serializers.ModelSerializer):
    class Meta:
        model = TajweedLessonExample
        fields = ['title', 'record', 'verse_number', 'verse_text', 'chapter']


class LessonDetailSerializer(serializers.ModelSerializer):
    video_urls = serializers.SerializerMethodField()
    lesson_examples = serializers.SerializerMethodField()
    number_of_children = serializers.SerializerMethodField()
    completed_lessons = serializers.SerializerMethodField()

    def get_video_urls(self, obj):
        video_urls = TajweedVideoUrl.objects.filter(lesson=obj)
        return VideoUrlSerializer(video_urls, many=True).data

    def get_lesson_examples(self, obj):
        lesson_examples = TajweedLessonExample.objects.filter(lesson=obj)
        return LessonExampleSerializer(lesson_examples, many=True).data

    def get_number_of_children(self, obj):
        lesson = TajweedLesson.objects.get(id=obj.pk)
        number_of_children = lesson.get_descendants(include_self=False).count()
        return number_of_children

    def get_completed_lessons(self, obj):
        request = self.context.get('request')
        if request is None or not request.user.is_authenticated:
            return 0
        return TajweedUserProgress.objects.filter(
            user=request.user,
            parent=obj.pk,
            completed=100,
        ).count()

    class Meta:
        model = TajweedLesson
        fields = ['id', 'title', 'lesson_level', 'content', 'number_of_children', 'completed_lessons', 'video_urls',
                  'lesson_examples', ]


class LessonSerializer(serializers.ModelSerializer):
    number_of_children = serializers.SerializerMethodField()
    completed_lessons = serializers.SerializerMethodField()
    total_lessons_read = serializers.SerializerMethodField()

    class Meta:
        model = TajweedLesson
        fields = ['id', 'title', 'lesson_level', 'number_of_children', 'completed_lessons',
                  'total_lessons_read']

    def get_number_of_children(self, obj):
        number_of_children = TajweedLesson.objects.filter(parent=obj).count()
        return number_of_children

    def get_completed_lessons(self, obj):
        request = self.context.get('request')
        if request is None or not request.user.is_authenticated:
            return 0
        return TajweedUserProgress.objects.filter(
            user=request.user,
            parent=obj.pk,
            completed=100,
        ).count()

    def get_total_lessons_read(self, obj):
        request = self.context.get('request')
        if request is None or not request.user.is_authenticated:
            return 0
        return TajweedUserProgress.objects.filter(
            user=request.user,
            lesson_id=obj.pk,
            read__gt=0,
        ).count()
