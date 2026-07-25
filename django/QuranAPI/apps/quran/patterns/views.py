from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.quran.models import BookPattern, Book
from apps.quran.patterns.forms import BookPatternForm


class BookPatternsListAdminView(LoginRequiredMixin, PermissionRequiredMixin, AdminListView):
    book: Book = None
    title = _("All Patterns")
    model = BookPattern
    permission_required = ('quran.view_bookpattern', 'quran.view_book')
    list_display = (
        ('id', _('ID')),
        ('file', _('Pattern')),
        ('type', _('Type')),
        ('actions', _('Actions')),
    )

    def get_queryset(self):
        self.book = Book.objects.get(pk=self.kwargs.get('book_id'))
        queryset = super().get_queryset().filter(book=self.book)
        if self.filterset_class:
            queryset = self.filterset_class(self.request.GET, queryset).qs
        return queryset

    def load_file(self, obj):
        return mark_safe('<td><img style="width: 100px" src="{}" alt={}/></td>'.format(obj.file.url, obj.book.translated_name))

    def load_actions(self, obj):
        return mark_safe(
            '<td class="td--nowrap">' +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-primary"><i class="fa fa-edit"></i></a>'
            .format(obj.get_edit_url, _('Edit')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-danger"><i class="fa fa-trash"></i></a>'
            .format(obj.get_delete_url, _('Delete')) +
            '</td>')

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": _("Books"), "url": reverse("admin:books:listing")},
            {"name": self.book.translated_name, "url": reverse("admin:books:details", args=[self.book.id])},
            {"name": self.title}
        ]

    def get_actions(self):
        return mark_safe(
            '<a href="{}" class="btn btn-primary btn-block btn-sm">'
            '<i class="fas fa-plus"></i>{}</a>'.format(
                reverse("admin:books:patterns:create", args=[self.book.pk]), _("Add New Book Pattern")))


class BookPatternCreateOrUpdateView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ('quran.change_book', 'quran.change_bookpattern') \
            if self.kwargs.get('pattern_id') else ('quran.change_book', 'quran.add_bookpattern')

    def get(self, request, book_id, *args, **kwargs):
        book = get_object_or_404(Book, pk=book_id)
        if kwargs.get('pattern_id', None):
            instance = get_object_or_404(BookPattern, pk=kwargs.get('pattern_id'))
            title = _('Update Book Pattern')
            form = BookPatternForm(instance=instance, book=book)
        else:
            title = _('Create Book Pattern')
            form = BookPatternForm(book=book)

        return render(request, 'quran/book/patterns/form.html', {
            'form': form,
            'book': book,
            'title': title

        })

    def post(self, request, book_id, *args, **kwargs):
        book = get_object_or_404(Book, pk=book_id)
        if kwargs.get('pattern_id', None):
            instance = get_object_or_404(BookPattern, pk=kwargs.get('pattern_id'))
            title = _('Update Book Pattern')
            form = BookPatternForm(request.POST, request.FILES, instance=instance, book=book)
            message = _('Book Pattern Updated Successfully')
        else:
            title = _('Create Book Pattern')
            form = BookPatternForm(request.POST, request.FILES, book=book)
            message = _('Book Pattern Created Successfully')

        if form.is_valid():
            instance = form.save()
            messages.success(request, message)
            return redirect(
                reverse('admin:books:patterns:listing', args=[book_id]))

        return render(request, 'quran/book/patterns/form.html', {
            'form': form,
            'book': get_object_or_404(Book, pk=kwargs['book_id']),
            'title': title,
        })
