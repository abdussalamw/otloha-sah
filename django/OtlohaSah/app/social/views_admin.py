from django.contrib import messages
from django.contrib.auth.mixins import PermissionRequiredMixin, LoginRequiredMixin
from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from django.utils.translation import gettext as _
from django.views import View

from dynamic_listing.views import DynamicTableView
from social.forms import ProviderForm
from social.models import Provider


class ProvidersListView(LoginRequiredMixin, PermissionRequiredMixin, DynamicTableView):
    permission_required = "social.view_provider"
    model = Provider
    title = _("Social Providers")
    load_rows_from_template = True
    row_template_name = 'social/admin/listing/_table_row.html'
    empty_listing_actions_template_name = 'social/admin/listing/empty-listing-actions.html'
    modals_template_name = 'social/admin/listing/_modals.html'
    table_columns = (
        ('id', _('ID'), "w-10px pe-2"),
        ('name', _('Name'), "w-125px pe-2"),
        ('provider', _('Provider'), "w-125px pe-2"),
        ('client_id', _('Client ID'), "w-150px pe-2"),
        ('is_active', _('Is Active'), "w-75px pe-2"),
        ('default_provider', _('Is Default'), "w-75px pe-2"),
        ('actions', _('Actions'), "w-125px pe-2 text-end"),
    )
    media = {
        "js": ("social/js/admin-scripts.js",)
    }

    def get_context_data(self, *args, **kwargs):
        context = super(ProvidersListView, self).get_context_data(*args, **kwargs)
        context['provider_form'] = ProviderForm()
        return context

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"title": _("Social Providers"), },
        ]


class CreateOrUpdateProviderView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ("social.change_provider",) if self.kwargs.get("provider_id", None) else ("social.add_provider",)

    def post(self, request, *args, **kwargs):
        if kwargs.get('provider_id', None):
            provider = get_object_or_404(Provider, pk=kwargs.get('provider_id'))
            form = ProviderForm(request.POST, instance=provider)
            message = _("Provider Updated Successfully")
        else:
            form = ProviderForm(request.POST)
            message = _("Provider Created Successfully")

        if form.is_valid():
            instance = form.save()
            messages.success(request, message)
            return JsonResponse({
                "message": message
            })

        errors = {f: e.get_json_data()[0]['message'] for f, e in form.errors.items()}
        return JsonResponse(errors, status=422)
