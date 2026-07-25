from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.contrib.humanize.templatetags import humanize
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.narrations.forms import NarrationForm
from apps.narrations.models import Narration


class NarrationListingView(LoginRequiredMixin, AdminListView):
    model = Narration
    title = _('All Narrations')

    list_display = (
        ('id', _('ID')),
        ('name', _('Name')),
        ('is_active', _('Is Active')),
        ('created_at', _('Created At')),
        ('updated_at', _('Updated At')),
        ('actions', _('Actions'))
    )

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": _("Narrations"), "url": reverse("admin:narrations:listing")},
            {"name": self.title}
        ]

    def load_name(self, obj):
        return mark_safe(
            '<td class="main-cell"><a href="{}">{}</a></td>'.format(
                reverse('admin:narrations:details', args=[obj.pk]), obj.translated_name))

    def load_is_active(self, obj):
        return mark_safe('<td>{}</td>'.format(_("Yes") if obj.is_active else _("No")))

    def load_created_at(self, obj):
        return mark_safe('<td>{}</td>'.format(humanize.datetime.date(obj.created_at)))

    def load_updated_at(self, obj):
        return mark_safe('<td>{}</td>'.format(humanize.datetime.date(obj.updated_at)))

    def get_actions(self):
        return mark_safe('<a href="{}" class="btn btn-primary btn-sm">'
                         '<i class="fas fa-plus"></i>{}</a>'.format(reverse("admin:narrations:create"),
                                                                    _("Add New Narration")))

    def load_actions(self, obj):
        return mark_safe(
            '<td class="td--nowrap">' +
            '<a href="{}?next={}" title="{}" class="mx-1 btn btn-sm btn-info"><i class="fa fa-sync"></i></a>'
            .format(
                reverse('admin:narrations:toggle-action', args=[obj.pk, 'generate_json_file']),
                reverse('admin:narrations:listing'),
                _('Generate Json File')) +
            '<a href="{}?next={}" title="{}" class="mx-1 btn btn-sm btn-{}"><i class="fa fa-{}"></i></a>'
            .format(
                reverse('admin:narrations:toggle-action', args=[obj.pk, 'toggle_active']),
                reverse('admin:narrations:listing'),
                _('Toggle Active'),
                'danger' if obj.is_active else 'success',
                'times' if obj.is_active else 'check',
            ) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-primary"><i class="fa fa-edit"></i></a>'
            .format(obj.get_edit_url, _('Edit')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-info"><i class="fa fa-globe"></i></a>'
            .format(obj.get_translate_url, _('Translate')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-danger"><i class="fa fa-trash"></i></a>'
            .format(obj.get_delete_url, _('Delete')) +
            '</td>'
        )


class NarrationCreateAndUpdateAdminView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ("narrations.change_narration",) if self.kwargs.get('narration_id', None) \
            else ("narrations.add_narration",)

    def get(self, request, *args, **kwargs):
        if kwargs.get('narration_id', None):
            narration = get_object_or_404(Narration, pk=kwargs.get('narration_id'))
            form = NarrationForm(instance=narration)
            title = "{} {}".format(_("Edit"), narration.translated_name)
        else:
            form = NarrationForm()
            title = _("Add New Narration")
        return render(request, 'narrations/form.html', {
            'form': form,
            'title': title
        })

    def post(self, request, *args, **kwargs):
        if kwargs.get('narration_id', None):
            narration = get_object_or_404(Narration, pk=kwargs.get('narration_id'))
            form = NarrationForm(instance=narration, data=request.POST)
            title = "{} {}".format(_("Edit"), narration.translated_name)
            message = _("Narration Updated Successfully")
        else:
            form = NarrationForm(request.POST)
            title = _("Add New Narration")
            message = _("Narration Created Successfully")

        if form.is_valid():
            instance = form.save()
            messages.success(request, message)
            return redirect(reverse('admin:narrations:details', args=[instance.pk]))

        return render(request, 'narrations/form.html', {
            "form": form,
            "title": title,
        }, status=422)


class NarrationDetailsView(LoginRequiredMixin, View):
    def get(self, request, narration_id, *args, **kwargs):
        narration = get_object_or_404(Narration, pk=narration_id)
        return render(request, 'narrations/details.html', {
            'narration': narration,
            'title': _('{narration} Narration Details').format(narration=narration.translated_name)
        })


class NarrationActionView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = "narrations.change_narration"

    def get(self, request, narration_id, action, *args, **kwargs):
        if 'next' not in request.GET:
            raise Exception("'next' parameter is required")

        narration = get_object_or_404(Narration, pk=narration_id)

        method = 'do_' + action
        if hasattr(narration, method) and callable(getattr(narration, method)):
            status, message = getattr(narration, method)()
            messages.success(request, message)
        return redirect(request.GET.get('next'))
