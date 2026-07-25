from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.http import HttpResponseRedirect
from django.shortcuts import redirect, get_object_or_404, render
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from django.views import View
from dynamic_listing.views import DynamicTableView

from apps.tajweed.filters import TajweedExampleLessonFilter
from apps.tajweed.forms.admin_form import TajweedLessonExampleForm
from apps.tajweed.models.lessons import TajweedLessonExample, TajweedLesson
from quran_api_client.models import Verse


class ExampleListingView(LoginRequiredMixin, PermissionRequiredMixin, DynamicTableView):
    model = TajweedLessonExample
    title = _("Examples")
    filterset_class = TajweedExampleLessonFilter
    permission_required = "tajweed.view_example"
    load_rows_from_template = True
    row_template_name = 'tajweed/lessons/examples/listing/_table_row.html'
    table_columns = (
        ('id', _('ID'), 'text-center'),
        ('title', _('Title'), 'text-center'),
        ('narration', _('Narration'), 'text-center'),
        ('chapter', _('Chapter'), 'text-center'),
        ('verse_text', _('Verse'), 'text-center'),
        ('record', _('Record'), 'text-center'),
        ('actions', _('Actions'), 'text-center'),
    )

    def get_queryset(self):
        queryset = super().get_queryset()
        lesson_id = self.kwargs.get('lesson')
        return queryset.filter(lesson_id=lesson_id)

    def get_context_data(self, *args, **kwargs):
        context = super().get_context_data(*args, **kwargs)
        lesson_id = self.kwargs.get('lesson')
        context['actions'] = 'tajweed/lessons/examples/details/_item_actions.html'
        context['lesson'] = TajweedLesson.objects.get(pk=lesson_id)
        return context

    def get_breadcrumb(self):
        lesson_id = self.kwargs.get('lesson')
        return [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:tajweed:lessons:listing"), "title": _("All Lessons")},
            {"url": reverse("admin:tajweed:lessons:details", kwargs={'pk': lesson_id}),
             "title": _("Lesson - ") + str(lesson_id)},
            {"title": _("Examples")}
        ]


class CreateOrUpdateExampleLessonView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ('tajweed.change_example_lesson',) if self.kwargs.get('pk', None) and self.kwargs.get('lesson',
                                                                                                     None) else (
            'tajweed.add_example_lesson',)

    def get_breadcrumb(self):
        lesson_id = self.kwargs.get('pk')
        return [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:tajweed:lessons:listing"), "title": _("Lessons"), },
            {"url": reverse("admin:tajweed:lessons:details", kwargs={'pk': lesson_id}),
             "title": _("Lesson - ") + str(lesson_id)},
            {"title": _("Edit Example") if self.kwargs.get('pk', None) and self.kwargs.get('lesson',
                                                                                                  None) else _(
                "Create Example")}
        ]

    def get(self, request, *args, **kwargs):
        if 'pk' and 'lesson' in kwargs:
            example_lesson = get_object_or_404(TajweedLessonExample, pk=kwargs['pk'])
            form = TajweedLessonExampleForm(instance=example_lesson)
            title = _("Update Example Lesson")
        else:
            form = TajweedLessonExampleForm()
            title = _("Create Example Lesson")

        return render(request, 'tajweed/lessons/examples/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })

    def post(self, request, *args, **kwargs):
        if 'pk' in kwargs and 'lesson' in kwargs:
            example_lesson = get_object_or_404(TajweedLessonExample, pk=kwargs['pk'])

            form = TajweedLessonExampleForm(request.POST, request.FILES, instance=example_lesson)
            chapter_id = request.POST.get('chapter')
            narration_id = request.POST.get('narration')
            verse_number = request.POST.get('verse_number')
            if chapter_id and narration_id:
                form.instance.verse_text = Verse.objects.filter(chapter_id=chapter_id, narration_id=narration_id,
                                                                verse_number=verse_number).values_list('text',
                                                                                                       flat=True).first()
            message = _("Example Lesson Updated Successfully")
            title = _("Update Example Lesson")
        else:
            form = TajweedLessonExampleForm(request.POST, request.FILES)
            form.instance.lesson_id = kwargs.get('pk')
            chapter_id = request.POST.get('chapter')
            narration_id = request.POST.get('narration')
            verse_number = request.POST.get('verse_number')
            if chapter_id and narration_id:
                form.instance.verse_text = Verse.objects.filter(chapter_id=chapter_id, narration_id=narration_id,
                                                                verse_number=verse_number).first()

            message = _("Example Lesson Created Successfully")
            title = _("Create Example Lesson")

        if form.is_valid():
            form.save()
            messages.success(request, message)
            return redirect(
                reverse('admin:tajweed:lessons:listing_example', kwargs={'lesson': form.instance.lesson_id}))
        else:
            for field in form.errors:
                for error in form.errors[field]:
                    messages.error(request, error)
        return render(request, 'tajweed/lessons/examples/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })


class DeleteExampleLessonView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = 'tajweed.delete_example_lesson'

    def post(self, request, pk, *args, **kwargs):
        example_lesson = get_object_or_404(TajweedLessonExample, pk=pk)
        example_lesson.delete()
        messages.success(request, _("Example Lesson Deleted Successfully"))
        return HttpResponseRedirect(request.META.get('HTTP_REFERER'))
