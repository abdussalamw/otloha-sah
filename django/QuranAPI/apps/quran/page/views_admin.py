from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.shortcuts import render, get_object_or_404
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.quran.page.filters import PageAPIFilter
from apps.quran.models import Page, Book


class PageListAdminView(LoginRequiredMixin, AdminListView):
    model = Page
    filterset_class = PageAPIFilter
    list_display = (
        ('id', _('id')),
        ('page_number', _('Page Number')),
        ('sub_part', _('Sub Part')),
        ('narrations', _('Narration')),
        ('book', _('Book')),
        ('chapters', _('Chapters')),
        ('part', _('Part')),
    )
    book: Book = None

    def get_queryset(self):
        self.book = Book.objects.get(pk=self.kwargs.get('book_id'))
        queryset = super().get_queryset().filter(book=self.book)
        if self.filterset_class:
            queryset = self.filterset_class(self.request.GET, queryset).qs
        return queryset

    def load_page_number(self, obj):
        details = reverse('admin:books:pages:details', args=[obj.book.pk, obj.pk])
        return mark_safe('<td class="main-cell"><a href="{}">{}</a></td>'.format(details, obj.page_number))

    def load_sub_part(self, obj):
        return mark_safe('<td>{}</td>'.format(obj.sub_part if obj.sub_part else _("Not Set")))

    def load_chapters(self, obj):
        chapters = obj.chapters.all()
        cell = "<td>"
        for chapter in chapters:
            cell += '{}'.format(
                chapter.chapter.translated_name)
        cell += "</td>"
        return mark_safe(cell)

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": _("Books"), "url": reverse("admin:books:listing")},
            {"name": self.book.translated_name, "url": reverse("admin:books:details", args=[self.book.id])},
            {"name": self.title}
        ]


class PageDetailsView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = ("quran.view_book", "quran.view_page",)

    def get(self, request, book_id, page_id, *args, **kwargs):
        book = get_object_or_404(Book, pk=book_id)
        page = get_object_or_404(Page, pk=page_id)
        return render(request, 'quran/book/pages/details.html', {
            'book': book,
            'page': page,
            'title': "{} {}".format(_("Details Of Page"), page.page_number)
        })
