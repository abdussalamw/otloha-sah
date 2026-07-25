from django.contrib.auth.mixins import PermissionRequiredMixin, LoginRequiredMixin
from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from django.utils.timezone import now
from django.utils.translation import gettext_lazy as _
from django.views import View
from dynamic_listing.views import BulkActionMixin

from apps.users.filters import BaseTeacherRecitationPricingFilter
from apps.users.models import Teacher


class MarkTeacherRecitationPricingAsCompleteView(BulkActionMixin, LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = "users.mark_as_complete_teacherrecitationpricing"

    def post(self, request, *args, **kwargs):
        message = _("Successfully marked as complete")
        status = True
        teacher = get_object_or_404(Teacher, pk=kwargs.get('pk'))
        queryset = teacher.teacherrecitationpricing_set

        if pricing_id := kwargs.get('pricing_id', None):
            queryset = queryset.filter(pk=pricing_id)
            if not queryset.exists():
                message = _("Invalid pricing id")
                status = False
        else:
            input_type, value = self.get_actions_type_and_value(request.POST)
            if input_type == 'selected':
                queryset = queryset.filter(id__in=value)
                queryset_ids = queryset.values_list('id', flat=True)
                if not all([int(pid) in queryset_ids for pid in value]) or not queryset.exists():
                    message = _("Invalid pricing ids")
                    status = False
                if any([pricing.is_paid for pricing in queryset]):
                    message = _("Some of the selected pricing are already paid")
                    status = False

            elif input_type == 'queryset':
                queryset = BaseTeacherRecitationPricingFilter(data=value, queryset=queryset.all()).qs
            elif input_type == 'none':
                queryset = queryset.filter(is_paid=False, paid_at__isnull=True)

            else:
                message = _("No data provided")
                status = False

        if status:
            queryset.update(is_paid=True, paid_at=now())

        return JsonResponse({"message": message}, status=200 if status else 422)
