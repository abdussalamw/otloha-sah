from datetime import timedelta

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTAuthentication',
        'rest_framework.authentication.SessionAuthentication',
        'rest_framework.authentication.BasicAuthentication',
    ],
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticatedOrReadOnly',
    ),
    'DEFAULT_PAGINATION_CLASS': 'app.rest_handlers.PageNumberPagination',
    'PAGE_SIZE': 20,
    'EXCEPTION_HANDLER': 'app.rest_handlers.custom_exception_handler',
    'DEFAULT_FILTER_BACKENDS': [
        'django_filters.rest_framework.DjangoFilterBackend',
        'rest_framework.filters.SearchFilter',
        'rest_framework.filters.OrderingFilter',
    ]

}

REST_SESSION_LOGIN = True
REST_USE_JWT = True
JWT_AUTH_COOKIE = 'jwt_access_token'
JWT_AUTH_REFRESH_COOKIE = 'jwt_refresh_token'
OLD_PASSWORD_FIELD_ENABLED = True

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=15),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=15),
    'ROTATE_REFRESH_TOKENS': True,
    "TOKEN_OBTAIN_SERIALIZER": "apps.authn.serializers.GeneralTokenObtainPairSerializer",

}

JWT_AUTH = {
    'JWT_RESPONSE_PAYLOAD_HANDLER':
        'your_project.utils.jwt_response_payload_handler',
}
