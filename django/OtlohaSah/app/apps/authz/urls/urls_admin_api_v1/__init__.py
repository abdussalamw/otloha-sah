from django.urls import path, include

app_name = 'authz'

urlpatterns = [
    path('groups/', include('apps.authz.urls.urls_admin_api_v1.urls_admin_api_roles_v1', namespace='groups')),

    path('permissions/',
         include('apps.authz.urls.urls_admin_api_v1.urls_admin_api_permissions_v1', namespace='permissions')),
]
