from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import get_object_or_404
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _

from apps.explanations.models import ExplanationVerse, Explanation
from apps.main.views_admin import AdminListView


class ExplanationVerseListingView(LoginRequiredMixin, AdminListView):
    model = ExplanationVerse
    filterset_class = None
    title = _('All Explanation Verses')
    list_display = (
        ('id', _('ID')),
        ('verse_number', _('Verse Number')),
        ('chapter_number', _('Chapter Number')),
        ('page_number', _('Page Number')),
        ('text', _('Tafseer')),
    )

    def get_breadcrumb(self):
        explanation_obj = get_object_or_404(Explanation, pk=self.kwargs['explanation_id'])
        return [
            {"name": _("Home"), "url": reverse('admin:main:home')},
            {"name": _("All Explanation"),
             "url": reverse("admin:explanations:listing")},
            {"name": explanation_obj.translated_name,
             "url": reverse("admin:explanations:details", args=[self.kwargs['explanation_id']])},
            {"name": self.title}
        ]

    def get_queryset(self):
        return ExplanationVerse.objects.filter(explanation_id=self.kwargs['explanation_id'])

    def get_actions(self):
        url = reverse('admin:files:csv:create',
                      args=['explanations', 'explanation', self.kwargs['explanation_id']]) + '?next=' + reverse(
            'admin:explanations:verses:listing', args=[self.kwargs['explanation_id']])
        return mark_safe('<a href="{}" class="btn btn-primary btn-block">'
                         '<i class="fas fa-plus"></i>{}</a>'.format(url,
                                                                    _("Upload New Explanation")))
