from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.shortcuts import get_object_or_404, render, redirect
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View
# from apps.main.views_admin import AdminListView
from dynamic_listing.views import DynamicTableView

from apps.ads.filters import AdsFilter
from apps.ads.forms import AdForm
from apps.ads.models import Ad


class ListingView(LoginRequiredMixin, PermissionRequiredMixin, DynamicTableView):
    permission_required = "ads.view_ads"
    model = Ad
    title = _("All Ads")
    load_rows_from_template = True
    filterset_class = AdsFilter
    row_template_name = "ads/admin/listing/_table_row.html"
    listing_actions = 'ads/admin/listing/_actions.html'
    table_columns = (
        ("id", _("ID"), "w-10px pe-2"),
        ("title", _("Title"), "min-w-125px"),
        ("url", _("URL"), "min-w-100px"),
        ("image", _("Image"), "min-w-100px"),
        ("created_at", _("Created At"), "min-w-100px"),
        ("ad_status", _("Ad Status")),
        ("actions", _("Actions")),
    )

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"title": _("All Ads"), },
        ]


class CreateOrUpdateAdView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ('ads.change_ad',) if self.kwargs.get('pk', None) else ('ads.add_ad',)

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:ads:listing"), "title": _("All Ads"), },
            {"title": _("Edit Ad") if self.kwargs.get('pk', None) else _("Create Ad")}
        ]

    def get(self, request, *args, **kwargs):
        if 'pk' in kwargs:
            ad = get_object_or_404(Ad, pk=kwargs['pk'])
            form = AdForm(instance=ad)
            title = _("Update Ad")
        else:
            form = AdForm()
            title = _("Create Ad")

        return render(request, 'ads/admin/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })

    def post(self, request, *args, **kwargs):
        if 'pk' in kwargs:
            ad = get_object_or_404(Ad, pk=kwargs['pk'])
            form = AdForm(request.POST, request.FILES, instance=ad)
            message = _("Ad Updated Successfully")
            title = _("Update Ad")
        else:
            form = AdForm(request.POST, request.FILES)
            message = _("Ad Created Successfully")
            title = _("Create Ad")

        if form.is_valid():
            form.save()
            messages.success(request, message)
            return redirect(reverse('admin:ads:listing'))

        return render(request, 'ads/admin/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })


class DeleteAdView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = 'ads.delete_ad'

    def post(self, request, pk, *args, **kwargs):
        ad = get_object_or_404(Ad, pk=pk)
        ad.delete()
        messages.success(request, _("Ad Deleted Successfully"))
        return redirect(reverse('admin:ads:listing'))


class ToggleActionView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = 'ads.change_ad'

    def get(self, request, *args, **kwargs):
        if 'next' not in request.GET:
            raise KeyError("'next' parameter is required")

        ad = get_object_or_404(Ad, pk=kwargs['pk'])

        status, message = ad.toggle_active()

        if status:
            messages.success(request, message)
        else:
            messages.error(request, message)

        return redirect(request.GET.get('next'))
