from django.urls import path

from apps.main.views.view_api_v1 import GetUpdatesView, GetMinimumAppVersion

app_name = "main"

urlpatterns = [
    path("get-updates/", GetUpdatesView.as_view(), name="get-updates"),
    path("min-app-version/", GetMinimumAppVersion.as_view(), name="min-app-version"),
]
