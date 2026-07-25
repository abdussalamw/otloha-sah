from django.urls import path, include

from apps.users.auth.views_api_v1 import UserSignupAPIView, UserLoginAPIView

app_name = 'api_auth'

urlpatterns = [
    path('signup/', UserSignupAPIView.as_view(), name='signup'),
    path('login/', UserLoginAPIView.as_view(), name='login'),
    path('api/password_reset/', include('django_rest_passwordreset.urls', namespace='password_reset')),

]
