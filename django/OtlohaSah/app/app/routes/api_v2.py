from django.urls import path, include
from drf_yasg import openapi
from drf_yasg.views import get_schema_view

app_name = 'api-v2'

urlpatterns = [
    path('', include("apps.authn.urls.urls_api_v2", namespace="authentication")),

    path('recitations/', include('apps.recitations.api.v2.urls', namespace='recitations')),
    path('users-profiles/', include('apps.users_profiles.urls.urls_v2_users_profiles', namespace='users_profiles')),
    path('my-profile/', include('apps.users_profiles.urls.urls_v2_my_profile', namespace='my_profile')),
]

schema_view_v2 = get_schema_view(
    openapi.Info(
        title="OtlohaSah API V2",
        default_version='api-v2',
        description="API v2 docs",
        terms_of_service="https://www.ourapp.com/policies/terms/",
        contact=openapi.Contact(email="contact@quran.local"),
        license=openapi.License(name="Test License"),
    ),
    patterns=[path('api/v2/', include('app.routes.api_v2', namespace='api-v2'))],
    public=True,
)

urlpatterns += [
    path('swagger/', schema_view_v2.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui-v2'),
    path('swagger.json/', schema_view_v2.without_ui(cache_timeout=0), name='schema-swagger-ui-v2'),
    path('redoc/', schema_view_v2.with_ui('redoc', cache_timeout=0), name='schema-redoc-v2'),
]
