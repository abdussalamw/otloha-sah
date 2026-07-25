from django.urls import path, include

from apps.files_handler.views import FileListingView, CreateFileView, ProcessFileView, DownloadFileFromUrlView

app_name = 'files'

urlpatterns = [
    path('<str:app_label>/<str:model>/<int:object_id>/<str:process_name>/',
         FileListingView.as_view(), name="listing"),

    path('<str:app_label>/<str:model>/<int:object_id>/<str:process_name>/create/',
         CreateFileView.as_view(), name="create"),

    path('<str:app_label>/<str:model>/<int:object_id>/<str:process_name>/download-from-url/',
         DownloadFileFromUrlView.as_view(), name="download-from-url"),

    path('<str:app_label>/<str:model>/<int:object_id>/<str:process_name>/process/<int:file_id>/',
         ProcessFileView.as_view(),
         name="process"),

    path('<str:app_label>/<str:model>/<int:object_id>/csv/', include("apps.files_handler.csv_processing.urls",
                                                                     namespace="csv")),
]
