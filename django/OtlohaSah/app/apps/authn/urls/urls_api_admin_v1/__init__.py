from django.urls import path, include

from apps.authn.views.views_social import SocialLoginView

app_name = "authentication"

urlpatterns = [
    path('token/', include('apps.authn.urls.urls_api_admin_v1.urls_api_admin_v1_token', namespace='token')),

    path('email-verification/',
         include("apps.authn.urls.urls_api_admin_v1.urls_api_admin_v1_email_verification",
                 namespace='email-verification')),

    path('password-reset/',
         include("apps.authn.urls.urls_api_admin_v1.urls_api_admin_v1_password_reset", namespace='password-reset')),
]
