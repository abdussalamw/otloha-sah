from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.shortcuts import redirect, get_object_or_404, render
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from django.views import View
from django.views.generic import DetailView
from dynamic_listing.views import DynamicTableView

from apps.tajweed.filters import TajweedLevelFilter
from apps.tajweed.forms.admin_form import TajweedLevelForm
from apps.tajweed.models import TajweedLesson
from apps.tajweed.models.levels import TajweedLevel
from apps.tajweed.views.views_admin_v1.listing_factories import LessonsDynamicListingFactory


class LevelListingView(LoginRequiredMixin, PermissionRequiredMixin, DynamicTableView):
    model = TajweedLevel
    title = _("All Tajweed Levels")
    filterset_class = TajweedLevelFilter
    permission_required = "tajweed.view_level"
    listing_actions = "tajweed/levels/listing/_actions.html"
    load_rows_from_template = True
    row_template_name = 'tajweed/levels/listing/_table_row.html'
    table_columns = (
        ('id', _('ID'), 'text-center'),
        ('name', _('Name'), 'text-center'),
        ('color', _('Level Color'), 'text-center'),
        ('actions', _('Actions'), 'text-center'),
    )
    ordering = ('value',)

    class Media:
        js = ('tajweed/levels/form_modal.js')

    def get_context_data(self, *args, **kwargs):
        context = super().get_context_data(*args, **kwargs)
        levels = TajweedLevel.objects.all()

        context['all_levels_count'] = levels.count()
        return context

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:tajweed:levels:listing"), "title": _("All Levels"), },
        ]


class CreateOrUpdateLevelView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ('tajweed.change_level',) if self.kwargs.get('pk', None) else ('tajweed.add_level',)

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:tajweed:levels:listing"), "title": _("All Levels"), },
            {"title": _("Edit Level") if self.kwargs.get('pk', None) else _("Create Level")}
        ]

    def get(self, request, *args, **kwargs):
        if 'pk' in kwargs:
            level = get_object_or_404(TajweedLevel, pk=kwargs['pk'])
            form = TajweedLevelForm(instance=level)
            title = _("Update Level")
        else:
            form = TajweedLevelForm()
            title = _("Create Level")

        return render(request, 'tajweed/levels/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })

    def post(self, request, *args, **kwargs):
        if 'pk' in kwargs:
            level = get_object_or_404(TajweedLevel, pk=kwargs['pk'])
            form = TajweedLevelForm(request.POST, request.FILES, instance=level)
            success_message = _("Level Updated Successfully")
        else:
            form = TajweedLevelForm(request.POST, request.FILES)
            success_message = _("Level Created Successfully")

        if form.is_valid():
            form.save()
            messages.success(request, success_message)
            return redirect(reverse('admin:tajweed:levels:listing'))
        else:
            for field in form.errors:
                for error in form.errors[field]:
                    messages.error(request, error)
            title = _("Update Level") if 'pk' in kwargs else _("Create Level")

        return render(request, 'tajweed/levels/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })


class DeleteLevelView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = 'tajweed.delete_level'

    def post(self, request, pk, *args, **kwargs):
        level = get_object_or_404(TajweedLevel, pk=pk)
        level.delete()
        messages.success(request, _("Level Deleted Successfully"))
        return redirect(reverse('admin:tajweed:levels:listing'))


class LevelDetailView(LoginRequiredMixin, PermissionRequiredMixin, DetailView):
    model = TajweedLevel
    filterset_class = TajweedLevelFilter
    title = _("Sub-lessons of Lesson")
    permission_required = "tajweed.view_tajweedlesson"
    template_name = 'tajweed/levels/index.html'

    def get_context_data(self, **kwargs):
        context = super(LevelDetailView, self).get_context_data(**kwargs)
        context["breadcrumb"] = self.get_breadcrumb()
        context["title"] = self.object
        context['actions'] = 'tajweed/levels/details/_item_actions.html'

        lessons = LessonsDynamicListingFactory(
            request=self.request,
            queryset=TajweedLesson.objects.filter(lesson_level=self.kwargs.get('pk')),
        )
        context["lessons"] = lessons
        context["level"] = self.kwargs.get('pk')
        return context

    def get_breadcrumb(self):
        current_level = TajweedLevel.objects.get(pk=self.kwargs.get('pk'))

        return [
            {"url": "/", "title": _("Home")},
            {"url": reverse("admin:tajweed:levels:listing"), "title": _("All Levels")},
            {"title": str(current_level)}
        ]
