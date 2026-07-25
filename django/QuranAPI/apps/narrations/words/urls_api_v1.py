from django.urls import path

from apps.narrations.words.views_api_v1 import WordsListingAPIView

app_name = 'verses'

urlpatterns = [
    path('', WordsListingAPIView.as_view(), name="listing"),
]
