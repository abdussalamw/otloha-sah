from django.urls import path

from apps.ads.views.views_admin_api_v1.actions import DeleteAdAPIView, ToggleActionAPIView
from apps.ads.views.views_admin_api_v1.ads import AdsListAPIView, CreateOrUpdateAdAPIView

app_name = 'ads'

urlpatterns = [
    path('', AdsListAPIView.as_view(), name='list'),
    path('create/', CreateOrUpdateAdAPIView.as_view(), name='create'),
    path('<int:pk>/edit/', CreateOrUpdateAdAPIView.as_view(), name='detail'),
    path('<int:pk>/delete/', DeleteAdAPIView.as_view(), name='delete'),
    path('<int:pk>/<str:action>/', ToggleActionAPIView.as_view(), name='action'),
]
