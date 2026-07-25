from django.urls import path

from apps.users.views.admin.user_views import *

app_name = 'user'

urlpatterns = [
    path('staff/', AdminUserStuffListingView.as_view(), name='stuff-listing'),
    path('accounts/', AdminUserAccountsListingView.as_view(), name='accounts-listing'),
    path('<int:pk>/', AdminUserDetailsView.as_view(), name='details'),
    path('create/', AdminUserCreateOrUpdateView.as_view(), name='create'),
    path('<int:user_id>/update/', AdminUserCreateOrUpdateView.as_view(), name='update'),

    # students urls_admin
    path('students/', AdminStudentsAccountsListingView.as_view(), name='students')

]
