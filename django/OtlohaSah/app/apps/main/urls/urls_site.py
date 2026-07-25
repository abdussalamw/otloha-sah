from django.urls import path

from apps.main.views.views_site import SystemDocumentsView, Home

app_name = 'main'

urlpatterns = [
    path('', Home.as_view(), name="home"),
    path('<str:slug>/', SystemDocumentsView.as_view(), name="system_document")
]
