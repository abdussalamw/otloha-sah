from django.urls import path

from apps.narrations.verses.views_api_v1 import VersesListAPIView

app_name = 'verses'

urlpatterns = [
    path('', VersesListAPIView.as_view(), name="listing"),
]
