from django.urls import path

from apps.narrations.verses.views_admin import VerseListAdminView, VerseDetailsView

app_name = 'verses'

urlpatterns = [
    path('', VerseListAdminView.as_view(), name='listing'),
    path('<int:verse_id>/', VerseDetailsView.as_view(), name='details'),
]
