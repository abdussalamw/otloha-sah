from django.urls import path, include

app_name = 'tajweed'

urlpatterns = [
    path('levels/', include('apps.tajweed.urls.urls_levels_api_v1', namespace='levels')),
    path('lessons/', include('apps.tajweed.urls.urls_lessons_api_v1', namespace='lessons')),
    path('exam-reservations/', include('apps.tajweed.urls.urls_exam_reservations', namespace='exam-reservations')),
]
