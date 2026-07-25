from django.urls import path

from apps.authn.views.views_verification import VerifyEmailView

app_name = 'email-verification'

urlpatterns = [
    path('verfiy/', VerifyEmailView.as_view(), name="send"),
]
