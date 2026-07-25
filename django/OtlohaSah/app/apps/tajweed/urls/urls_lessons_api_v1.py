from django.urls import path

from apps.tajweed.views.views_api_v1 import LessonsListView, LessonRetrieveView, LessonsUserStatsView, \
    LessonProgressCreateOrUpdateView

app_name = 'lessons'

urlpatterns = [

    path('', LessonsListView.as_view(), name="list"),
    path('<int:lesson_id>/sub-lessons/', LessonsListView.as_view(), name="sub-lessons"),
    path('<int:lesson_id>/progress/', LessonProgressCreateOrUpdateView.as_view(), name='update-lesson-progress'),
    path('<int:lesson_id>/', LessonRetrieveView.as_view(), name="lesson"),
    path('<int:lesson_id>/stats/', LessonsUserStatsView.as_view(), name="lesson-stats"),
]
