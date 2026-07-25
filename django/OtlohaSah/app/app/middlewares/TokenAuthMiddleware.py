from asgiref.sync import sync_to_async
from channels.auth import AuthMiddlewareStack
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.tokens import RefreshToken

User = get_user_model()


class TokenAuthMiddleware:
    def __init__(self, app):
        self.app = app

    async def __call__(self, scope, receive, send):
        query = scope["query_string"]
        if query:
            query = dict(item.split('=') for item in query.decode().split('&') if item)

            token = query['token'] if 'token' in query else None

            if token:
                try:
                    access_token = await sync_to_async(RefreshToken)(token)
                    user_id = access_token.payload.get('user_id')
                    scope['user'] = await sync_to_async(User.objects.get)(id=user_id)
                except Exception as e:
                    from django.contrib.auth.models import AnonymousUser
                    scope['user'] = AnonymousUser()

        return await self.app(scope, receive, send)


def token_or_session_auth_middleware(inner):
    return TokenAuthMiddleware(AuthMiddlewareStack(inner))
