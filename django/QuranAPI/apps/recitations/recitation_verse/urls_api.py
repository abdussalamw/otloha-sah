from django.urls import path

from apps.recitations.recitation_verse.views_api_v1 import RecitationVerseListingView, RecitationVerseDetailsView

app_name = 'recitation-verses'

urlpatterns = [

    path('', RecitationVerseListingView.as_view(), name='listing'),
    path('<int:recitation_verse_id>/', RecitationVerseDetailsView.as_view(), name='details')

]
