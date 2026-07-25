from django.urls import path, include
from rest_framework.urlpatterns import format_suffix_patterns

from apps.users.views.api.user_views import UserDetails

app_name = 'users-api'

urlpatterns = [
    path('<int:pk>/', UserDetails.as_view(), name='profile'),
    path('auth/', include('apps.users.auth.urls_api_v1', namespace='auth')),

]
urlpatterns = format_suffix_patterns(urlpatterns)
