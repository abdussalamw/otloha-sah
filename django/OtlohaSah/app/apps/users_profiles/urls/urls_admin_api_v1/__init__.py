from django.urls import path, include

from apps.users_profiles.views.views_admin_api_v1 import UserStatisticsAPIView

app_name = 'users'
urlpatterns = [
    path('students/',
         include('apps.users_profiles.urls.urls_admin_api_v1.urls_admin_api_v1_students', namespace='students')),

    path('teachers/',
         include('apps.users_profiles.urls.urls_admin_api_v1.urls_admin_api_v1_teachers', namespace='teachers')),

    path('admins/', include('apps.users_profiles.urls.urls_admin_api_v1.urls_admin_api_v1_admins', namespace='admins')),

    path('<str:user_type>/statistics/', UserStatisticsAPIView.as_view(), name="statistics"),

    path('<str:user_type>/<int:pk>/',
         include('apps.users_profiles.urls.urls_admin_api_v1.urls_admin_api_v1_main', namespace='actions')),
]
    