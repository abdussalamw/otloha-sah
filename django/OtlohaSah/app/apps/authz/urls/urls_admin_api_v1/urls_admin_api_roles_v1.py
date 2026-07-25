from django.urls import path

from apps.authz.views import GroupUpdateAPIView, GroupCreateAPIView, GroupListAPIView, GroupDeleteAPIView, \
    GrantGroupAccessAPIView, GroupDetailsAPIView, RevokeGroupAccessAPIView, ResponsePermissionRequestView, \
    PermissionRequestView, PermissionRequestListAPIView

app_name = 'groups'

urlpatterns = [
    path('', GroupListAPIView.as_view(), name='listing'),
    path('create/', GroupCreateAPIView.as_view(), name='create'),
    path('<int:pk>/', GroupDetailsAPIView.as_view(), name='details'),
    path('<int:pk>/edit/', GroupUpdateAPIView.as_view(), name='edit'),
    path("<int:pk>/delete/", GroupDeleteAPIView.as_view(), name="delete"),
    path("<int:pk>/grant-access/", GrantGroupAccessAPIView.as_view(), name="grant-access"),
    path("<int:pk>/revoke-access/<int:user_id>/", RevokeGroupAccessAPIView.as_view(), name="revoke-access"),

]
