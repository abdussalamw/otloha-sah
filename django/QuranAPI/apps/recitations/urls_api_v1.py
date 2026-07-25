from django.urls import path, include

from apps.recitations.views_api_v1 import RecitationListAPIView, RecitationDetailsView

app_name = 'recitation'

urlpatterns = [
    path('verses/', include('apps.recitations.recitation_verse.urls_api', namespace='recitation-verses')),
    path('', RecitationListAPIView.as_view(), name='list-recitations'),
    path('<int:recitation_id>/', RecitationDetailsView.as_view(), name='details')

]
