from django.urls import path

from apps.files_handler.csv_processing.views import CSVUploadView, CSVListingView, CSVDetailsView, CSVProcessView

app_name = 'csv'

urlpatterns = [
    path('', CSVListingView.as_view(), name="listing"),
    path('upload/', CSVUploadView.as_view(), name='create'),
    path('<int:csv_id>/', CSVDetailsView.as_view(), name='details'),
    path('<int:csv_id>/process/', CSVProcessView.as_view(), name='process'),
]
