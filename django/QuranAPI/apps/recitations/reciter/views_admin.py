from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.contrib.humanize.templatetags import humanize
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.recitations.models import Reciter
from apps.recitations.reciter.filters import ReciterAPIFilter
from apps.recitations.reciter.forms import ReciterForm


class ReciterListAdminView(LoginRequiredMixin, PermissionRequiredMixin, AdminListView):
    model = Reciter
    permission_required = ('recitations.view_reciter',)
    filterset_class = ReciterAPIFilter
    title = _('All Reciters')
    list_display = (
        ('id', _('ID')),
        ('name', _('name')),
        ('created_at', _('created at')),
        ('updated_at', _('updated_at')),
    )

    def get_queryset(self):
        return Reciter.objects.all()

    def load_name(self, obj):
        details = reverse('admin:recitations:reciters:details', args=[obj.pk])
        return mark_safe('<td class="main-cell"><a href="{}">{}</a></td>'.format(details, obj.translated_name))

    def load_created_at(self, obj):
        return mark_safe('<td class="main-cell">{}</td>'.format(humanize.naturaltime(obj.created_at)))

    def load_updated_at(self, obj):
        return mark_safe('<td class="main-cell">{}</td>'.format(humanize.naturaltime(obj.updated_at)))

    def get_actions(self):
        add = reverse('admin:recitations:reciters:create')
        return mark_safe('<a href="{}" class="btn btn-primary btn-block">'
                         '<i class="fas fa-plus"></i>{}</a>'.format(add, _("Add New Reciter")))


class ReciterDetailsView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = ('recitations.view_reciter',)

    def get(self, request, reciter_id, *args, **kwargs):
        reciter = get_object_or_404(Reciter, pk=reciter_id)
        return render(request, 'recitations/reciter/details.html', {
            'reciter': reciter,
            'title': "{} {}".format(reciter.translated_name, _("Details"))
        })


class ReciterCreateOrUpdateView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ("recitations.change_reciter",) if self.kwargs.get('reciter_id', None) else ("recitations.add_reciter",)

    def get(self, request, *args, **kwargs):
        if kwargs.get('reciter_id', None):
            reciter = get_object_or_404(Reciter, pk=kwargs.get('reciter_id'))
            form = ReciterForm(instance=reciter)
            title = "{} {}".format(_("Edit"), reciter.translated_name)
        else:
            form = ReciterForm()
            title = _('Add New Reciter')

        return render(request, 'recitations/reciter/form.html', {
            'form': form,
            'title': title
        })

    def post(self, request, *args, **kwargs):
        if kwargs.get('reciter_id', None):
            reciter = get_object_or_404(Reciter, pk=kwargs.get('reciter_id'))
            form = ReciterForm(data=request.POST, instance=reciter)
            message = _("Reciter Updated Successfully")
            title = "{} {}".format(_("Edit"), reciter.translated_name)
        else:
            form = ReciterForm(request.POST)
            message = _("Reciter Created Successfully")
            title = _('Add New Reciter')

        if form.is_valid():
            instance = form.save()
            messages.success(request, message)
            return redirect(reverse('admin:recitations:reciters:details', args=[instance.pk]))
        return render(request, 'recitations/reciter/form.html', {
            "form": form,
            "title": title
        })
