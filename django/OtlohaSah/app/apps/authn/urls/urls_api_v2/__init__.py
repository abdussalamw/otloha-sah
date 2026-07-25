from django.urls import path, include

from apps.authn.views.views_api_v2_registration import RegisterAPIView
from apps.authn.views.views_social import SocialLoginView

app_name = 'authentication'

urlpatterns = [
    path('register/', RegisterAPIView.as_view(), name='register'),
    path('email-verification/',
         include('apps.authn.urls.urls_api_v2.urls_api_v2_email', namespace='email-verification')),
    path('token/', include('apps.authn.urls.urls_api_v2.urls_api_v2_token', namespace='token')),
    path('password-reset/', include('django_rest_passwordreset.urls', namespace='password-reset')),
    path('social-login/', SocialLoginView.as_view(), name='social-login'),

]
