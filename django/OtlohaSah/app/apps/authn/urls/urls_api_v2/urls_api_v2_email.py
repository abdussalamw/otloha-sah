from django.urls import path

from apps.authn.views.views_api_v2_registration import SendVerificationEmailAPIView, VerifyEmailAPIView

app_name = 'email-verification'

urlpatterns = [
    path('send/', SendVerificationEmailAPIView.as_view(), name="send"),
    path('verify/<str:uidb64>/<str:token>/', VerifyEmailAPIView.as_view(), name="verify"),
]
