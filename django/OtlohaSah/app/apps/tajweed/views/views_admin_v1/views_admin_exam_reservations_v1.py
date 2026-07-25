from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.db.models import F
from django.shortcuts import redirect, get_object_or_404, render
from django.urls import reverse
from django.utils.translation import gettext_lazy as _
from django.views import View
from dynamic_listing.views import DynamicTableView

from apps.tajweed import config
from apps.tajweed.filters import ExamReservationFilter
from apps.tajweed.forms.admin_form import ApproveExamReservationForm, RejectExamReservationForm
from apps.tajweed.models.exams import ExamReservation


class ExamReservationListingView(LoginRequiredMixin, PermissionRequiredMixin, DynamicTableView):
    model = ExamReservation
    title = _("All Exam reservation")
    permission_required = "tajweed.view_exam-reservation"
    filterset_class = ExamReservationFilter
    listing_actions = "tajweed/exam-reservations/listing/_actions.html"
    load_rows_from_template = True
    row_template_name = 'tajweed/exam-reservations/listing/_table_row.html'
    table_columns = (
        ('id', _('ID'), 'text-center'),
        ('level', _('Level'), 'text-center'),
        ('exam_type', _('Exam type'), 'text-center'),
        ('calendar_slot', _('Calendar slot'), 'text-center'),
        ('status', _('Status'), 'text-center'),
        ('meeting_link', _('Meeting link'), 'text-center'),
    )

    def get_context_data(self, *args, **kwargs):
        context = super().get_context_data(*args, **kwargs)
        exam_reservation = ExamReservation.objects.all()
        context['all_exam_reservation_count'] = exam_reservation.count()
        return context

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"title": self.title, },
        ]


class ApproveExamReservationView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ('tajweed.approve_exam_reservation',)

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home")},
            {"url": reverse("admin:tajweed:exam-reservations:listing"), "title": _("All exam reservation")},
            {"title": _("Approve Exam Reservation")}
        ]

    def check_exam_reservation_status(self, exam_reservation):
        if exam_reservation.status != config.STATUS_PENDING:
            return redirect(reverse('admin:tajweed:exam-reservations:listing'))
        return None

    def get(self, request, *args, **kwargs):
        title = _("Approve exam reservation")
        form = ApproveExamReservationForm()
        if 'pk' in kwargs:
            exam_reservation = get_object_or_404(ExamReservation, pk=kwargs['pk'])
            redirect_response = self.check_exam_reservation_status(exam_reservation)
            if redirect_response:
                return redirect_response
            form = ApproveExamReservationForm(instance=exam_reservation)

        return render(request, 'tajweed/exam-reservations/approve_form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })

    def post(self, request, *args, **kwargs):
        title = _("Approve exam reservation")
        message = _("Exam reservation Approved Successfully")
        form = ApproveExamReservationForm()

        if 'pk' in kwargs:
            exam_reservation = get_object_or_404(ExamReservation, pk=kwargs['pk'])
            redirect_response = self.check_exam_reservation_status(exam_reservation)
            if redirect_response:
                return redirect_response

            form = ApproveExamReservationForm(request.POST, request.FILES, instance=exam_reservation)

            if form.is_valid():
                form.save()
                exam_reservation.status = config.STATUS_ACCEPTED
                exam_reservation.save()
                messages.success(request, message)
                return redirect(reverse('admin:tajweed:exam-reservations:listing'))

        return render(request, 'tajweed/exam-reservations/approve_form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })


class RejectExamReservationView(LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return ('tajweed.reject_exam_reservation',)

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home")},
            {"url": reverse("admin:tajweed:exam-reservations:listing"), "title": _("All exam reservations")},
            {"title": _("Reject Exam Reservation")}
        ]

    def check_exam_reservation_status(self, exam_reservation):
        if exam_reservation.status != config.STATUS_PENDING:
            return redirect(reverse('admin:tajweed:exam-reservations:listing'))
        return None

    def get(self, request, *args, **kwargs):
        title = _("Reject exam reservation")
        form = RejectExamReservationForm()
        if 'pk' in kwargs:
            exam_reservation = get_object_or_404(ExamReservation, pk=kwargs['pk'])
            redirect_response = self.check_exam_reservation_status(exam_reservation)
            if redirect_response:
                return redirect_response
            form = RejectExamReservationForm(instance=exam_reservation)

        return render(request, 'tajweed/exam-reservations/reject_form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })

    def post(self, request, *args, **kwargs):
        title = _("Reject exam reservation")
        message = _("Exam reservation Rejected Successfully")
        form = RejectExamReservationForm()

        if 'pk' in kwargs:
            exam_reservation = get_object_or_404(ExamReservation, pk=kwargs['pk'])
            redirect_response = self.check_exam_reservation_status(exam_reservation)
            if redirect_response:
                return redirect_response

            form = RejectExamReservationForm(request.POST, request.FILES, instance=exam_reservation)

            if form.is_valid():
                form.save()
                exam_reservation.status = config.STATUS_REJECTED
                exam_reservation.save()
                exam_reservation.calendar_slot.reserved_slots = F('reserved_slots') - 1
                exam_reservation.calendar_slot.save()
                messages.success(request, message)
                return redirect(reverse('admin:tajweed:exam-reservations:listing'))

        return render(request, 'tajweed/exam-reservations/form.html', {
            "form": form,
            "breadcrumb": self.get_breadcrumb(),
            "title": title
        })


class DeleteExamReservationView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = 'tajweed.delete_exam-reservation'

    def post(self, request, pk, *args, **kwargs):
        exam_reservation = get_object_or_404(ExamReservation, pk=pk)
        exam_reservation.delete()
        messages.success(request, _("Exam reservation Deleted Successfully"))
        return redirect(reverse('admin:tajweed:exam-reservations:listing'))
