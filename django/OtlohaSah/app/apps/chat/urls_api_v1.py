from django.urls import path

from apps.chat.views_api_v1 import RoomAPIView, RoomDetailsAPIView

app_name = "chat"

urlpatterns = [
    path('<str:room_type>/', RoomAPIView.as_view(), name='listing'),
    path('<str:room_type>/', RoomAPIView.as_view(), name='create'),
    path('<str:room_type>/<int:pk>/', RoomDetailsAPIView.as_view(), name='details'),
    path('<str:room_type>/<int:pk>/', RoomAPIView.as_view(), name='delete'),
]
