from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.tajweed.filters import RuleFilter
from apps.tajweed.forms import RuleForm
from apps.tajweed.models import Rule


class RulesListingView(LoginRequiredMixin, AdminListView):
    model = Rule
    filterset_class = RuleFilter
    title = _('All Rules')
    list_display = (
        ('id', _('ID')),
        ('name', _('Name')),
        ('rule_number', _('Rule Number')),
        ('color', _('Color')),
        ('actions', _('Actions'))
    )

    def get_actions(self):
        return mark_safe('<a href="{}" class="btn btn-primary btn-block btn-sm">'
                         '<i class="fas fa-plus"></i>{}</a>'.format(
            reverse("admin:tajweed:rules:create"),
            _("Add New Rule")))

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": self.title}
        ]

    def load_actions(self, obj):
        edit = reverse('admin:tajweed:rules:update', args=[obj.pk])
        # delete = reverse('admin:utils:single-delete', # todo: add soft delete
        #                  args=['courses', 'Course', obj.pk]) + '?next={}'.format(reverse('admin:courses:listing'))
        # translate = reverse('admin::translate', args=['courses', 'Course', obj.pk]) + '?next={}'.format(show_url)
        return mark_safe(
            '<td class="td--nowrap">' +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-primary"><i class="fa fa-edit"></i></a>'
            .format(edit, _('Edit')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-info"><i class="fa fa-globe"></i></a>'
            .format("#", _('Translate')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-danger"><i class="fa fa-trash"></i></a>'
            .format("#", _('Delete')) +
            '</td>'
        )

    def load_name(self, obj):
        details = reverse('admin:tajweed:rules:details', args=[obj.pk])
        return mark_safe('<td class="main-cell"><a href="{}">{}</a></td>'.format(details, obj.translated_name))


# todo: add test
class RuleCreateAndUpdateView(LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        if kwargs.get('rule_id', None):
            rule = get_object_or_404(Rule, pk=kwargs.get('rule_id'))
            form = RuleForm(instance=rule)
            title = _("Edit {rule}").format(rule=rule.translated_name)
        else:
            form = RuleForm()
            title = _('Add New Rule')
        return render(request, 'tajweed/rules/form.html', {
            'form': form,
            'title': title
        })

    def post(self, request, *args, **kwargs):
        if kwargs.get('rule_id', None):
            rule = get_object_or_404(Rule, pk=kwargs.get('rule_id'))
            form = RuleForm(data=request.POST, instance=rule)
            title = _("Edit {rule}").format(rule=rule.translated_name)
            message = _("Rule Updated Successfully")
        else:
            form = RuleForm(request.POST)
            title = _('Add New Rule')
            message = _("Rule Created Successfully")

        if form.is_valid():
            instance = form.save()
            messages.success(request, message)
            return redirect(reverse('admin:tajweed:books:details', args=[instance.pk]))

        return render(request, 'tajweed/rules/form.html', {
            "form": form,
            "title": title
        })


class RuleDetailsView(LoginRequiredMixin, View):
    def get(self, request, rule_id, *args, **kwargs):
        rule = get_object_or_404(Rule, pk=rule_id)
        return render(request, 'tajweed/rules/details.html', {
            'rule': rule,
            'title': _('{rule} Details').format(rule=rule.translated_name)
        })
