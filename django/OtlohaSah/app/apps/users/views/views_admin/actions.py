from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.db.models import DateField
from django.forms import BooleanField
from django.http import JsonResponse
from django.utils.formats import date_format
from django.utils.translation import gettext as _
from django.views import View
from dynamic_listing.views import BulkActionMixin

from apps.users import config
from apps.users.filters import get_user_filterset_class
from apps.users.models import Teacher, TeacherProfile
from apps.users.notifications import AccountBlockedNotification
from apps.users.views.mixins import UserTypeValidationMixin
import csv
from django.http import FileResponse
from tempfile import NamedTemporaryFile
from django.db.models import Count, Case, When, Sum
from django.db.models.functions import Coalesce


class UserToggleBlockView(UserTypeValidationMixin, BulkActionMixin, LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return f"users.toggle_block_{self.permission_model_name}",

    def post(self, request, action, *args, **kwargs):
        status = True
        queryset = self.model.objects
        if user_id := self.kwargs.get('pk', None):
            message = _("{user_type} has been blocked successfully").format(
                user_type=config.get_user_type_verbose_name_by_key(self.user_type)
            )
            queryset = queryset.filter(pk=user_id)
            if not queryset.exists():
                message = _("Invalid user id")
                status = False

        else:
            message = _("{user_type} has been blocked successfully").format(
                user_type=config.get_user_type_verbose_name_plural_by_key(self.user_type)
            )
            input_type, value = self.get_actions_type_and_value(request.POST)
            if input_type == 'selected':
                queryset = queryset.filter(id__in=value)
                queryset_ids = queryset.values_list('id', flat=True)
                if not all([int(uid) in queryset_ids for uid in value]) or not queryset.exists():
                    message = _("Invalid user ids")
                    status = False

            elif input_type == 'queryset':
                queryset = get_user_filterset_class(self.user_type)(data=value, queryset=queryset.all()).qs
            elif input_type == 'none':
                queryset = queryset.all()
            else:
                message = _("No data provided")
                status = False

        if status:
            queryset.update(is_blocked=action == 'block')

            for item in queryset.all():
                item.notify(AccountBlockedNotification, receivers=item)

        return JsonResponse({"message": message}, status=200 if status else 422)


class ExportCSVView(UserTypeValidationMixin, LoginRequiredMixin, PermissionRequiredMixin, View):
    def get_permission_required(self):
        return f"users.view_{self.permission_model_name}"

    def get_queryset(self):
        return self.model.objects.annotate(
            total_recitations=Count('recitations_teacher'),
            accepted_recitations=Coalesce(
                Sum(Case(When(recitations_teacher__result='accepted', then=1), default=0)), 0),
            rejected_recitations=Coalesce(
                Sum(Case(When(recitations_teacher__result='rejected', then=1), default=0)), 0),
            reported_recitations=Coalesce(
                Sum(Case(When(recitations_teacher__result='reported', then=1), default=0)), 0),
            pending_recitations=Coalesce(
                Sum(Case(When(recitations_teacher__result__isnull=True, then=1), default=0)), 0),
        ).prefetch_related('teachernarration_set', 'teacherprofile')

    def get(self, request, *args, **kwargs):
        queryset = self.get_queryset()

        # Use NamedTemporaryFile for creating a temporary file
        with NamedTemporaryFile(delete=False, mode='w', newline='', suffix='.csv') as temp_file:
            # Create CSV writer
            writer = csv.writer(temp_file)

            # Combine all fields from Teacher and TeacherProfile models
            teacher_fields = [
                'id', 'first_name', 'last_name', 'date_joined', 'rate', 'level', 'email',
                'username', 'is_blocked', 'country', 'birthdate', 'gender'
            ]
            profile_fields = ['teacher_type', 'status', 'education_degree', 'is_active']
            statistics_fields = [
                "total_recitations",
                "accepted_recitations",
                "rejected_recitations",
                "reported_recitations",
                "pending_recitations",
            ]

            # Write header
            writer.writerow(teacher_fields + profile_fields + statistics_fields)

            # Write data rows
            for teacher in queryset:
                teacher_data = []
                for field in teacher_fields:
                    value = getattr(teacher, field, "N/A")
                    # Check for boolean fields
                    if isinstance(Teacher._meta.get_field(field), BooleanField):
                        value = "Yes" if value else "No"
                    # Check for date fields
                    elif isinstance(Teacher._meta.get_field(field), DateField) and value != "N/A":
                        value = date_format(value, "Y-m-d")  # Format as "YYYY-MM-DD"
                    teacher_data.append(value)

                # Handle profile fields
                profile_data = []
                if hasattr(teacher, 'teacherprofile'):
                    profile = teacher.teacherprofile
                    for field in profile_fields:
                        value = getattr(profile, field, "N/A")
                        # Check for boolean fields
                        if isinstance(TeacherProfile._meta.get_field(field), BooleanField):
                            value = "Yes" if value else "No"
                        # Check for date fields
                        elif isinstance(TeacherProfile._meta.get_field(field), DateField) and value != "N/A":
                            value = date_format(value, "Y-m-d")  # Format as "YYYY-MM-DD"
                        profile_data.append(value)
                else:
                    profile_data = ["N/A"] * len(profile_fields)

                # Handle statistics
                statistics_data = [getattr(teacher, field, 0) for field in statistics_fields]

                # Combine and write data
                writer.writerow(teacher_data + profile_data + statistics_data)
            # Return the FileResponse
            temp_file_path = temp_file.name

        return FileResponse(open(temp_file_path, 'rb'), as_attachment=True, filename='teachers.csv')
