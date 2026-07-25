from django.urls import path, include
from drf_yasg import openapi
from drf_yasg.views import get_schema_view

app_name = 'api-v1'

schema_view = get_schema_view(
    openapi.Info(
        title="QURAN API",
        default_version='v1',
        description="Test description",
        terms_of_service="https://www.ourapp.com/policies/terms/",
        contact=openapi.Contact(email="contact@quran.local"),
        license=openapi.License(name="Test License"),
    ),
    public=True,
)

urlpatterns = [
    path('', include('apps.main.urls_api_v1', namespace="main")),
    path('books/', include('apps.quran.urls_api_v1', namespace='books')),
    path('chapters/', include('apps.chapters.urls_api_v1', namespace='chapters')),
    path('pages/', include('apps.quran.page.urls_api_v1', namespace='pages')),
    path('narrations/', include('apps.narrations.urls_api_v1', namespace='narrations')),
    path('parts/', include('apps.parts.urls_api_v1', namespace='parts')),
    path('recitations/', include('apps.recitations.urls_api_v1', namespace='recitations')),
    path('reciters/', include('apps.recitations.reciter.urls_api_v1', namespace='reciters')),
    path('users/', include('apps.users.urls.api.user_urls', namespace='users')),
    path('profile/', include('apps.users.profile.urls_api_v1', namespace='profile')),
    path('tajweed/', include('apps.tajweed.urls_api_v1', namespace='tajweed')),
    path('translations/', include('apps.translations.urls_api_v1', namespace='translations')),
    path('explanation/', include('apps.explanations.urls_api_v1', namespace='explanation')),

    # ========== external ============
    path('api-auth/', include('rest_framework.urls')),
    path('o/', include('oauth2_provider.urls', namespace='oauth2_provider')),

    # ========== debug ============
    path('swager/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('api/api.json/', schema_view.without_ui(cache_timeout=0), name='schema-swagger-ui'),
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
]
