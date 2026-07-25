from django.urls import path

from apps.users.views.site.user_dashboard import UserDashboardView

app_name = 'user-dashboard'

urlpatterns = [
    path('', UserDashboardView.as_view(), name='dashboard'),
]
