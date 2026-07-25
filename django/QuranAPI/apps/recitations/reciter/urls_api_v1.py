from django.urls import path

from apps.recitations.reciter.views_api_v1 import RecitersListAPIView, RecitersDetailsAPIView

app_name = 'reciters'

urlpatterns = [
    path('', RecitersListAPIView.as_view(), name='listing'),
    path('<int:reciter_id>/', RecitersDetailsAPIView.as_view(), name='details'),
]
