from django.conf import settings
from django.conf.urls.static import static
from django.urls import path, include
from django.views.i18n import JavaScriptCatalog
urlpatterns = [
    path('', include('app.routes.site', namespace='site')),
    path('', include('apps.users.auth.urls_site', namespace='auth')),
    path('admin/', include('app.routes.admin', namespace='admin')),
    path('api/v1/', include('app.routes.api_v1', namespace='api-v1')),
    path('', include('translation.urls', namespace='translation')),
    path('o/', include('oauth2_provider.urls', namespace='oauth2_provider')),

    path('i18n/', include('django.conf.urls.i18n')),
    path('jsi18n/', JavaScriptCatalog.as_view(), name='javascript-catalog'),
]

if settings.DEBUG:
    import debug_toolbar

    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
    urlpatterns += [
        path('__debug__/', include(debug_toolbar.urls)),
    ]
