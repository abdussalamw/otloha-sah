from django.urls import path

from apps.users.profile.site_views import ChangePasswordView, UpdateProfileInfoView, ChangeEmailView, PhoneUpdateView, \
    ProfileIndex

app_name = 'profile'

urlpatterns = [
    path('', ProfileIndex.as_view(), name="index"),
    path('password-change/', ChangePasswordView.as_view(), name='password-change'),
    path('update/<int:user_id>/', UpdateProfileInfoView.as_view(), name='profile-update'),
    path('email-change/', ChangeEmailView.as_view(), name='email-update'),
    path('phone-change/', PhoneUpdateView.as_view(), name='phone-update'),
]
