from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.shortcuts import redirect, get_object_or_404, render
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from django.views import View
from dynamic_listing.views import DynamicTableView

from apps.tajweed.filters import CalendarSlotFilter
from apps.tajweed.forms.admin_form import CalendarSlotForm
from apps.tajweed.models.calendar import CalendarSlot


class CalendarSlotListingView(LoginRequiredMixin, PermissionRequiredMixin, DynamicTableView):
    model = CalendarSlot
    title = _("All Tajweed calendar slots")
    permission_required = "tajweed.view_calendar-slot"
    filterset_class = CalendarSlotFilter
    listing_actions = "tajweed/calendar-slots/listing/_actions.html"
    load_rows_from_template = True
    row_template_name = 'tajweed/calendar-slots/listing/_table_row.html'
    table_columns = (
        ('id', _('ID'), 'text-center'),
        ('date', _('Date'), 'text-center'),
        ('time_from', _('Time From'), 'text-center'),
        ('time_to', _('Time To'), 'text-center'),
        ('available_slots', _('Available slots'), 'text-center'),
        ('reserved_slots', _('Reserved Slots'), 'text-center'),
        ('actions', _('Actions'), 'text-center'),
    )

    def get_context_data(self, *args, **kwargs):
        context = super().get_context_data(*args, **kwargs)
        calendar_slots = CalendarSlot.objects.all()
        context['all_calendar_slots_count'] = calendar_slots.count()
        return context

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"title": self.title, },
        ]


class CreateOrUpdateCalendarSlotView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ('tajweed.change_calendar-slot',) if self.kwargs.get('pk', None) else ('tajweed.add_calendar-slot',)

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:tajweed:calendar-slots:listing"), "title": _("All calendar slots"), },
            {"title": _("Edit Level") if self.kwargs.get('pk', None) else _("Create calendar slot")}
        ]

    def get(self, request, *args, **kwargs):
        if 'pk' in kwargs:
            calendar_slot = get_object_or_404(CalendarSlot, pk=kwargs['pk'])
            form = CalendarSlotForm(instance=calendar_slot)
            title = _("Update calendar slot")
        else:
            form = CalendarSlotForm()
            title = _("Create calendar slot")

        return render(request, 'tajweed/calendar-slots/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })

    def post(self, request, *args, **kwargs):
        if 'pk' in kwargs:
            calendar_slot = get_object_or_404(CalendarSlot, pk=kwargs['pk'])
            form = CalendarSlotForm(request.POST, request.FILES, instance=calendar_slot)
            message = _("Calendar slot Updated Successfully")
            title = _("Update Calendar slot")
        else:
            form = CalendarSlotForm(request.POST, request.FILES)
            message = _("Calendar slot Created Successfully")
            title = _("Create calendar slot")

        if form.is_valid():
            form.save()
            messages.success(request, message)
            return redirect(reverse('admin:tajweed:calendar-slots:listing'))
        else:
            for field in form.errors:
                for error in form.errors[field]:
                    messages.error(request, error)
        return render(request, 'tajweed/calendar-slots/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })


class DeleteCalendarSlotView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = 'tajweed.delete_calendar-slot'

    def post(self, request, pk, *args, **kwargs):
        calendar_slot = get_object_or_404(CalendarSlot, pk=pk)
        calendar_slot.delete()
        messages.success(request, _("Calendar slot Deleted Successfully"))
        return redirect(reverse('admin:tajweed:calendar-slots:listing'))
