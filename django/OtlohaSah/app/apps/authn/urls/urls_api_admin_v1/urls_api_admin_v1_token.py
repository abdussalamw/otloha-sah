from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView, TokenBlacklistView, TokenVerifyView

app_name = 'token'

urlpatterns = [
    path('', TokenObtainPairView.as_view(), name='obtain_pair'),
    path('refresh/', TokenRefreshView.as_view(), name='refresh'),
    path('blacklist/', TokenBlacklistView.as_view(), name='blacklist'),
    path('verify/', TokenVerifyView.as_view(), name='token_verify'),

]
