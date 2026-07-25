from django.urls import path

from apps.tajweed.views.views_admin_v1 import LevelListingView, CreateOrUpdateLevelView, DeleteLevelView
from apps.tajweed.views.views_admin_v1.views_admin_levels_v1 import LevelDetailView

app_name = 'levels'

urlpatterns = [
    path('', LevelListingView.as_view(), name="listing"),
    path('create/', CreateOrUpdateLevelView.as_view(), name='create'),
    path('<int:pk>/', LevelDetailView.as_view(), name='details'),
    path('<int:pk>/update/', CreateOrUpdateLevelView.as_view(), name='update'),
    path('<int:pk>/delete/', DeleteLevelView.as_view(), name='delete'),
]
