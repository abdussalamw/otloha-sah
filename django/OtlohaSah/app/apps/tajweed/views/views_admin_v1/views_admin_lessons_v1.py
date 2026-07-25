from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.shortcuts import redirect, get_object_or_404, render
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from django.views import View
from django.views.generic import DetailView, ListView
from dynamic_listing.views import DynamicTableView

from apps.tajweed.filters import TajweedLessonFilter, TajweedSubLessonFilter
from apps.tajweed.forms.admin_form import TajweedLessonForm
from apps.tajweed.models.lessons import TajweedLesson, TajweedVideoUrl, TajweedLessonExample
from apps.tajweed.views.views_admin_v1.listing_factories import LessonsDynamicListingFactory, \
    ExampleDynamicListingFactory


class LessonListingView(LoginRequiredMixin, PermissionRequiredMixin, DynamicTableView):
    model = TajweedLesson
    title = _("All Tajweed Lessons")
    filterset_class = TajweedLessonFilter
    permission_required = "tajweed.view_lesson"
    listing_actions = "tajweed/lessons/listing/_actions.html"
    load_rows_from_template = True
    row_template_name = 'tajweed/lessons/listing/_table_row.html'
    table_columns = (
        ('id', _('ID'), 'text-center'),
        ('title', _('Title'), 'text-start'),
        ('level_lesson', _('Level'), 'text-center'),
        ('action', _('Action'), 'text-end'),
    )

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:tajweed:lessons:listing"), "title": _("All Lessons"), }, ]


class LessonDetailView(LoginRequiredMixin, PermissionRequiredMixin, DetailView):
    model = TajweedLesson
    title = _("Sub-lessons of Lesson")
    permission_required = "tajweed.view_tajweedlesson"
    template_name = 'tajweed/lessons/index.html'

    def get_context_data(self, **kwargs):
        context = super(LessonDetailView, self).get_context_data(**kwargs)
        context["breadcrumb"] = self.get_breadcrumb()
        context["title"] = self.object
        context['actions'] = 'tajweed/lessons/details/_item_actions.html'

        lessons = LessonsDynamicListingFactory(
            request=self.request,
            queryset=TajweedLesson.objects.filter(parent=self.kwargs.get('pk')),
        )
        example = ExampleDynamicListingFactory(
            request=self.request,
            queryset=TajweedLessonExample.objects.filter(lesson_id=self.kwargs.get('pk')),
        )
        urls = TajweedVideoUrl.objects.filter(lesson_id=self.kwargs.get('pk'))
        context["urls"] = urls
        examples = TajweedLessonExample.objects.filter(lesson_id=self.kwargs.get('pk'))
        context["examples"] = examples
        context["example"] = example
        context["lessons"] = lessons
        context["lesson"] = self.kwargs.get('pk')
        return context

    def get_breadcrumb(self):
        parents = []
        current_lesson = TajweedLesson.objects.get(pk=self.kwargs.get('pk'))
        while current_lesson:
            parents.append(current_lesson.title["en"])
            current_lesson = current_lesson.parent
        breadcrumb_title = _("All Lessons") + " - " + "- ".join(parents[::-1])

        return [
            {"url": "/", "title": _("Home")},
            {"url": reverse("admin:tajweed:lessons:listing"), "title": breadcrumb_title},
        ]


class CreateOrUpdateLessonView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ('tajweed.change_lesson',) if self.kwargs.get('pk', None) else ('tajweed.add_lesson',)

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:tajweed:lessons:listing"), "title": _("All Lessons"), },
            {"title": _("Edit Lesson") if self.kwargs.get('pk', None) else _("Create Lesson")}
        ]

    def get(self, request, *args, **kwargs):
        if 'pk' in kwargs:
            Lesson = get_object_or_404(TajweedLesson, pk=kwargs['pk'])
            form = TajweedLessonForm(instance=Lesson)
            title = _("Update Lesson")
        else:
            form = TajweedLessonForm()
            title = _("Create Lesson")

        return render(request, 'tajweed/lessons/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })

    def post(self, request, *args, **kwargs):
        if 'pk' in kwargs:
            Lesson = get_object_or_404(TajweedLesson, pk=kwargs['pk'])
            form = TajweedLessonForm(request.POST, request.FILES, instance=Lesson)
            message = _("Lesson Updated Successfully")
            title = _("Update Lesson")
        else:
            form = TajweedLessonForm(request.POST, request.FILES)
            message = _("Lesson Created Successfully")
            title = _("Create Lesson")
        # lesson = TajweedLesson.objects.get(pk=kwargs['pk']) if 'pk' in kwargs else None

        if form.is_valid():
            form.save()
            messages.success(request, message)
            return redirect(reverse('admin:tajweed:lessons:listing'))
        else:
            for field in form.errors:
                for error in form.errors[field]:
                    messages.error(request, error)

        return render(request, 'tajweed/lessons/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })


class DeleteLessonView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = 'tajweed.delete_lesson'

    def post(self, request, pk, *args, **kwargs):
        lesson = get_object_or_404(TajweedLesson, pk=pk)
        lesson.delete()
        messages.success(request, _("Lesson Deleted Successfully"))
        return redirect(reverse('admin:tajweed:lessons:listing'))


class SubLessonDetailView(LoginRequiredMixin, PermissionRequiredMixin, ListView):
    model = TajweedLesson
    title = _("Sub-lessons of Lesson")
    permission_required = "tajweed.view_tajweedlesson"
    context_object_name = 'sub_lessons'
    template_name = 'tajweed/lessons/_sub_lessons.html'
    filterset_class = TajweedSubLessonFilter

    def get_queryset(self):
        queryset = super().get_queryset()
        lesson_id = self.kwargs.get('lesson')
        return queryset.filter(parent=lesson_id)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["breadcrumb"] = self.get_breadcrumb()

        lesson_id = self.kwargs.get('lesson')
        lessons = LessonsDynamicListingFactory(
            request=self.request,
            queryset=TajweedLesson.objects.filter(parent=lesson_id),
        )
        context["lessons"] = lessons

        current_lesson = self.get_current_lesson()
        context["title"] = current_lesson
        context["lesson"] = current_lesson
        return context

    def get_breadcrumb(self):
        lesson_id = self.kwargs.get('lesson')
        return [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:tajweed:lessons:listing"), "title": _("All Lessons")},
            {"url": reverse("admin:tajweed:lessons:details", kwargs={'pk': lesson_id}),
             "title": _("Lesson - ") + str(lesson_id)},
            {"title": _("Sub-Lessons")}
        ]

    def get_current_lesson(self):
        lesson_id = self.kwargs.get('lesson')
        return get_object_or_404(TajweedLesson, id=lesson_id)
