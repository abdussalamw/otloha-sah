from django.conf import settings
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView


class GetUpdatesView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        unseen_messages = request.user.seen_messages.filter(
            seen_at__isnull=True
        ).exclude(message__is_sent=False)

        unseen_notifications = request.user.notification_receiver.filter(is_seen=False)
        return Response({
            "unseen_messages": unseen_messages.count(),
            "unseen_notifications": unseen_notifications.count(),
        })


class GetMinimumAppVersion(APIView):
    permission_classes = []
    authentication_classes = []

    def get(self, request, *args, **kwargs):
        return Response({"version": settings.MIN_APP_VERSION})
