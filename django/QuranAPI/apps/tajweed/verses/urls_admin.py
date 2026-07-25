from django.urls import path

from apps.tajweed.verses.views_admin import VersesListingView, VerseDetailsView, VerseUpdateView

app_name = 'verses'

urlpatterns = [
    path('', VersesListingView.as_view(), name='listing'),
    path('<int:verse_id>/details/', VerseDetailsView.as_view(), name="details"),
    path('<int:verse_id>/update/', VerseUpdateView.as_view(), name='update')
]
