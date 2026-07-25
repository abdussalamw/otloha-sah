from django.urls import path, include
from drf_yasg import openapi
from drf_yasg.views import get_schema_view

app_name = 'admin-v1'

urlpatterns = [
    # path('', include("apps.authn.urls.urls_api_admin_v1", namespace="authentication")),
    #
    # path('tajweed/', include('apps.tajweed.urls.urls_admin_api', namespace='tajweed')),
    #
    # path('reports/', include('apps.reports.urls.urls_admin_api_v1', namespace='reports')),
    #
    # path('users/', include('apps.users_profiles.urls.urls_admin_api_v1', namespace='users')),
    # path('recitations/', include('apps.recitations.urls.urls_admin_api_v1.urls', namespace='recitations')),
    # path('khatma/', include('apps.khatma.urls.urls_admin_api_v1.urls', namespace='khatma')),
    # path('settings/', include('apps.settings.urls.urls_admin_api_v1.urls', namespace='settings')),
    # path('ads/', include('apps.ads.urls.urls_admin_api_v1', namespace='ads')),
    #
    #
    # path('authz/', include('apps.authz.urls.urls_admin_api_v1', namespace='authz')),

    path('<str:user_type>/', include('apps.users.admin.urls', namespace='users')),
]

schema_view = get_schema_view(
    openapi.Info(
        title="OtlohaSah Admin API V1",
        default_version='admin-api-v1',
        description="Admin API v1 docs",
        terms_of_service="https://www.ourapp.com/policies/terms/",
        contact=openapi.Contact(email="contact@quran.local"),
        license=openapi.License(name="Test License"),
    ),
    patterns=[path('api/admin/v1/', include('app.routes.api_admin_v1', namespace='api-admin-v1'))],
    public=True,
)

urlpatterns += [
    path('swagger/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui-admin-v1'),
    path('api/api.json/', schema_view.without_ui(cache_timeout=0), name='schema-swagger-ui-admin-v1'),
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc-admin-v1'),
]
