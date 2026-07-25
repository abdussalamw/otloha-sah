from django.urls import path

from apps.reports.views.views_admin_api_v1 import AdminTeacherAccountingReportsListAPIView

app_name = 'reports'

urlpatterns = [
    path('teachers-accountings/', AdminTeacherAccountingReportsListAPIView.as_view(), name="teacher-accounting"),
]
