from django.urls import path

from apps.tajweed.books.characters.views_api_v1 import CharactersListingAPIView, CharactersDetailsAPIView

app_name = 'characters'

urlpatterns = [
    path('', CharactersListingAPIView.as_view(), name='listing'),
    path('by/verses/<int:verse_id>/', CharactersListingAPIView.as_view(), name='listing-by-verse'),
    path('by/words/<int:word_id>/', CharactersListingAPIView.as_view(), name='listing-by-word'),
    path('by/chapters/<int:chapter_id>/', CharactersListingAPIView.as_view(), name='listing-by-chapter'),
    path('<int:character_id>/', CharactersDetailsAPIView.as_view(), name='details'),
]
