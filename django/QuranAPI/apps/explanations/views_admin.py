from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.explanations.filters import ExplanationAdminFilter
from apps.explanations.forms import ExplanationForm
from apps.explanations.models import Explanation
from apps.main.views_admin import AdminListView


class ExplanationListingView(LoginRequiredMixin, AdminListView):
    model = Explanation
    filterset_class = ExplanationAdminFilter
    title = _('All Explanations')
    list_display = (
        ('id', _('ID')),
        ('name', _('Name')),
        ('narration', _('Narration')),
        ('actions', _('Actions')),
    )

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": self.title}
        ]

    def load_name(self, obj):
        return mark_safe('<td class="main-cell"><a href="{}">{}</a></td>'.format(obj.get_details_url, obj.translated_name))

    def get_actions(self):
        url = reverse('admin:explanations:create')
        return mark_safe('<a href="{}" class="btn btn-primary btn-sm">'
                         '<i class="fas fa-plus"></i>{}</a>'.format(url,
                                                                    _("Add New Explanation")))

    def load_actions(self, obj):
        return mark_safe(
            '<td class="td--nowrap">' +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-primary"><i class="fa fa-edit"></i></a>'
            .format(obj.get_edit_url, _('Edit')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-info"><i class="fa fa-globe"></i></a>'
            .format(obj.get_translate_url, _('Translate')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-danger"><i class="fa fa-trash"></i></a>'
            .format(obj.get_delete_url, _('Delete')) +
            '</td>'
        )


class ExplanationDetailsView(LoginRequiredMixin, View):
    def get(self, request, explanation_id, *args, **kwargs):
        explanation = get_object_or_404(Explanation, pk=explanation_id)
        return render(request, 'explanations/details.html', {
            'explanation': explanation,
            'title': "{} {}".format(explanation.translated_name, _('Explanation Details'))
        })


class ExplanationCreateAndUpdateView(LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        if kwargs.get('explanation_id', None):
            explanation = get_object_or_404(Explanation, pk=kwargs.get('explanation_id'))
            form = ExplanationForm(instance=explanation)
            title = "{} {}".format(_("Edit"), explanation.translated_name)
        else:
            form = ExplanationForm()
            title = _('Add New Explanation')
        return render(request, 'explanations/form.html', {
            'form': form,
            'title': title
        })

    def post(self, request, *args, **kwargs):
        if kwargs.get('explanation_id', None):
            explanation = get_object_or_404(Explanation, pk=kwargs.get('explanation_id'))
            form = ExplanationForm(data=request.POST, instance=explanation)
            title = "{} {}".format(_("Edit"), explanation.translated_name)
            message = _("Explanation Updated Successfully")
        else:
            form = ExplanationForm(request.POST)
            title = _('Add New Explanation')
            message = _("Explanation Created Successfully")

        if form.is_valid():
            instance = form.save()
            messages.success(request, message)
            return redirect(reverse('admin:explanations:details', args=[instance.pk]))

        return render(request, 'explanations/form.html', {
            "form": form,
            "title": title
        })
