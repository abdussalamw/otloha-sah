from django.contrib.auth.mixins import LoginRequiredMixin
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _

from apps.main.views_admin import AdminListView
from apps.quran.models import  Book

#
# class VerseListAdminView(LoginRequiredMixin, AdminListView):
#     model = Verse
#     filterset_class = VerseFilter
#     title = _("All Verses")
#     list_display = (
#         ('id', _('id')),
#         ('image', _('image')),
#         ('text', _('text')),
#         ('verse_number', _('Verse Number')),
#         ('page', _('Page')),
#         ('chapter', _('Chapter')),
#         ('part', _('Part')),
#         ('line_start', _('line_start')),
#         ('line_end', _('line_end')),
#     )
#     book: Book = None
#
#     def get_queryset(self):
#         self.book = Book.objects.get(pk=self.kwargs['book_id'])
#         queryset = super().get_queryset()
#         queryset = queryset.filter(book=self.book).order_by('chapter__pk', "verse_number")
#         if self.filterset_class:
#             queryset = self.filterset_class(self.request.GET, queryset).qs
#         return queryset
#
#     def load_image(self, obj):
#         if obj.image:
#             return mark_safe('<td><img class="image preview" src="{}" alt="{}"></td>'.format(obj.image.url, obj.image))
#         return mark_safe("<td></td>")
#
#     def load_text(self, obj):
#         return mark_safe('<td class="main-cell">{}</td>'.format(obj.text))
#
#     def load_verse_number(self, obj):
#         return mark_safe('<td>{}</td>'.format(obj.verse_number))
#
#     def load_page(self, obj):
#         details = reverse('admin:books:pages:details', args=[obj.book_id, obj.page.id])
#         return mark_safe('<td><a href="{}">{}</a></td>'.format(details, obj.page_number))
#
#     def load_chapter(self, obj):
#         return mark_safe('<td>{}</td>'.format(obj.chapter.translated_name))
#
#     def get_breadcrumb(self):
#         return [
#             {"name": _("Home"), "url": reverse('admin:main:home')},
#             {"name": _("Books"), "url": reverse("admin:books:listing")},
#             {"name": self.book.translated_name, "url": reverse("admin:books:details", args=[self.book.id])},
#             {"name": self.title}
#         ]
