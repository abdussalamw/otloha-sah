from django.contrib.auth.mixins import LoginRequiredMixin
from django.http import JsonResponse
from django.shortcuts import get_object_or_404, render
from django.views import View

from .serializers import SiteNotificationSerializer


class NotificationsJsonListView(LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        user = request.user
        notifications = user.notification_receiver.all()

        if request.GET.get('mark_unseen') == 'true':
            notifications.filter(is_seen=False).update(is_seen=True)

        serializer = SiteNotificationSerializer(
            notifications.order_by('-created_at'),
            admin=request.GET.get('in_admin') == 'true',
            many=True)

        return JsonResponse({
            "data": serializer.data,
            "unseen_count": user.notification_receiver.unseen().count()
        })


class MarkNotificationAsReadView(LoginRequiredMixin, View):
    def get(self, request, notification_id, *args, **kwargs):
        notifications = request.user.notification_receiver.all()
        notification = get_object_or_404(notifications, pk=notification_id)
        notification.mark_as_read()
        return JsonResponse({})



class ServiceWorkerView(View):
    def get(self, request, *args, **kwargs):
        return render(request, 'notifications/firebase-messaging-sw.js', content_type="application/x-javascript")