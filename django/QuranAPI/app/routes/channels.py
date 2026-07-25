from django.urls import re_path

from apps.files_handler.consumers import ProcessProgressConsumer

websocket_urlpatterns = [
    re_path(r'ws/process_progress/', ProcessProgressConsumer.as_asgi()),
]
