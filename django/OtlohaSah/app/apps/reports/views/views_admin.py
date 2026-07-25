import csv

from django.contrib.auth.mixins import PermissionRequiredMixin, LoginRequiredMixin
from django.db.models import Sum, Case, When, F, Count, IntegerField, Q
from django.db.models.functions import Coalesce
from django.http import JsonResponse, HttpResponse
from django.utils.timezone import now
from django.utils.translation import gettext_lazy as _
from django.views import View
from dynamic_listing.views import DynamicTableView, BulkActionMixin

from apps.reports.filters import TeacherAccountingFilterSet, TeacherRecitationPricingFilterSet
from apps.users.models import TeacherRecitationPricing, Teacher


class TeacherAccountingReportView(LoginRequiredMixin, PermissionRequiredMixin, DynamicTableView):
    permission_required = "users.view_teacher"
    model = Teacher
    title = _("Teachers Accounting's Report")
    load_rows_from_template = True
    row_template_name = 'reports/teachers_accounting/_table_row.html'
    filterset_class = TeacherAccountingFilterSet
    bulk_actions = 'reports/teachers_accounting/_bulk_actions.html'
    header_template_name = 'reports/teachers_accounting/__header.html'
    listing_actions = 'reports/teachers_accounting/__listing_actions.html'

    table_columns = (
        ('id', _("ID")),
        ("name", _("Name"), "min-w-200px text-start"),
        ("total_earnings", _("Total Earnings"), "text-center"),
        ("total_dues", _("Total Dues"), "text-center"),
        ("paid_recitation_count", _("Paid Recitation Count"), "text-center"),
        ("unpaid_recitation_count", _("Unpaid Recitation Count"), "text-center"),
    )

    def get_queryset(self):
        queryset = Teacher.objects.annotate(
            total_earnings=Coalesce(
                Sum(Case(When(
                    teacherrecitationpricing__is_paid=True,
                    then=F('teacherrecitationpricing__price')),
                    default=0.0)), 0.0),
            total_dues=Coalesce(
                Sum(Case(When(
                    teacherrecitationpricing__is_paid=False,
                    then=F('teacherrecitationpricing__price')),
                    default=0.0)), 0.0),
            paid_recitation_count=Count(Case(When(
                teacherrecitationpricing__is_paid=True,
                then=1
            ), output_field=IntegerField())),
            unpaid_recitation_count=Count(Case(When(
                teacherrecitationpricing__is_paid=False,
                then=1
            ), output_field=IntegerField())),
        ).filter(Q(Q(total_earnings__gt=0, paid_recitation_count__gt=0) | Q(total_dues__gt=0,
                                                                            unpaid_recitation_count__gt=0)))
        if self.get_filterset_class() is not None:
            filters = self.get_filterset_class()(self.request.GET, queryset)
            self.get_filterset_renderer(filters)
            queryset = filters.qs
        return queryset

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"title": _("Reports"), },
            {"title": _("Teachers Accounting's"), },
        ]

    def get_context_data(self, *args, **kwargs):
        context = super().get_context_data(*args, **kwargs)
        context.update({"total_earnings": sum(self.get_queryset().values_list('total_earnings', flat=True))})
        context.update({"total_dues": sum(self.get_queryset().values_list('total_dues', flat=True))})
        return context


class MarkPricingAsCompleteView(BulkActionMixin, LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = "users.mark_as_complete_teacherrecitationpricing"

    def post(self, request, *args, **kwargs):
        message = _("Successfully marked as complete")
        status = True
        teachers = Teacher.objects.annotate(
            total_earnings=Coalesce(
                Sum(Case(When(
                    teacherrecitationpricing__is_paid=True,
                    then=F('teacherrecitationpricing__price')),
                    default=0.0)), 0.0),
            total_dues=Coalesce(
                Sum(Case(When(
                    teacherrecitationpricing__is_paid=False,
                    then=F('teacherrecitationpricing__price')),
                    default=0.0)), 0.0),
        )

        input_type, value = self.get_actions_type_and_value(request.POST)
        if input_type == 'selected':
            teachers = teachers.filter(id__in=value)
            teachers_ids = teachers.values_list('id', flat=True)
            if not all([int(pid) in teachers_ids for pid in value]) or not teachers.exists():
                message = _("Invalid pricing ids")
                status = False
            queryset = TeacherRecitationPricing.objects.filter(teacher__in=teachers)
        elif input_type == 'queryset':
            teachers = TeacherAccountingFilterSet(data=value, queryset=teachers.all()).qs
            data = {"teachers__ids": ','.join([str(t.id) for t in teachers])}
            if value.get('date', None):
                data.update({"created_at": value.get('date')})
            queryset = TeacherRecitationPricingFilterSet(data=data, queryset=TeacherRecitationPricing.objects.all()).qs
        elif input_type == 'none':
            teachers = teachers.all()
            queryset = TeacherRecitationPricing.objects.filter(teacher_id__in=teachers.values_list('id', flat=True))
        else:
            message = _("No data provided")
            status = False
            queryset = TeacherRecitationPricing.objects.none()

        if status:
            queryset.update(is_paid=True, paid_at=now())

        return JsonResponse({"message": message}, status=200 if status else 422)


class TeacherAccountingExportView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = "users.view_teacher"

    def get_queryset(self):
        return Teacher.objects.annotate(
            total_earnings=Coalesce(
                Sum(Case(
                    When(teacherrecitationpricing__is_paid=True, then=F('teacherrecitationpricing__price')),
                    default=0.0
                )),
                0.0
            ),
            total_dues=Coalesce(
                Sum(Case(
                    When(teacherrecitationpricing__is_paid=False, then=F('teacherrecitationpricing__price')),
                    default=0.0
                )),
                0.0
            ),
            paid_recitation_count=Count(Case(
                When(teacherrecitationpricing__is_paid=True, then=1),
                output_field=IntegerField()
            )),
            unpaid_recitation_count=Count(Case(
                When(teacherrecitationpricing__is_paid=False, then=1),
                output_field=IntegerField()
            )),
        ).filter(
            Q(Q(total_earnings__gt=0, paid_recitation_count__gt=0) | Q(total_dues__gt=0, unpaid_recitation_count__gt=0))
        )

    def get(self, request, *args, **kwargs):
        queryset = self.get_queryset()

        # Create the HttpResponse object with the appropriate CSV header.
        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="teachers_accounting_report.csv"'

        writer = csv.writer(response)

        # Write CSV header
        writer.writerow([
            _('ID'), _('Name'), _('Total Earnings'), _('Total Dues'), _('Paid Recitation Count'),
            _('Unpaid Recitation Count')
        ])

        # Write data rows
        for teacher in queryset:
            writer.writerow([
                teacher.id,
                teacher.get_full_name,
                teacher.total_earnings,
                teacher.total_dues,
                teacher.paid_recitation_count,
                teacher.unpaid_recitation_count
            ])

        return response
