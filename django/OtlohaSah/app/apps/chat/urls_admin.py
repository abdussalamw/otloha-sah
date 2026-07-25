from django.urls import path

from apps.chat.views import RoomsListView

app_name = "chat"

urlpatterns = [
    path('<str:room_type>/', RoomsListView.as_view(), name='listing'),
    path('<str:room_type>/<int:pk>/', RoomsListView.as_view(), name='details'),
]
