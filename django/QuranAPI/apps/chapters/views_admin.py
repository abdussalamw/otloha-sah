from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.chapters.filters import ChapterFilter
from apps.chapters.forms import ChapterForm
from apps.chapters.models import Chapter
from apps.main.views_admin import AdminListView


class ChapterListingAdminView(LoginRequiredMixin, PermissionRequiredMixin, AdminListView):
    model = Chapter
    title = _('All Chapters')
    filterset_class = ChapterFilter
    permission_required = ("chapters.view_chapter",)

    list_display = (
        ('id', _('ID')),
        ('name', _('Name')),
        ('chapter_number', _('Chapter Number')),
        ('origin', _('Origin')),
        ('actions', _('Actions'))
    )

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": self.title}
        ]

    def load_name(self, obj):
        return mark_safe('<td>{}</td>'.format(obj.translated_name))

    def load_origin(self, obj):
        origin = dict(Chapter.ORIGINS).get(obj.origin)
        return mark_safe('<td>{}</td>'.format(origin))

    def load_actions(self, obj):
        return mark_safe(
            '<td class="td--nowrap">' +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-primary"><i class="fa fa-edit"></i></a>'
            .format(obj.get_edit_url, _('Edit')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-info"><i class="fas fa-globe"></i></a>'
            .format(obj.get_translate_url,
                    _('Translate')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-danger"><i class="fas fa-trash"></i></a>'
            .format(obj.get_delete_url, _('Delete')) +
            '</td>')

    def get_actions(self):
        return mark_safe(
            '<a href="{}" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i>{}</a>'.format(
                reverse("admin:chapters:create"), _("Add New Chapter")))


class ChapterDetailsAdminView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = 'chapters.view_chapter'

    def get(self, request, chapter_id, *args, **kwargs):
        chapter = get_object_or_404(Chapter, pk=chapter_id)
        return render(request, 'chapter/detail.html', {'chapter': chapter, 'title': chapter})


class ChapterCreateAndUpdateAdminView(LoginRequiredMixin, PermissionRequiredMixin, View):

    def get_permission_required(self):
        return ("chapters.change_chapter",) if self.kwargs.get('chapter_id', None) else ("chapters.add_chapter",)

    def get(self, request, *args, **kwargs):
        if kwargs.get('chapter_id', None):
            chapter = get_object_or_404(Chapter, pk=kwargs.get('chapter_id'))
            form = ChapterForm(instance=chapter)
            title = _("Update chapter {chapter}").format(chapter=chapter.translated_name)

        else:
            form = ChapterForm()
            title = _("Add New Chapter")

        return render(request, 'chapter/form.html', {
            'form': form,
            'title': title
        })

    def post(self, request, *args, **kwargs):
        if kwargs.get('chapter_id', None):
            chapter = get_object_or_404(Chapter, pk=kwargs.get('chapter_id'))
            form = ChapterForm(data=request.POST, instance=chapter)
            title = _("Update chapter {chapter}").format(chapter=chapter.translated_name)
            message = _("Chapter Updated Successfully")
        else:
            form = ChapterForm(request.POST)
            title = _("Add New Chapter")
            message = _("Chapter Created Successfully")

        if form.is_valid():
            instance = form.save()
            messages.success(request, message)
            return redirect(reverse('admin:chapters:listing') + "?id={}".format(instance.pk))

        return render(request, 'chapter/form.html', {
            "form": form,
            'title': title
        })
