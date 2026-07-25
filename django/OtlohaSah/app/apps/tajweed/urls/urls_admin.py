from django.urls import path, include

app_name = 'tajweed'

urlpatterns = [
    path('levels/', include('apps.tajweed.urls.urls_admin_levels', namespace='levels')),
    path('lessons/', include('apps.tajweed.urls.urls_admin_lessons', namespace='lessons')),
    path('calendar-slots/', include('apps.tajweed.urls.urls_admin_calendarslots', namespace='calendar-slots')),
    path('exam-reservations/', include('apps.tajweed.urls.urls_admin_examreservations', namespace='exam-reservations')),
    path('user-level-passed/',
         include('apps.tajweed.urls.urls_admin_user_level_passed', namespace='user-level-passed')),

]
