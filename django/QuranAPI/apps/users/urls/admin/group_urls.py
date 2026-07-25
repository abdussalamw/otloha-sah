from django.urls import path

from apps.users.views.admin.group_views import *

app_name = 'group'

urlpatterns = [
    path('', AdminGroupListingView.as_view(), name='listing'),
    path('<int:pk>', AdminGroupDetailsView.as_view(), name='details'),
    path('create', AdminGroupCreateOrUpdate.as_view(), name='create'),
    path('<int:pk>/edit', AdminGroupCreateOrUpdate.as_view(), name='edit')
]
