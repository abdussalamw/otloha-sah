from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.http import JsonResponse
from django.shortcuts import render, redirect
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View

from apps.settings.forms import SettingsFormSet, UserSettingsFormSet
from apps.settings.models import Setting


class BaseSettingView(View):
    message = _("Settings Updated Successfully!")
    template_name = 'settings/admin/index.html'
    formset_class = None
    title = None
    settings_groups = []
    breadcrumb = []

    def get_redirect_url(self):
        return self.request.path

    def get_formset(self, *args, **kwargs):
        return self.formset_class(*args, **kwargs)

    def get_settings_groups(self):
        return self.settings_groups

    def get_breadcrumb(self):
        return self.breadcrumb

    def get_title(self):
        return self.title

    def get_response(self, formset):
        return render(self.request, self.template_name, {
            "title": self.get_title(),
            "breadcrumb": self.get_breadcrumb(),
            "settings_groups": self.get_settings_groups(),
            "actions": "settings/admin/_actions.html",
            "formset": formset,
        })

    def get_queryset(self):
        return Setting.objects.all()

    def get(self, request, settings_group, *args, **kwargs):
        queryset = self.get_queryset().filter(group=settings_group)
        return self.get_response(self.get_formset(queryset=queryset))

    def post(self, request, settings_group, *args, **kwargs):
        formset = self.get_formset(request.POST)

        if formset.is_valid():
            formset.save()
            messages.success(request, self.message)
            queryset = self.get_queryset().filter(group=settings_group)
            return redirect( self.get_redirect_url())

        return self.get_response(formset)


class SettingView(LoginRequiredMixin, PermissionRequiredMixin, BaseSettingView):
    permission_required = ("settings.view_setting", "settings.change_setting")
    message = _("Settings Updated Successfully!")
    template_name = 'settings/admin/index.html'
    title = _("All Settings")
    formset_class = SettingsFormSet

    def get_breadcrumb(self):
        return [
            {"url": "/admin/", "title": _("Home"), },
            {"title": _("All Settings"), },
        ]

    def get_settings_groups(self):
        return [
            {
                "url": reverse("admin:settings:listing", args=[Setting.SETTINGS_GROUP_RECITATIONS]),
                "title": _("Recitations Settings")
            },
            {
                "url": reverse("admin:settings:listing", args=[Setting.SETTINGS_USER_LEVELS]),
                "title": _("User Levels")
            },
            {
                "url": reverse("admin:settings:listing", args=[Setting.SETTINGS_PRICING]),
                "title": _("Pricing")
            }
        ]

    def get_title(self):
        return self.title

    def get_queryset(self):
        return Setting.objects.all()


class ResetSettingsView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = "settings.change_setting"

    def post(self, request, *args, **kwargs):
        Setting.objects.reset()
        message = _("Settings Reset Successfully!")
        messages.success(request, message)
        return JsonResponse({"message": message})


class CollectMissingSettingsView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = "settings.change_setting"

    def post(self, request, *args, **kwargs):
        Setting.objects.collect_missing_settings()
        message = _("Missing Settings Collected Successfully!")
        messages.success(request, message)
        return JsonResponse({"message": message})


class UserSettingsView(LoginRequiredMixin, BaseSettingView):
    formset_class = UserSettingsFormSet

    def get_queryset(self):
        return self.request.user.settings.all()
