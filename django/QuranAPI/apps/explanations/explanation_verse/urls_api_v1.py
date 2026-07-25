from django.urls import path

from apps.explanations.explanation_verse.views_api_v1 import ExplanationVerseListingView, ExplanationVerseDetailsView

app_name = 'verses'

urlpatterns = [
    path('', ExplanationVerseListingView.as_view(), name='listing'),
    path('<int:explanation_verse_id>/', ExplanationVerseDetailsView.as_view(), name='details')
]
