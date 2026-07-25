from django.urls import path

from apps.tajweed.views.views_admin_v1 import LevelListingView, CreateOrUpdateLevelView, DeleteLevelView, \
    UserLevelPassedListingView, CreateOrUpdateUserLevelPassedView, DeleteUserLevelPassedView

app_name = 'user-level-passed'

urlpatterns = [
    path('', UserLevelPassedListingView.as_view(), name="listing"),
    path('create/', CreateOrUpdateUserLevelPassedView.as_view(), name='create'),
    path('<int:pk>/update/', CreateOrUpdateUserLevelPassedView.as_view(), name='update'),
    path('<int:pk>/delete/', DeleteUserLevelPassedView.as_view(), name='delete'),
]
