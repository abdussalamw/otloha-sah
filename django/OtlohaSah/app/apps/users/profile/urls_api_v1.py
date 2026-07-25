from django.urls import path, include

from apps.users.views.views_api_v1 import ProfileAPIView, DeleteAccountAPIView

app_name = 'profile'

urlpatterns = [
    path('', ProfileAPIView.as_view(), name='profile'),
    path('delete-account/', DeleteAccountAPIView.as_view(), name="delete-account")
]
