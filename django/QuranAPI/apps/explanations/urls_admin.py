from django.urls import path, include

from apps.explanations.views_admin import ExplanationListingView, ExplanationCreateAndUpdateView, \
    ExplanationDetailsView

app_name = 'explanations'

urlpatterns = [
    path('', ExplanationListingView.as_view(), name='listing'),
    path('<int:explanation_id>/', ExplanationDetailsView.as_view(), name='details'),
    path('create/', ExplanationCreateAndUpdateView.as_view(), name='create'),
    path('<int:explanation_id>/update/', ExplanationCreateAndUpdateView.as_view(), name='update'),
    path('verses/', include('apps.explanations.explanation_verse.urls_admin', namespace='verses'))
]
