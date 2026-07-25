from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.shortcuts import redirect, get_object_or_404, render
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from django.views import View
from dynamic_listing.views import DynamicTableView

from apps.tajweed.filters import TajweedLevelFilter
from apps.tajweed.forms.admin_form import UserLevelPassedForm
from apps.tajweed.models.levels import UserLevelPassed


class UserLevelPassedListingView(LoginRequiredMixin, PermissionRequiredMixin, DynamicTableView):
    model = UserLevelPassed
    title = _("All Tajweed User Level Passed")
    filterset_class = TajweedLevelFilter
    permission_required = "tajweed.view_user_level_passed"
    listing_actions = "tajweed/user-level-passed/listing/_actions.html"
    load_rows_from_template = True
    row_template_name = 'tajweed/user-level-passed/listing/_table_row.html'
    table_columns = (
        ('id', _('ID'), 'text-center'),
        ('user', _('User'), 'text-center'),
        ('level', _('Level'), 'text-center'),
        ('rate', _('Rate'), 'text-center'),
        ('exam_record', _('Exam Record'), 'text-center'),
        ('actions', _('Actions'), 'text-center'),
    )
    ordering = ('id',)

    def get_context_data(self, *args, **kwargs):
        context = super().get_context_data(*args, **kwargs)
        levels = UserLevelPassed.objects.all()

        context['all_user_level_passed_count'] = levels.count()
        return context

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:tajweed:user-level-passed:listing"), "title": _("All User Level Passed"), },
        ]


class CreateOrUpdateUserLevelPassedView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ('tajweed.change_user_level_passed',) if self.kwargs.get('pk', None) else (
            'tajweed.add_user_level_passed',)

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:tajweed:user-level-passed:listing"), "title": _("All Users Levels Passed"), },
            {"title": _("Edit User Level Passed") if self.kwargs.get('pk', None) else _("Create User Level Passed")}
        ]

    def get(self, request, *args, **kwargs):
        if 'pk' in kwargs:
            user_level_passed = get_object_or_404(UserLevelPassed, pk=kwargs['pk'])
            form = UserLevelPassedForm(instance=user_level_passed)
            title = _("Update User Level Passed")
        else:
            form = UserLevelPassedForm()
            title = _("Create User Level Passed")

        return render(request, 'tajweed/user-level-passed/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })

    def post(self, request, *args, **kwargs):
        if 'pk' in kwargs:
            user_level_passed = get_object_or_404(UserLevelPassed, pk=kwargs['pk'])
            form = UserLevelPassedForm(request.POST, request.FILES, instance=user_level_passed)
            message = _("User Level Passed Updated Successfully")
            title = _("Update User Level Passed")
        else:
            form = UserLevelPassedForm(request.POST, request.FILES)
            message = _("User Level Passed Created Successfully")
            title = _("Create User Level Passed")

        if form.is_valid():
            form.save()
            messages.success(request, message)
            return redirect(reverse('admin:tajweed:user-level-passed:listing'))

        return render(request, 'tajweed/user-level-passed/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })


class DeleteUserLevelPassedView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = 'tajweed.delete_lesson'

    def post(self, request, pk, *args, **kwargs):
        user_level_paased = get_object_or_404(UserLevelPassed, pk=pk)
        user_level_paased.delete()
        messages.success(request, _("User Level Passed Deleted Successfully"))
        return redirect(reverse('admin:tajweed:user-level-passed:listing'))

