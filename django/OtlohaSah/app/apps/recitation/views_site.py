from django.contrib.auth.mixins import LoginRequiredMixin
from django.utils.translation import gettext as _

from apps.main.views.views_site import SiteDynamicListView
from apps.recitation.filters import RecitationFilter
from apps.recitation.models import Recitation


class RecitationListingView(LoginRequiredMixin, SiteDynamicListView):
    model = Recitation
    filterset_class = RecitationFilter
    item_template_name = 'recitations/site/listing/_list_item.html'

    def get_title(self):
        if self.kwargs.get('list_type') == 'show_in_general':
            return _("General box")
        elif self.kwargs.get('list_type') == 'show_in_remarkable':
            return _("Remarkable Recitations")
        elif self.kwargs.get('list_type') == 'is_teacher_recitation':
            return _("Teachers Recitations")
        elif self.kwargs.get('list_type') == 'my_evaluated_recitations':
            return _("My Evaluated Recitations")
        else:
            return _("My Recitations")

    def get_queryset(self):
        if self.kwargs.get('list_type') == 'show_in_general':
            return Recitation.objects.filter(
                evaluated_at__isnull=True,
                being_evaluated=False,
                show_in_general=True,
                gender=self.request.user.gender).exclude(
                owner__is_a_teacher=True,
                is_teacher_recitation=True).order_by('created_at')
        elif self.kwargs.get('list_type') == 'show_in_remarkable':
            queryset = Recitation.objects.filter(
                is_remarkable=True,
                show_in_remarkable=True,
                gender=self.request.user.gender).exclude(
                owner__is_a_teacher=True,
                is_teacher_recitation=True).order_by('created_at')
        elif self.kwargs.get('list_type') == 'is_teacher_recitation':
            return Recitation.objects.filter(
                owner__is_a_teacher=True,
                is_teacher_recitation=True,
                gender=self.request.user.gender).order_by('created_at')
        elif self.kwargs.get('list_type') == 'my_evaluated_recitations':
            return self.request.user.recitations_teacher.filter(evaluated_at__isnull=False).order_by('evaluated_at')
        else:
            return self.request.user.recitations.all()
