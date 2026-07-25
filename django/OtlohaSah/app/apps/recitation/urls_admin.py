from django.urls import path

from apps.recitation.views_admin import RecitationsListingView, DetailsView, RecitationDeleteView, \
    RecitationStatisticsView, RecitationStatisticsAjaxView

app_name = "recitations"

urlpatterns = [
    path('', RecitationsListingView.as_view(), name='listing'),
    path('statistics/', RecitationStatisticsView.as_view(), name='statistics'),
    path('statistics/ajax/', RecitationStatisticsAjaxView.as_view(), name='statistics-ajax'),
    path('<int:pk>/', DetailsView.as_view(), name='details'),
    path('<int:pk>/delete', RecitationDeleteView.as_view(), name='delete'),
]
