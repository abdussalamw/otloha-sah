from django.urls import path

from apps.records.views_api_v1 import RecordsAPIView, RecordChunkUploadAPIView, RecordStreamFileAPIView, \
    RecordDownloadFileAPIView

app_name = "records"

urlpatterns = [
    path('', RecordsAPIView.as_view(), name='create'),
    path('chunk-upload/', RecordChunkUploadAPIView.as_view(), name='chunk-upload'),
    path('<str:file_uuid>/stream/', RecordStreamFileAPIView.as_view(), name='stream'),
    path('<str:file_uuid>/download/', RecordDownloadFileAPIView.as_view(), name='download'),
]
