from django.urls import path

from apps.recitations.views.views_admin_api_v1.recitations import AdminRecitationReportsAPIView, RecitationsListAPIView, \
    RecitationDeleteAPIView, RecitationDetailAPIView

app_name = 'recitations'
urlpatterns = [
    path('', RecitationsListAPIView.as_view(), name='recitations'),
    # path('report/<int:report_id>/<str:action>/', RecitationReportAction.as_view(), name='actions'),
    path('reported/', AdminRecitationReportsAPIView.as_view(), name='reports'),
    path('<int:pk>/', RecitationDetailAPIView.as_view(), name='details'),
    path('<int:pk>/delete/', RecitationDeleteAPIView.as_view(), name='delete'),
]
