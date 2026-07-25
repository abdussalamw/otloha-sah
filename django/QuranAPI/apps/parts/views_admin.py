from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.contrib.humanize.templatetags import humanize
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.parts.filters import PartFilter
from apps.parts.forms import PartForm
from apps.parts.models import Part


class PartListingAdminView(LoginRequiredMixin, PermissionRequiredMixin, AdminListView):
    model = Part
    filterset_class = PartFilter
    title = _("All Parts")
    permission_required = ("parts.view_part",)
    list_display = (
        ('id', 'id'),
        ('name', _('name')),
        ('alias', _('alias')),
        ('part_number', _('part_number')),
        ('created_at', 'created at'),
        ('updated_at', 'updated_at'),
        ('actions', _('actions'))
    )

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": _("Parts"), "url": reverse("admin:parts:listing")},
            {"name": self.title}
        ]

    def load_alias(self, obj):
        return mark_safe('<td>{}</td>'.format(obj.translated_alias))

    def load_name(self, obj):
        return mark_safe('<td class="main-cell">{}</td>'.format(obj.translated_name))

    def load_created_at(self, obj):
        return mark_safe('<td class="main-cell">{}</td>'.format(humanize.datetime.date(obj.created_at)))

    def load_updated_at(self, obj):
        return mark_safe('<td class="main-cell">{}</td>'.format(humanize.datetime.date(obj.updated_at)))

    def get_actions(self):
        return mark_safe('<a href="{}" class="btn btn-primary btn-block">'
                         '<i class="fas fa-plus"></i>{}</a>'.format(
            reverse("admin:parts:create"),
            _("Add New Part")))

    def load_actions(self, obj):
        return mark_safe(
            '<td class="td--nowrap">' +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-primary"><i class="fa fa-edit"></i></a>'
            .format(reverse('admin:parts:update', args=[obj.pk]), _('Edit')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-info"><i class="fa fa-globe"></i></a>'
            .format(reverse('translation:translate_form', args=['parts', 'part', obj.pk]) + '?next={}'.format(
                reverse('admin:parts:listing')), _('Translate')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-danger"><i class="fa fa-trash"></i></a>'
            .format(
                reverse('admin:softdelete:single-delete', args=['parts', 'Part', obj.pk]) + '?next={}'.format(
                    reverse('admin:parts:listing')),

                _('Delete')) +
            '</td>'
        )


class PartCreateAndUpdateAdminView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ('parts.change_part',) if self.kwargs.get('part_id', None) else ('parts.add_part',)

    def get(self, request, *args, **kwargs):
        if kwargs.get('part_id', None):
            part = get_object_or_404(Part, pk=kwargs.get('part_id'))
            form = PartForm(instance=part)
        else:
            form = PartForm()
        return render(request, 'parts/form.html', {
            'form': form,
            'title': _('Part Form')
        })

    def post(self, request, *args, **kwargs):
        if kwargs.get('part_id', None):
            part = get_object_or_404(Part, pk=kwargs.get('part_id'))
            form = PartForm(data=request.POST, instance=part)
        else:
            form = PartForm(request.POST)
        if form.is_valid():
            instance = form.save()

            return redirect(reverse('admin:parts:listing'))
        return render(request, 'parts/form.html', {
            "form": form,
            'title': _('Part Form')
        }, status=422)
