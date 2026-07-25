from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _

from apps.main.views_admin import AdminListView
from apps.quran.models import BookChapter, Book


class BookChaptersListAdminView(LoginRequiredMixin, PermissionRequiredMixin, AdminListView):
    book: Book = None
    title = _("Chapters")
    model = BookChapter
    permission_required = ('quran.view_bookchapter', 'quran.view_book')
    list_display = (
        ('id', _('ID')),
        ('chapter', _('Chapter')),
        ('text_image', _('Text Image')),
        ('header_image', _('Header Image')),
    )

    def get_queryset(self):
        self.book = Book.objects.get(pk=self.kwargs.get('book_id'))
        queryset = super().get_queryset().filter(book=self.book)
        if self.filterset_class:
            queryset = self.filterset_class(self.request.GET, queryset).qs
        return queryset

    def load_text_image(self, obj):
        return mark_safe('<td><img src="{}" alt={}/></td>'.format(obj.text_image.url, obj.chapter.translated_name))

    def load_header_image(self, obj):
        return mark_safe('<td><img src="{}" alt={}/></td>'.format(obj.header_image.url, obj.chapter.translated_name))

    def load_chapter(self, obj):
        return mark_safe('<td>{}</td>'.format(obj.chapter.translated_name))

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": _("Books"), "url": reverse("admin:books:listing")},
            {"name": self.book.translated_name, "url": reverse("admin:books:details", args=[self.book.id])},
            {"name": self.title}
        ]
