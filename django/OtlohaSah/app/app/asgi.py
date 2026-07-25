"""
ASGI config for Etloha project.

It exposes the ASGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/3.2/howto/deployment/asgi/
"""

import os

from channels.routing import ProtocolTypeRouter, URLRouter
from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.settings')

django_asgi_app = get_asgi_application()

from app.middlewares.TokenAuthMiddleware import token_or_session_auth_middleware
from app.routes import channels

application = ProtocolTypeRouter({
    "http": django_asgi_app,
    "websocket": token_or_session_auth_middleware(
        URLRouter(
            channels.websocket_urlpatterns
        )
    )
})
