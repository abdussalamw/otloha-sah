from django.urls import path

from apps.recitation.views_site import RecitationListingView

app_name = "recitations"

urlpatterns = [
    path('', RecitationListingView.as_view(), name='listing'),
]
