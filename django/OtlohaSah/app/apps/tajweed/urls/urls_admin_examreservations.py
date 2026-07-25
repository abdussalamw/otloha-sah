from django.urls import path

from apps.tajweed.views.views_admin_v1 import ExamReservationListingView, DeleteExamReservationView, \
    ApproveExamReservationView, RejectExamReservationView

app_name = 'exam-reservations'

urlpatterns = [
    path('', ExamReservationListingView.as_view(), name="listing"),
    path('<int:pk>/approve/', ApproveExamReservationView.as_view(), name='approve'),
    path('<int:pk>/reject/', RejectExamReservationView.as_view(), name='reject'),
    path('<int:pk>/delete/', DeleteExamReservationView.as_view(), name='delete'),
]
