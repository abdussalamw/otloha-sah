from django.urls import path

# from apps.ads import views_api_v1
from apps.ads.views.views_admin import ListingView, CreateOrUpdateAdView, ToggleActionView

app_name = 'ads'

urlpatterns = [
    path('', ListingView.as_view(), name='listing'),
    path('create/', CreateOrUpdateAdView.as_view(), name='create'),
    path('<int:pk>/', CreateOrUpdateAdView.as_view(), name='update'),
    # path('<int:pk>/delete/', DeleteAdView.as_view(), name='delete'),
    path('<int:pk>/toggle-active/', ToggleActionView.as_view(), name='toggle-active'),

    # # Ads Json Data
    # path('ads/jsondata/', views_api_v1.Ad_json)
]
