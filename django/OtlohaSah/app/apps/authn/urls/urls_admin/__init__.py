from django.contrib.auth.views import LogoutView
from django.urls import path, include

from apps.authn.views.views_admin import LoginView

app_name = "authentication"

urlpatterns = [
    path('login/', LoginView.as_view(), name="login"),
    path('logout/', LogoutView.as_view(), name='logout'),

    path('email-verification/', include("apps.authn.urls.urls_admin.urls_admin_email", namespace='email-verification')),
    path('password-reset/',
         include("apps.authn.urls.urls_admin.urls_admin_password_reset", namespace='password-reset')),
]
