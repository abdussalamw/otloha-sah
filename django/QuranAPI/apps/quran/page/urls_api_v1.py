from django.urls import path

from apps.quran.page.views_api_v1 import PagesListOrDownloadAPIView, PagesDetailAPIView

app_name = 'page'

urlpatterns = [
    path('', PagesListOrDownloadAPIView.as_view(), name='list'),
    path('<int:page_id>/', PagesDetailAPIView.as_view(), name='details'),
]
