from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import get_object_or_404
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _

from apps.main.views_admin import AdminListView
from apps.translations.models import Translation, TranslationVerse


class TranslationVersesListAdminView(LoginRequiredMixin, AdminListView):
    model = TranslationVerse
    filterset_class = None
    title = _('All Translation Verses')
    list_display = (
        ('id', _('ID')),
        ('text', _('Text')),
        ('verse_number', _('Verse Number')),
        ('chapter', _('Chapter')),
        ('chapter_number', _('Chapter Number')),
    )

    def get_breadcrumb(self):
        translation_obj = get_object_or_404(Translation, pk=self.kwargs['translation_id'])
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": _("All Translations"),
             "url": reverse("admin:translations:listing")},
            {"name": translation_obj.translated_name,
             "url": reverse("admin:translations:detail", args=[self.kwargs['translation_id']])},
            {"name": self.title}
        ]

    def get_queryset(self):
        return TranslationVerse.objects.filter(translation_id=self.kwargs['translation_id'])

