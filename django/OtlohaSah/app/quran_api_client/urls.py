from django.urls import path
from quran_api_client.views import VerseChapterNarrationView

app_name = 'quran-api'

urlpatterns = [
    path('narration/<int:narration>/chapter/<int:chapter>/verses/', VerseChapterNarrationView.as_view(), name="lessons"),
]