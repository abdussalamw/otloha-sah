from django.urls import path

from apps.tajweed.views.views_api_v1 import ExamSlotsListAPIView, ExamRequestAPIView, ExamReservationCancelAPIView, \
    UserExamReservationListAPIView

app_name = 'exam-reservations'

urlpatterns = [
    path('', UserExamReservationListAPIView.as_view(), name='exam-reservation-list'),
    path('remaining_slots/', ExamSlotsListAPIView.as_view(), name='requests'),
    path('exam-requests/<int:pk>/', ExamRequestAPIView.as_view(), name='exam-requests'),
    path('exam-requests/<int:pk>/cancel/', ExamReservationCancelAPIView.as_view(), name='exam-reservation-cancel'),

]
