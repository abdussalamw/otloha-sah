from django.urls import path, include
from drf_yasg import openapi
from drf_yasg.views import get_schema_view

app_name = 'api-v1'

urlpatterns = [
    path('', include('apps.main.urls.urls_api_v1'), name='main'),
    path('', include('apps.notifications.urls_api'), name='notifications'),
    path('', include('apps.recitation.urls_api_v1', namespace='recitations')),
    path('', include('apps.users.progress.urls_api_v1', namespace='progress')),
    path('', include('apps.settings.urls.urls_api_v1.urls_api', namespace='settings')),
    path('', include('apps.ads.urls.urls_api_v1', namespace='ads')),
    path('tajweed/', include('apps.tajweed.urls.urls', namespace='tajweed')),
    path('khatma/', include('apps.khatma.urls.urls_api_v1.urls', namespace='khatma')),
    path('invitations/', include('apps.invitations.urls', namespace='invitations')),
    path('entities/', include('apps.entities.urls', namespace='entities')),
    path('users/', include('apps.users.urls.urls_api_v1', namespace='users')),
    path('users/', include('apps.users.urls.urls_admin_api_v1', namespace='all-users')),

    path('chat/', include('apps.chat.urls_api_v1', namespace='chat')),
    path('records/', include('apps.records.urls_api_v1', namespace='records')),
    path('profile/', include('apps.users.profile.urls_api_v1', namespace='profile')),
]

schema_view = get_schema_view(
    openapi.Info(
        title="OtlohaSah API V1",
        default_version='api-v1',
        description="API v1 docs",
        terms_of_service="https://www.ourapp.com/policies/terms/",
        contact=openapi.Contact(email="contact@quran.local"),
        license=openapi.License(name="Test License"),
    ),
    patterns=[path('api/v1/', include('app.routes.api_v1', namespace='api-v1'))],
    public=True,
)

urlpatterns += [
    path('swagger/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui-v1'),
    path('api/api.json/', schema_view.without_ui(cache_timeout=0), name='schema-swagger-ui-v1'),
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc-v1'),
]
