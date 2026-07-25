from django.urls import path

from apps.chapters.views_api_v1 import ChaptersListAPIView, ChaptersDetailAPIView

app_name = 'chapters'

urlpatterns = [

    path('', ChaptersListAPIView.as_view(), name='listing'),
    path('<int:chapter_id>/', ChaptersDetailAPIView.as_view(), name='details'),

]