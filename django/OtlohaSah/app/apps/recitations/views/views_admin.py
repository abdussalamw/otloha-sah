from django.contrib import messages
from django.contrib.auth.mixins import PermissionRequiredMixin, LoginRequiredMixin
from django.shortcuts import get_object_or_404, redirect
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View
from django.views.generic import DetailView
from dynamic_listing import DynamicListFactory
from dynamic_listing.views import DynamicListView

from apps.recitations import config
from apps.recitations.filters_site import RecitationFilter
from apps.recitations.models import Recitation

RecitationDynamicListingFactory = DynamicListFactory(
    model=Recitation,
    filterset_class=RecitationFilter,
    item_template_name="admin/listing/_list_item.html",
    header_template_name="users/admin/details/tab_contents/partials/__recitations.html"
)


class AdminRecitationsListingView(LoginRequiredMixin, PermissionRequiredMixin, DynamicListView):
    permission_required = "recitation.view_recitation"
    model = Recitation
    filterset_class = RecitationFilter
    title = _("All Recitations")
    item_template_name = "admin/listing/_list_item.html"
    header_template_name = "admin/listing/_header_template.html"

    def get_context_data(self, *args, **kwargs):
        context = super().get_context_data(*args, **kwargs)
        recitations = Recitation.objects.all()

        context['all_recitations_count'] = recitations.count()
        context['rejected_recitations_count'] = recitations.filter(result=config.RECITATIONS_RESULT_REJECTED).count()
        context['corrected_recitations_count'] = recitations.filter(result=config.RECITATIONS_RESULT_ACCEPTED).count()
        context['remarkable_recitations_count'] = recitations.filter(is_remarkable=True).count()
        context['reported_recitations_count'] = recitations.filter(userrecitationreport__isnull=False).count()
        context['pending_recitations_count'] = recitations.filter(result=config.RECITATIONS_RESULT_PENDING).count()
        return context

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"title": _("All Recitations"), },
        ]


class AdminRecitationDeleteView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = "recitation.delete_recitation"

    def post(self, request, pk):
        instance = get_object_or_404(Recitation, pk=pk)
        previous_page = request.META.get('HTTP_REFERER')

        if not instance.owner.is_a_teacher:
            messages.error(request, _("Can't delete student recitation!"))
            return redirect(previous_page)

        instance.delete()
        messages.success(request, _("Teacher recitation deleted successfully!"))
        return redirect(previous_page)


class AdminRecitationsDetailsView(LoginRequiredMixin, PermissionRequiredMixin, DetailView):
    permission_required = "recitation.view_recitation"
    model = Recitation
    template_name = 'admin/details/index.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)

        context['title'] = _("Recitation ID-{}").format(self.object.id)
        context['breadcrumb'] = [
            {"url": "/", "title": _("Home"), },
            {"title": _("All Recitations"), "url": reverse("admin:new-recitations:listing")},
            {"title": context['title'], },
        ]
        return context
