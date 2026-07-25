from django.conf import settings
from django.conf.urls.static import static
from django.urls import path, include
from django.views.i18n import JavaScriptCatalog

from apps.notifications.views import ServiceWorkerView
from quran_api_client.views import get_narrations

urlpatterns = [
    path('test', get_narrations, name='test'),
    path("", include("apps.authn.urls.urls_admin", namespace="authentication")),

    path('', include('apps.authn.urls.urls_verification')),
    path('api/v1/', include('app.routes.api_v1', namespace='api-v1')),
    path('api/v2/', include('app.routes.api_v2', namespace='api-v2')),
    path('api/admin/v1/', include('app.routes.api_admin_v1', namespace='admin-api-v1')),

    path('admin/', include('app.routes.admin', namespace='admin')),
    path('notifications/', include('apps.notifications.urls', namespace="notifications")),
    path('firebase-messaging-sw.js', ServiceWorkerView.as_view(), name="firebase-sw"),
    path('i18n/', include('django.conf.urls.i18n')),
    path('jsi18n/', JavaScriptCatalog.as_view(), name='javascript-catalog'),
    path('', include('app.routes.site', namespace='site')),

]

if settings.DEBUG:
    import debug_toolbar

    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    urlpatterns += [
        path('__debug__/', include(debug_toolbar.urls)),
    ]
