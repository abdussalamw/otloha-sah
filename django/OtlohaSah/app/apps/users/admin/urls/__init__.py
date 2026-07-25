from django.urls import path

from apps.users.admin.views.views_admin_api_v1 import UsersListingAdminListAPIView

app_name = 'users'

urlpatterns = [
    path('', UsersListingAdminListAPIView.as_view(), name='listing'),

]
