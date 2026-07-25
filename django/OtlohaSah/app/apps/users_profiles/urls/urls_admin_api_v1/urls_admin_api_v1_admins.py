from django.urls import path

from apps.users_profiles.views.views_admin_api_v1.views_admin_api_v1_admins import AdminsListAPIView, AdminCreateAPIView, \
    AdminUpdateِAPIView, AdminSuspendActionAPIView

app_name = 'admins'
urlpatterns = [
    path('', AdminsListAPIView.as_view(), name="listing"),
    path('create/', AdminCreateAPIView.as_view(), name='admin-create'),
    path('edit/<int:pk>/', AdminUpdateِAPIView.as_view(), name='update'),
    path('toggle/<str:action>/<int:pk>/', AdminSuspendActionAPIView.as_view(), name="toggle-suspend"),

]
