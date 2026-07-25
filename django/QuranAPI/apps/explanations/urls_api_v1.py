from django.urls import path, include

from apps.explanations.views_api_v1 import ExplanationListingView, ExplanationDetailsView

app_name = 'explanations'

urlpatterns = [
    path('', ExplanationListingView.as_view(), name='listing'),
    path('<int:explanation_id>/', ExplanationDetailsView.as_view(), name='details'),
    path('<int:explanation_id>/verses/', include('apps.explanations.explanation_verse.urls_api_v1', namespace='verses')),
]
