from django.urls import path

from apps.authz.views.views import GroupListingView, GroupCreateOrUpdateView, GroupDetailsView, DeleteGroupView, \
    GrantGroupAccessView, RevokeGroupAccessView

app_name = 'authorization'

urlpatterns = [
    path('', GroupListingView.as_view(), name='listing'),
    path('create/', GroupCreateOrUpdateView.as_view(), name='create'),
    path('<int:pk>/', GroupDetailsView.as_view(), name='details'),
    path('<int:pk>/edit/', GroupCreateOrUpdateView.as_view(), name='edit'),
    path("<int:pk>/delete/", DeleteGroupView.as_view(), name="delete"),
    path("<int:pk>/grant-access/", GrantGroupAccessView.as_view(), name="grant-access"),
    path("<int:pk>/bulk-revoke-access/", RevokeGroupAccessView.as_view(), name="bulk-revoke-access"),
    path("<int:pk>/revoke-access/<int:user_id>/", RevokeGroupAccessView.as_view(), name="revoke-access"),
]
