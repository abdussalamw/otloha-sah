from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.humanize.templatetags import humanize
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.quran.filters import BookFilter
from apps.quran.forms import BookForm
from apps.quran.models import Book


class BookListView(LoginRequiredMixin, AdminListView):
    model = Book
    filterset_class = BookFilter
    title = _('All Books')
    list_display = (
        ('id', _('id')),
        ('name', _('name')),
        ('narration', _('narrations')),
        ('created_at', _('Created at')),
        ('actions', _('actions'))
    )

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": _("Books"), "url": reverse("admin:books:listing")},
            {"name": self.title}
        ]

    def load_name(self, obj):
        details = reverse('admin:books:details', args=[obj.pk])
        return mark_safe('<td class="main-cell"><a href="{}">{}</a></td>'.format(details, obj.translated_name))

    def load_created_at(self, obj):
        return mark_safe('<td class="main-cell">{}</td>'.format(humanize.naturaltime(obj.created_at)))

    def get_actions(self):
        return mark_safe('<a href="{}" class="btn btn-primary btn-block btn-sm">'
                         '<i class="fas fa-plus"></i>{}</a>'.format(
            reverse("admin:books:create"),
            _("Add New Book")))

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


class BookDetailsView(LoginRequiredMixin, View):
    def get(self, request, book_id, *args, **kwargs):
        book = get_object_or_404(Book, pk=book_id)
        return render(request, 'quran/book/details.html', {
            # 'BookUploads': BookCSVUpload.objects.filter(book=book),
            'book': book,
            'title': "{} {}".format(book.translated_name, _('Book Details'))
        })


class BookCreateAndUpdateView(LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        if kwargs.get('book_id', None):
            book = get_object_or_404(Book, pk=kwargs.get('book_id'))
            form = BookForm(instance=book)
            title = "{} {}".format(_("Edit"), book.translated_name)
        else:
            form = BookForm()
            title = _('Add New Book')
        return render(request, 'quran/book/form.html', {
            'form': form,
            'title': title
        })

    def post(self, request, *args, **kwargs):
        if kwargs.get('book_id', None):
            book = get_object_or_404(Book, pk=kwargs.get('book_id'))
            form = BookForm(data=request.POST, instance=book)
            title = "{} {}".format(_("Edit"), book.translated_name)
            message = _("Book Updated Successfully")
        else:
            form = BookForm(request.POST)
            title = _('Add New Book')
            message = _("Book Created Successfully")

        if form.is_valid():
            instance = form.save()
            messages.success(request, message)
            return redirect(reverse('admin:books:details', args=[instance.pk]))

        return render(request, 'quran/book/form.html', {
            "form": form,
            "title": title
        })
