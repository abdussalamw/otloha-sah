from django.contrib.auth import get_user_model
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.authn.social.providers import get_provider

UserModel = get_user_model()


class SocialLoginView(APIView):
    permission_classes = [AllowAny]

    @swagger_auto_schema(
        operation_description="Log in a user via a social provider",
        request_body=openapi.Schema(
            type=openapi.TYPE_OBJECT,
            required=['provider'],
            properties={
                'provider': openapi.Schema(type=openapi.TYPE_STRING, description='Name of the social provider'),
                'access_token': openapi.Schema(type=openapi.TYPE_STRING, description='Access token from the provider'),
            },
        ),
        responses={
            200: openapi.Response(
                description="Successful login",
                examples={
                    'application/json': {
                        'access': 'JWT access token',
                        'refresh': 'JWT refresh token',
                    }
                }
            ),
            400: openapi.Response(
                description="Bad Request",
                examples={
                    'application/json': {
                        'error': 'Provider not specified or invalid'
                    }
                }
            ),
            500: openapi.Response(
                description="Internal Server Error",
                examples={
                    'application/json': {
                        'error': 'Detailed error message'
                    }
                }
            ),
        },
    )
    def post(self, request, *args, **kwargs):
        provider_name = request.data.get('provider')
        if not provider_name:
            return Response({'error': 'Provider not specified.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            provider = get_provider(provider_name)()
        except ValueError as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

        # try:
        user, tokens = provider.do_auth(request.data)
        return Response(tokens, status=status.HTTP_200_OK)
        # except Exception as e:
        #     return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
