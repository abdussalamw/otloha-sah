from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.recitations.filters import RecitationFilter
from apps.recitations.forms import RecitationForm
from apps.recitations.models import Reciter, Recitation


class RecitationListAdminView(LoginRequiredMixin, AdminListView):
    model = Recitation
    filterset_class = RecitationFilter
    title = _('All Recitations')
    list_display = (
        ('id', _('ID')),
        ('name', _('Name')),
        ('narration', _('Narration')),
        ('reciter', _('Reciter')),
        ('actions', _('Actions'))
    )

    def load_name(self, obj):
        return mark_safe('<td class="main-cell"><a href="{}">{}</a></td>'.format(obj.get_details_url, obj.translated_name))

    def load_narration(self, obj):
        if obj.narration:
            return mark_safe(
                '<td class="main-cell">{}</td>'.format(obj.narration.translated_name))

    def load_reciter(self, obj):
        reciter_name = obj.reciter.name
        reciter_pk = Reciter.objects.get(name=reciter_name).id
        details = reverse('admin:recitations:reciters:details', args=[reciter_pk])
        return mark_safe('<td class="main-cell"><a href="{}">{}</a></td>'.format(details, obj.reciter.translated_name))

    def load_actions(self, obj):
        return mark_safe(
            '<td class="td--nowrap">' +
            '<a href="{}" title="{}" class="mx-1"><i class="fas fa-pen"></i></a>'
            .format(obj.get_edit_url, _('edit')) +
            '<a href="{}" title="{}" class="mx-1"><i class="fas fa-globe"></i></a>'
            .format(obj.get_translate_url, _('translate')) +
            '<a href="{}" title="{}" class="mx-1"><i class="fas fa-trash"></i></a>'
            .format(obj.get_delete_url, _('delete')) +
            '</td>'
        )

    def get_actions(self):
        add_recitation = reverse('admin:recitations:create')
        add_reciter = reverse('admin:recitations:reciters:create')
        return mark_safe(
            '<a href="{}" class="btn btn-primary btn-sm mr-1"><i class="fas fa-plus"></i> {}</a>'
            '<a href="{}" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i> {}</a>'.format(
                add_recitation,
                _("Add New Recitation"), add_reciter, _('Add New Reciter')))


class RecitationDetailAdminView(LoginRequiredMixin, View):
    def get(self, request, recitation_id, *args, **kwargs):
        recitation = get_object_or_404(Recitation, pk=recitation_id)
        return render(request, 'recitations/recitation/details.html', {
            'recitation': recitation,
            'title': _('Recitation Details')})


class RecitationCreateAndUpdateView(LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        if kwargs.get('recitation_id', None):
            recitation = get_object_or_404(Recitation, pk=kwargs.get('recitation_id'))
            form = RecitationForm(instance=recitation)
            title = "{} {}".format(_("Edit"), recitation.translated_name)
        else:
            form = RecitationForm()
            title = _('Add New Recitation')
        return render(request, 'recitations/recitation/form.html', {
            'form': form,
            'title': title
        })

    def post(self, request, *args, **kwargs):
        if kwargs.get('recitation_id', None):
            recitation = get_object_or_404(Recitation, pk=kwargs.get('recitation_id'))
            form = RecitationForm(data=request.POST, instance=recitation)
            title = "{} {}".format(_("Edit"), recitation.translated_name)
            message = _("Recitation Updated Successfully")

        else:
            form = RecitationForm(request.POST)
            title = _('Add New Recitation')
            message = _("Recitation Created Successfully")
        if form.is_valid():
            instance = form.save()
            messages.success(request, message)
            return redirect(instance.get_details_url)

        return render(request, 'recitations/recitation/form.html', {
            "form": form,
            "title": title
        })
