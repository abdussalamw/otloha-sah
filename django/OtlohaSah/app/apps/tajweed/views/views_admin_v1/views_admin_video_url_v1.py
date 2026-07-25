from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.http import HttpResponseRedirect
from django.shortcuts import redirect, get_object_or_404, render
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from django.views import View
from dynamic_listing.views import DynamicTableView

from apps.tajweed.filters import TajweedVideoLessonFilter
from apps.tajweed.forms.admin_form import TajweedVideoUrlForm
from apps.tajweed.models.lessons import TajweedVideoUrl, TajweedLesson


class CreateOrUpdateVideoUrlView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ('tajweed.change_video',) if self.kwargs.get('pk', None) and self.kwargs.get('lesson', None) else (
            'tajweed.add_video',)

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:tajweed:lessons:listing"), "title": _("Lessons"), },
            {"title": _("Edit Video") if self.kwargs.get('pk', None) and self.kwargs.get('lesson', None) else _(
                "Create Video")}
        ]

    def get(self, request, *args, **kwargs):
        if 'pk' and 'lesson' in kwargs:
            video = get_object_or_404(TajweedVideoUrl, pk=kwargs['pk'])
            form = TajweedVideoUrlForm(instance=video)
            title = _("Update Video Url")
        else:
            form = TajweedVideoUrlForm()
            title = _("Create Video Url")

        return render(request, 'tajweed/lessons/Videos/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })

    def post(self, request, *args, **kwargs):
        if 'pk' in kwargs and 'lesson' in kwargs:
            video = get_object_or_404(TajweedVideoUrl, pk=kwargs['pk'])
            form = TajweedVideoUrlForm(request.POST, request.FILES, instance=video)
            message = _("Video Url Updated Successfully")
            title = _("Update Video Url")
        else:
            form = TajweedVideoUrlForm(request.POST, request.FILES)
            form.instance.lesson_id = kwargs.get('pk')
            message = _("Video Url Created Successfully")
            title = _("Video Url Lesson")

        if form.is_valid():
            form.save()
            messages.success(request, message)
            return redirect(reverse('admin:tajweed:lessons:listing_videos', kwargs={'lesson': form.instance.lesson_id}))

        return render(request, 'tajweed/lessons/Videos/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })


class DeleteVideoUrlView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = 'tajweed.delete_video_url'

    def post(self, request, pk, *args, **kwargs):
        video_url = get_object_or_404(TajweedVideoUrl, pk=pk)
        video_url.delete()
        messages.success(request, _("Video Url Deleted Successfully"))
        return HttpResponseRedirect(request.META.get('HTTP_REFERER'))


class VideoListingView(LoginRequiredMixin, PermissionRequiredMixin, DynamicTableView):
    model = TajweedVideoUrl
    title = _("Videos")
    filterset_class = TajweedVideoLessonFilter
    permission_required = "tajweed.view_video"
    load_rows_from_template = True
    row_template_name = 'tajweed/lessons/Videos/listing/_table_row.html'
    table_columns = (
        ('id', _('ID'), 'text-center'),
        ('url', _('Url'), 'text-center'),
        ('lesson', _('Lesson'), 'text-center'),
        ('actions', _('Actions'), 'text-center'),
    )

    def get_queryset(self):
        queryset = super().get_queryset()
        lesson_id = self.kwargs.get('lesson')
        return queryset.filter(lesson_id=lesson_id)

    def get_context_data(self, *args, **kwargs):
        lesson_id = self.kwargs.get('lesson')
        context = super().get_context_data(*args, **kwargs)
        context['lesson'] = TajweedLesson.objects.get(pk=lesson_id)
        context['actions'] = 'tajweed/lessons/Videos/details/_item_actions.html'
        return context

    def get_breadcrumb(self):
        lesson_id = self.kwargs.get('lesson')
        return [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:tajweed:lessons:listing"), "title": _("All Lessons")},
            {"url": reverse("admin:tajweed:lessons:details", kwargs={'pk': lesson_id}),
             "title": _("Lesson - ") + str(lesson_id)},
            {"title": _("Videos")}
        ]
