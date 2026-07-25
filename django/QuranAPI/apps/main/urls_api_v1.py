from django.urls import path

from apps.main.views_api_v1 import SearchAPIView

app_name = "main"

urlpatterns = [
    path('search/<str:narration_id>/', SearchAPIView.as_view(), name="search")
]
