from django.urls import path

from apps.chat.consumers import ChatRoomConsumer

websocket_urlpatterns = [
    # path('ws/main/', MainConsumer.as_asgi(), name='main'),
    path('ws/chat/<str:room_type>/<uuid:room_uuid>/', ChatRoomConsumer.as_asgi(), name='chat-rooms'),
]
