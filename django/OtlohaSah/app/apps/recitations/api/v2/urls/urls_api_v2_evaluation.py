from django.urls import path

from ..views import FinishEvaluationAPIView, \
    EditEvaluationAPIView, DeleteEvaluationAPIView, CreateEvaluationAPIView, EvaluationListAPIView

app_name = 'evaluation'

urlpatterns = [
    path('', EvaluationListAPIView.as_view(), name='listing'),
    path('finish-evaluation/', FinishEvaluationAPIView.as_view(), name='finish_evaluation'),
    path('create/', CreateEvaluationAPIView.as_view(), name='create'),
    path('<int:evaluation_id>/update/', EditEvaluationAPIView.as_view(), name='update'),
    path('<int:evaluation_id>/delete/', DeleteEvaluationAPIView.as_view(), name='delete'),

]
