from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import get_object_or_404, render
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.narrations.models import Verse, Narration
from apps.narrations.verses.filters import VerseFilter


class VerseListAdminView(LoginRequiredMixin, AdminListView):
    model = Verse
    filterset_class = VerseFilter
    title = _("All Verses")
    list_display = (
        ('id', _('ID')),
        ('image', _('Image')),
        ('text', _('Text')),
        ('verse_number', _('Verse Number')),
        ('chapter', _('Chapter')),
        ('part', _('Part')),
        ('line_start', _('Line Start')),
        ('line_end', _('Line End')),
    )
    narration: Narration = None

    def get_queryset(self):
        self.narration = Narration.objects.get(pk=self.kwargs['narration_id'])
        queryset = super().get_queryset()
        queryset = queryset.filter(narration=self.narration).order_by('chapter__pk', "verse_number")
        if self.filterset_class:
            queryset = self.filterset_class(self.request.GET, queryset).qs
        return queryset

    def load_image(self, obj):
        if obj.image:
            return mark_safe('<td><img class="image preview" src="{}" alt="{}"></td>'.format(obj.image.url, obj.image))
        return mark_safe("<td></td>")

    def load_text(self, obj):
        return mark_safe('<td class="main-cell uthmainc-font"><a href="{}">{}</td>'.format(
            reverse('admin:narrations:verses:details', args=[obj.narration_id, obj.pk]), obj.text))

    def load_verse_number(self, obj):
        return mark_safe('<td>{}</td>'.format(obj.verse_number))

    def load_page(self, obj):
        details = reverse('admin:narrations:pages:details', args=[obj.narration_id, obj.page.id])
        return mark_safe('<td><a href="{}">{}</a></td>'.format(details, obj.page_number))

    def load_chapter(self, obj):
        return mark_safe('<td class="uthmainc-font">{}</td>'.format(obj.chapter.translated_name))

    def load_part(self, obj):
        return mark_safe('<td class="uthmainc-font">{}</td>'.format(obj.part.translated_name))

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": _("Narrations"), "url": reverse("admin:narrations:listing")},
            {"name": self.narration.translated_name,
             "url": reverse("admin:narrations:details", args=[self.narration.id])},
            {"name": self.title}
        ]


class VerseDetailsView(LoginRequiredMixin, View):
    def get(self, request, narration_id, verse_id, *args, **kwargs):
        narration = get_object_or_404(Narration, pk=narration_id)
        verse = get_object_or_404(Verse, pk=verse_id)
        return render(request, 'verses/details.html', {
            'verse': verse,
            'narration': narration,
            'title': _('verse {verse} of {chapter} Details').format(verse=verse.verse_number,
                                                                    chapter=verse.chapter_number)
        })
