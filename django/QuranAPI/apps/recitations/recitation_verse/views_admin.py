from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import get_object_or_404
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _

from apps.main.views_admin import AdminListView
from apps.recitations.models import RecitationVerse, Recitation
from apps.recitations.recitation_verse.filters import RecitationVerseFilter


class RecitationVerseListAdminView(LoginRequiredMixin, AdminListView):
    model = RecitationVerse
    filterset_class = RecitationVerseFilter
    title = _('All Recitation Verses')
    recitation = None
    list_display = (
        ('id', _('ID')),
        ('recitation', _('recitation')),
        ('chapter', _('chapter')),
        ('verse_number', _('verse_number')),
        ('play', _('Play'))
    )

    def load_play(self, obj):
        return mark_safe('<td><audio controls><source src="{}" type="audio/mp3"></audio></td>'.format(obj.record.url))

    def get_queryset(self):
        self.recitation = get_object_or_404(Recitation, pk=self.kwargs['recitation_id'])
        queryset = super().get_queryset().filter(recitation=self.recitation)
        if self.filterset_class:
            queryset = self.filterset_class(self.request.GET, queryset).qs
        return queryset
