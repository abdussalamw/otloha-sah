from django.urls import path

from apps.users.profile.views_api_v1 import UpdateProfileDataAPIView, UpdateEmailAPIView, UpdatePhoneAPIView, \
    UpdatePasswordAPIview

app_name = 'api_profile'


urlpatterns = [
    path('update/profile/', UpdateProfileDataAPIView.as_view(), name='profile-info'),
    path('update/email/', UpdateEmailAPIView.as_view(), name='update-email'),
    path('update/phone/', UpdatePhoneAPIView.as_view(), name='update-phone'),
    path('change_password/', UpdatePasswordAPIview.as_view(), name='update-password'),
]
