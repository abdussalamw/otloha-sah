from django.urls import path

from apps.users.profile.views_site import ProfileIndex

app_name = 'profile'

urlpatterns = [
    path('', ProfileIndex.as_view(), name="index"),
]
