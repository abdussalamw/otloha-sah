from django.contrib import admin

from apps.tajweed.models.lessons import TajweedLesson, TajweedLessonExample, TajweedVideoUrl
from apps.tajweed.models.levels import TajweedLevel
from apps.tajweed.models import TajweedUserProgress

admin.site.register(TajweedLevel)
admin.site.register(TajweedLesson)
admin.site.register(TajweedLessonExample)
admin.site.register(TajweedVideoUrl)
admin.site.register(TajweedUserProgress)
