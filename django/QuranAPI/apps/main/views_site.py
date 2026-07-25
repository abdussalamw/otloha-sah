from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import redirect
from django.urls import reverse
from django.views import View


class Home(LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        return redirect(reverse("admin:main:home"))
