from django.urls import path, include

app_name = 'admin'

urlpatterns = [
    path('', include('apps.main.urls.urls_admin', namespace='main')),
    # path('authorization', include('apps.authz.urls.urls_admin', namespace='authorization')),
    path('recitations/', include('apps.recitation.urls_admin', namespace='recitations')),
    path('chat/', include('apps.chat.urls_admin', namespace='chat')),
    path('ads/', include('apps.ads.urls.urls_admin', namespace='ads')),
    path('reports/', include('apps.reports.urls.urls_admin', namespace='reports')),
    path('new-recitations/', include('apps.recitations.urls.urls_admin.urls', namespace='new-recitations')),
    path('settings/', include('apps.settings.urls.urls_admin_site.urls', namespace='settings')),
    path('groups/', include("apps.users.urls.urls_admin_groups", namespace='groups')),
    path('tajweed/', include('apps.tajweed.urls.urls_admin', namespace='tajweed')),
    path('quran/', include('quran_api_client.urls', namespace='quran-api')),
    path('<str:user_type>/', include('apps.users.urls.urls_admin', namespace='users')),

]
