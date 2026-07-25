from django.contrib.auth.mixins import PermissionRequiredMixin, LoginRequiredMixin
from django.shortcuts import render
from django.views import View

from apps.notifications.models import Via


class NotificationCreateView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = ("notifications.create_notification",)

    def get(self, request, via, *args, **kwargs):

        return render(request, f'notifications/form/{self.kwargs.get("via")}.html', {

        })
