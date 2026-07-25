from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import render, get_object_or_404, redirect
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.translations.filters import TranslationFilter
from apps.translations.forms import TranslationForm
from apps.translations.models import Translation


class TranslationListAdminView(LoginRequiredMixin, AdminListView):
    model = Translation
    filterset_class = TranslationFilter
    title = _('All Translations')
    list_display = (
        ('id', _('ID')),
        ('name', _('name')),
        ('language', _('language')),
        ('author', _('author')),
        ('actions', _('actions'))
    )

    def get_breadcrumb(self):
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": self.title}
        ]

    def load_name(self, obj):
        details = reverse('admin:translations:detail', args=[obj.pk])
        return mark_safe('<td class="main-cell"><a href="{}">{}</a></td>'.format(details, obj.translated_name))

    def load_language(self, obj):
        return mark_safe('<td class="main-cell">{}</td>'.format(obj.get_language_display()))

    def load_author(self, obj):
        return mark_safe('<td class="main-cell">{}</td>'.format(obj.translated_author))

    def get_actions(self):
        add_translation = reverse('admin:translations:create')
        return mark_safe('<a href="{}" class="btn btn-primary btn-block">'
                         '<i class="fas fa-plus"></i>{}</a>'.format(add_translation,
                                                                    _("Add New Translation")))

    def load_actions(self, obj):
        edit = reverse('admin:translations:detail', args=[obj.pk])
        # delete = reverse('admin:utils:single-delete', # todo: add soft delete
        #                  args=['courses', 'Course', obj.pk]) + '?next={}'.format(reverse('admin:courses:listing'))
        # translate = reverse('admin::translate', args=['courses', 'Course', obj.pk]) + '?next={}'.format(show_url)
        return mark_safe(
            '<td class="td--nowrap">' +
            '<a href="{}" title="{}" class="mx-1"><i class="fas fa-pen"></i></a>'.format(edit,
                                                                                         _('edit')) +
            '<a href="{}" title="{}" class="mx-1"><i class="fas fa-globe"></i></a>'.format("#",
                                                                                           _('translate')) +
            '<a href="{}" title="{}" class="mx-1"><i class="fas fa-trash"></i></a>'.format("#",
                                                                                           _('delete')) +
            '</td>'
        )


class TranslationDetailAdminView(LoginRequiredMixin, View):
    def get(self, request, translation_id, *args, **kwargs):
        translation = get_object_or_404(Translation, pk=translation_id)
        return render(request, 'translations/details.html', {
            'translation': translation,
            'title': "{} {}".format(translation.translated_name, _('Translation Details'))
        })


class TranslationCreateAndUpdateView(LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        if kwargs.get('translation_id', None):
            translation = get_object_or_404(Translation, pk=kwargs.get('translation_id'))
            form = TranslationForm(instance=translation)
            title = "{} {}".format(_("Edit"), translation.translated_name)
        else:
            form = TranslationForm()
            title = _('Add New Translation')
        return render(request, 'translations/form.html', {
            'form': form,
            'title': title
        })

    def post(self, request, *args, **kwargs):
        if kwargs.get('translation_id', None):
            translation = get_object_or_404(Translation, pk=kwargs.get('translation_id'))
            form = TranslationForm(instance=translation, data=request.POST)
            title = "{} {}".format(_("Edit"), translation.translated_name)
            message = _("Translation Updated Successfully")
        else:
            form = TranslationForm(request.POST)
            title = _('Add New Translation')
            message = _("Translation Created Successfully")

        if form.is_valid():
            instance = form.save()
            messages.success(request, message)
            return redirect(reverse('admin:translations:detail', args=[instance.pk]))

        return render(request, 'translations/form.html', {
            "form": form,
            "title": title
        })

