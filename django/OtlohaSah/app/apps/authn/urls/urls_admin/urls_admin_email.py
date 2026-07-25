from django.urls import path

from apps.authn.views.view_admin_email import SendEmailVerificationView, VerifyEmailView

app_name = 'email-verification'

urlpatterns = [
    path('send/', SendEmailVerificationView.as_view(), name="send"),
    path('verify/<str:uidb64>/<str:token>/', VerifyEmailView.as_view(), name="verify"),
]
