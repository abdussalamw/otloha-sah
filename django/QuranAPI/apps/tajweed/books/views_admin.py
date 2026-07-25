from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.tajweed.books.filters import BookFilter
from apps.tajweed.forms import BookForm
from apps.tajweed.models import Book


class BookListingView(LoginRequiredMixin, AdminListView):
    model = Book
    filterset_class = BookFilter
    title = _('All Tajweed Books')
    list_display = (
        ('id', _('ID')),
        ('name', _('Name')),
        ('narration', _('Narration')),
        ('author', _('Author')),
        ('actions', _('Actions'))
    )

    def get_actions(self):
        url = reverse('admin:tajweed:books:create')
        return mark_safe('<a href="{}" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i>{}</a>'
                         .format(url, _("Add New Tajweed Book")))

    def load_author(self, obj):
        return mark_safe('<td>{}</td>'.format(obj.translated_author))

    def load_actions(self, obj):
        return mark_safe(
            '<td class="td--nowrap">' +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-primary"><i class="fa fa-edit"></i></a>'
            .format(obj.get_edit_url, _('Edit')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-info"><i class="fa fa-globe"></i></a>'
            .format(obj.get_translate_url, _('Translate')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-danger"><i class="fa fa-trash"></i></a>'
            .format(obj.get_delete_url, _('Delete')) +
            '</td>'
        )

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": self.title}
        ]

    def load_name(self, obj):
        details = reverse('admin:tajweed:books:details', args=[obj.pk])
        return mark_safe('<td class="main-cell"><a href="{}">{}</a></td>'.format(details, obj.translated_name))


class BookCreateAndUpdateView(LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        if kwargs.get('book_id', None):
            book = get_object_or_404(Book, pk=kwargs.get('book_id'))
            form = BookForm(instance=book)
            title = _("Edit {book}").format(book=book.translated_name)
        else:
            form = BookForm()
            title = _("Add New Tajweed Book")
        return render(request, 'tajweed/book/form.html', {
            'form': form,
            'title': title
        })

    def post(self, request, *args, **kwargs):
        if kwargs.get('book_id', None):
            book = get_object_or_404(Book, pk=kwargs.get('book_id'))
            form = BookForm(data=request.POST, instance=book)
            title = _("Edit {book}").format(book=book.translated_name)
            message = _("Book Updated Successfully")
        else:
            form = BookForm(request.POST)
            title = _('Add New Tajweed Book')
            message = _("Book Created Successfully")

        if form.is_valid():
            instance = form.save()
            messages.success(request, message)
            return redirect(reverse('admin:tajweed:books:details', args=[instance.pk]))

        return render(request, 'tajweed/book/form.html', {
            "form": form,
            "title": title
        })


class BookDetailsView(LoginRequiredMixin, View):
    def get(self, request, book_id, *args, **kwargs):
        book = get_object_or_404(Book, pk=book_id)
        return render(request, 'tajweed/book/details.html', {
            'book': book,
            'title': _('{book} Book Details').format(book=book.translated_name)
        })
