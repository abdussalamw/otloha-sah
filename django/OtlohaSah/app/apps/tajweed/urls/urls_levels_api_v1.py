from django.urls import path
from apps.tajweed.views.views_api_v1.views_levels_v1 import LevelListView, LevelRetrieveView, LevelStatsListView, \
    LevelLessonsListView

app_name = 'levels'

urlpatterns = [
    path('', LevelListView.as_view(), name="list"),
    path('<int:pk>/lessons/', LevelLessonsListView.as_view(), name="level-lesson-stats"),
    path('stats/', LevelStatsListView.as_view(), name="stats"),
    path('<int:pk>/stats/', LevelRetrieveView.as_view(), name='level-detail'),
]
