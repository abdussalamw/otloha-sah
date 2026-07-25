from django.urls import path

from apps.authz.views import ResponsePermissionRequestView, PermissionRequestView, PermissionRequestListAPIView, \
    UsersPermissionsListView, UserPermissionsView

app_name = 'permissions'

urlpatterns = [
    path("", UsersPermissionsListView.as_view(), name="listing-permissions"),
    path("requested-permissions/", PermissionRequestListAPIView.as_view(), name="requested-permissions"),
    path("<int:user_id>/", UserPermissionsView.as_view(), name="user-permissions"),
    path("<int:permission_id>/request-permission/", PermissionRequestView.as_view(), name="request-permission"),
    path("<int:pk>/response-permission/<str:action>/", ResponsePermissionRequestView.as_view(),
         name="response-permission"),
]
