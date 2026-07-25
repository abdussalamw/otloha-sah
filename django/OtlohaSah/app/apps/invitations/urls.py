from django.urls import path
from rest_framework import routers

from apps.invitations.views import InvitationListAPIView, \
    RespondToInvitationView, RequestInvitationView, BlockListAPIView, BanedInvitationListAPIView, BlockListCreateView, \
    BlockListDeleteView, BanedInvitationCreateView, BanedInvitationDeleteView, InvitationReceivedListAPIView

app_name = 'invitations'

urlpatterns = [

    path('request/', InvitationListAPIView.as_view(), name="list"),
    path('request_received/', InvitationReceivedListAPIView.as_view(), name="Received_list"),
    path('request/create/', RequestInvitationView.as_view(), name="request"),
    path('response/<int:pk>/', RespondToInvitationView.as_view(), name="response"),
    path('block/', BlockListAPIView.as_view(), name="list"),
    path('block/create/', BlockListCreateView.as_view(), name="block_list_create"),
    path('block/<int:pk>/delete/', BlockListDeleteView.as_view(), name="delete"),

    path('ban/', BanedInvitationListAPIView.as_view(), name="list"),
    path('ban/create/', BanedInvitationCreateView.as_view(), name="create"),
    path('ban/<int:pk>/delete/', BanedInvitationDeleteView.as_view(), name="delete"),

]
