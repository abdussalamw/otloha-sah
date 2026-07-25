from django.urls import path

from apps.parts.views_api_v1 import PartsListAPIView, PartDetailAPIView

app_name = 'parts'

urlpatterns = [
    path('', PartsListAPIView.as_view(), name='listing'),
    path('<int:part_id>', PartDetailAPIView.as_view(), name='details'),
]
