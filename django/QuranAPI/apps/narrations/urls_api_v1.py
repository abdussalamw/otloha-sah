from django.urls import path, include

from apps.narrations.views_api_v1 import *

app_name = 'narrations'

urlpatterns = [
    path('', NarrationsListView.as_view(), name="listing"),
    path('<int:narration_pk>/', NarrationsDetailView.as_view(), name="details"),
    path('<int:narration_pk>/download/', DownloadNarrationView.as_view(), name="download"),
    path('<int:narration_id>/verses/', include('apps.narrations.verses.urls_api_v1', namespace="verses")),
    path('<int:narration_id>/words/', include('apps.narrations.words.urls_api_v1', namespace="words")),
]
