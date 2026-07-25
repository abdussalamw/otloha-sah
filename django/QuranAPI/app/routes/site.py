from django.urls import path, include


app_name = 'site'

urlpatterns = [
    path('', include('apps.main.urls_site', namespace='main')),
    path('users/', include('apps.users.urls.site.user_dashboard', namespace='users')),
    path('profile/', include('apps.users.profile.urls', namespace='profile')),

]

