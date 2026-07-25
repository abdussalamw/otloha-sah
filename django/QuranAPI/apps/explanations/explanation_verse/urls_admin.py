from django.urls import path

from apps.explanations.explanation_verse.views_admin import ExplanationVerseListingView

app_name = 'verses'

urlpatterns = [
    path('<int:explanation_id>/', ExplanationVerseListingView.as_view(), name='listing'),
]
