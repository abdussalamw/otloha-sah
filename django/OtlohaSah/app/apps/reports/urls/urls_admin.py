from django.urls import path

from apps.reports.views.views_admin import TeacherAccountingReportView, MarkPricingAsCompleteView, \
    TeacherAccountingExportView

app_name = 'reports'

urlpatterns = [
    path('teachers-accountings/', TeacherAccountingReportView.as_view(), name="teacher-accounting"),
    path('teachers-accountings/export/', TeacherAccountingExportView.as_view(), name="export-csv"),
    path('teacher-accounting/bulk-complete-payment/', MarkPricingAsCompleteView.as_view(), name='bulk-complete-payment'),
]
