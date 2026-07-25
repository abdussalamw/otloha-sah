from django.urls import path

from apps.recitations.reciter.views_admin import ReciterListAdminView, ReciterDetailsView, ReciterCreateOrUpdateView

app_name = 'reciters'

urlpatterns = [
    path('', ReciterListAdminView.as_view(), name='listing'),
    path('create/', ReciterCreateOrUpdateView.as_view(), name='create'),
    path('<int:reciter_id>/', ReciterDetailsView.as_view(), name='details'),
    path('<int:reciter_id>/update/', ReciterCreateOrUpdateView.as_view(), name='update'),
]
