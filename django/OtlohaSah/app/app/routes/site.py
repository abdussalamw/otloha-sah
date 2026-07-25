from django.urls import path, include

app_name = 'site'

urlpatterns = [
    path('', include('apps.main.urls.urls_site', namespace='main')),
    # path('profile/', include('apps.users.profile.urls_site', namespace='profile')),
    # path('recitations/', include('apps.recitation.urls_site', namespace='recitations')),
]
