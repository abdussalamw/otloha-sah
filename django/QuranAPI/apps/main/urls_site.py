from django.urls import path

from apps.main.views_site import Home

app_name = 'main'

urlpatterns = [
    path('', Home.as_view(), name="home")
]
