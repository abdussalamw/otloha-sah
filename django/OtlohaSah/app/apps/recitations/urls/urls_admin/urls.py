from django.urls import path

from apps.recitations.views.views_admin import AdminRecitationsListingView, AdminRecitationDeleteView, AdminRecitationsDetailsView

app_name = "new-recitations"

urlpatterns = [
    path('', AdminRecitationsListingView.as_view(), name='listing'),
    path('<int:pk>/delete/', AdminRecitationDeleteView.as_view(), name='delete'),
    path('<int:pk>/', AdminRecitationsDetailsView.as_view(), name='details'),

]
