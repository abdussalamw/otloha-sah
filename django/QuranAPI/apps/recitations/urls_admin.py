from django.urls import path, include

from apps.recitations.views_admin import RecitationDetailAdminView, RecitationListAdminView, \
    RecitationCreateAndUpdateView

app_name = 'recitations'

urlpatterns = [
    path('', RecitationListAdminView.as_view(), name='listing'),
    path('create/', RecitationCreateAndUpdateView.as_view(), name='create'),
    path('<int:recitation_id>', RecitationDetailAdminView.as_view(), name='details'),
    path('<int:recitation_id>/update/', RecitationCreateAndUpdateView.as_view(), name='update'),
    path('<int:recitation_id>/verses/',
         include('apps.recitations.recitation_verse.urls_admin', namespace='recitation-verses')),
    path('reciter/', include('apps.recitations.reciter.urls_admin', namespace='reciters'))
]
