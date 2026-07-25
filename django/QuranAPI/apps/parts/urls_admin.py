from django.urls import path

from apps.parts.views_admin import *

app_name = 'parts'

urlpatterns = [
    path('', PartListingAdminView.as_view(), name="listing"),
    path('create/', PartCreateAndUpdateAdminView.as_view(), name='create'),
    path('<int:part_id>/update/', PartCreateAndUpdateAdminView.as_view(), name='update'),
]
