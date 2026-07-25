from django.contrib import messages
from django.contrib.auth.mixins import PermissionRequiredMixin, LoginRequiredMixin
from django.db.models import Count, When, Case, Sum, FloatField, Subquery, OuterRef, F
from django.db.models.functions import Coalesce
from django.http import Http404
from django.shortcuts import get_object_or_404
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views.generic import DetailView, UpdateView
from dynamic_listing.views import DynamicListView

from apps.recitation.views_admin import RecitationDynamicListingFactory
from apps.users import config
from apps.users.filters import get_user_filterset_class
from apps.users.models import Student, TeacherRecitationPricing
from apps.users.views.mixins import UserTypeValidationMixin
from .listing_factories import TeacherAccountingTablefactory, TeacherNarrationsListFactory, \
    StudentsDynamicListingFactory
from ...forms import USER_FORMS


class UserListingView(UserTypeValidationMixin, LoginRequiredMixin, PermissionRequiredMixin, DynamicListView):
    item_template_name = 'users/admin/listing/list_item/index.html'
    header_template_name = 'users/admin/listing/header/index.html'
    bulk_actions = 'users/admin/listing/_bulk_actions.html'
    listing_actions = 'users/admin/listing/_actions.html'

    def get_queryset(self):
        if self.kwargs.get('user_type', None) == 'students':
            queryset = self.model.objects.prefetch_related('favorite_teacher').annotate(
                total_recitations=Count(F('recitations__id')),
                accepted_recitations=Coalesce(Sum(Case(When(recitations__result='accepted', then=1), default=0)), 0),
                rejected_recitations=Coalesce(Sum(Case(When(recitations__result='rejected', then=1), default=0)), 0),
                reported_recitations=Coalesce(Sum(Case(When(recitations__result='reported', then=1), default=0)), 0),
                pending_recitations=Coalesce(
                    Sum(Case(
                        When(recitations__isnull=False,
                             then=Case(When(recitations__result__isnull=True, then=1), default=0)),
                        default=0
                    )),
                    0
                )
            )

        elif self.kwargs.get('user_type', None) == 'teachers':
            earnings_subquery = TeacherRecitationPricing.objects.filter(
                teacher=OuterRef('pk'),
                is_paid=True
            ).values('teacher').annotate(
                total_earnings=Coalesce(Sum('price'), 0.0)
            ).values('total_earnings')

            dues_subquery = TeacherRecitationPricing.objects.filter(
                teacher=OuterRef('pk'),
                is_paid=False
            ).values('teacher').annotate(
                total_dues=Coalesce(Sum('price'), 0.0)
            ).values('total_dues')

            queryset = self.model.objects.annotate(
                total_recitations=Count('recitations_teacher'),
                accepted_recitations=Coalesce(
                    Sum(Case(When(recitations_teacher__result='accepted', then=1), default=0)), 0),
                rejected_recitations=Coalesce(
                    Sum(Case(When(recitations_teacher__result='rejected', then=1), default=0)), 0),
                reported_recitations=Coalesce(
                    Sum(Case(When(recitations_teacher__result='reported', then=1), default=0)), 0),
                pending_recitations=Coalesce(
                    Sum(Case(When(recitations_teacher__result__isnull=True, then=1), default=0)), 0),

                earnings=Subquery(earnings_subquery, output_field=FloatField()),
                dues=Subquery(dues_subquery, output_field=FloatField()),
            ).prefetch_related('teachernarration_set', 'teacherprofile')

        else:
            queryset = super().get_queryset()

        if self.get_filterset_class() is not None:
            filters = self.get_filterset_class()(self.request.GET, queryset)
            self.get_filterset_renderer(filters)
            queryset = filters.qs
        return queryset

    def get_title(self):
        return config.get_user_type_verbose_name_plural_by_key(self.user_type)

    def get_permission_required(self):
        return f"users.view_{self.permission_model_name}",

    def get_filterset_class(self):
        return get_user_filterset_class(self.user_type)

    def get_breadcrumb(self):
        return [
            {"title": _("Home"), "url": reverse("admin:main:home")},
            {"title": config.get_user_type_verbose_name_plural_by_key(self.user_type)}
        ]

    def get_statistics(self):
        statistics = {}

        if self.user_type == config.USER_TYPE_STUDENT:
            statistics = self.get_queryset().aggregate(
                students_count=Count('id'),
                active_students_count=Sum(Case(When(is_active=True, then=1), default=0)),
                blocked_students_count=Sum(Case(When(is_active=False, then=1), default=0)),
            )

        elif self.user_type == config.USER_TYPE_TEACHER:
            statistics = self.model.objects.aggregate(
                teachers_count=Count('id'),
                approved_teachers_count=Sum(Case(When(teacherprofile__status='approved', then=1), default=0)),
                pending_teachers_count=Sum(Case(When(teacherprofile__status='pending', then=1), default=0)),
                rejected_teachers_count=Sum(Case(When(teacherprofile__status='rejected', then=1), default=0)),
                paid_teachers_count=Sum(Case(When(teacherprofile__teacher_type='paid', then=1), default=0)),
                volunteer_teachers_count=Sum(
                    Case(When(teacherprofile__teacher_type='volunteer', then=1), default=0)))

        return statistics

    def get_context_data(self, *args, **kwargs):
        context = super().get_context_data(*args, **kwargs)
        context['user_type'] = self.kwargs.get('user_type')
        context['verbose_name_plural'] = config.get_user_type_verbose_name_plural_by_key(self.user_type)
        context['verbose_name'] = config.get_user_type_verbose_name_by_key(self.user_type)
        context = {**self.get_statistics(), **context}
        return context


class UserDetailsView(UserTypeValidationMixin, LoginRequiredMixin, PermissionRequiredMixin, DetailView):
    template_name = 'users/admin/details/index.html'

    def get_permission_required(self):
        return f"users.view_{self.permission_model_name}",

    def get_object(self, queryset=None):
        return get_object_or_404(self.model, pk=self.kwargs['pk'])

    def get_title(self):
        return self.object.get_full_name

    def get_breadcrumb(self):
        return [
            {"title": _("Home"), "url": reverse("admin:main:home")},
            {
                "title": config.get_user_type_verbose_name_plural_by_key(self.user_type),
                "url": reverse("admin:users:listing", args=[self.kwargs.get('user_type')])
            },
            {"title": self.get_title()}
        ]

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['actions'] = 'users/admin/_item_actions.html'
        context['item'] = self.object
        context['user_type'] = self.kwargs.get('user_type')
        context['title'] = self.get_title()
        context['breadcrumb'] = self.get_breadcrumb()
        context['verbose_name_plural'] = config.get_user_type_verbose_name_plural_by_key(self.user_type)
        context['verbose_name'] = config.get_user_type_verbose_name_by_key(self.user_type)

        context = {
            **context, **self.get_details()
        }
        return context

    def get_details(self):
        context = {}
        if self.user_type == config.USER_TYPE_STUDENT:
            context['details_type'] = self.kwargs.get("details_type", 'progress')
            if self.kwargs.get('details_type', None) == 'recitations':
                context['recitations'] = self.get_recitations_context(self.object.recitations.all())

        elif self.user_type == config.USER_TYPE_TEACHER:
            if self.kwargs.get('details_type', None) == 'corrected-recitations':
                context["details_type"] = "corrected-recitations"
                context["corrected_recitations"] = self.get_recitations_context(self.object.recitations_teacher.all())
            elif self.kwargs.get('details_type', None) == 'recitations':
                context["details_type"] = "recitations"
                context['recitations'] = self.get_recitations_context(self.object.recitations.all())
            elif self.kwargs.get('details_type', None) == 'teacher-recitations':
                context["details_type"] = "teacher-recitations"
                context['teacher_recitations'] = self.get_recitations_context(
                    self.object.recitations.filter(is_teacher_recitation=True))
            elif self.kwargs.get('details_type', None) == 'narrations':
                context["details_type"] = "narrations"
                context['narrations'] = TeacherNarrationsListFactory(
                    self.request,
                    self.object.teachernarration_set.all()
                )
            elif self.kwargs.get('details_type', None) == 'accounting':
                context["details_type"] = "accounting"
                accounting = TeacherAccountingTablefactory(
                    self.request,
                    self.object.teacherrecitationpricing_set.filter(recitation__evaluated_at__isnull=False))
                accounting.extra_context = {
                    "teacher": self.object,
                    "teacher_earnings": accounting.get_queryset().filter(is_paid=True).values('price').aggregate(
                        sum=Coalesce(Sum("price"), 0.0)
                    )['sum'],
                    "teacher_dues": accounting.get_queryset().filter(is_paid=False).values('price').aggregate(
                        sum=Coalesce(Sum("price"), 0.0)
                    )['sum']
                }
                context['accounting'] = accounting
            else:
                context["details_type"] = "students"
                students = StudentsDynamicListingFactory(self.request,
                                                         Student.objects.filter(favorite_teacher=self.object))
                students.extra_context["students_count"] = students.get_queryset().count()
                students.extra_context['user'] = self.request.user
                context['students'] = students
        return context

    def get_recitations_context(self, queryset):
        recitations = RecitationDynamicListingFactory(self.request, queryset)
        recitations.extra_context["source"] = recitations.get_queryset().aggregate(
            total=Count('id'),
            accepted=Coalesce(Sum(Case(When(result='accepted', then=1), default=0)), 0),
            rejected=Coalesce(Sum(Case(When(result='rejected', then=1), default=0)), 0),
            reported=Coalesce(Sum(Case(When(result='reported', then=1), default=0)), 0),
            pending=Coalesce(Sum(Case(When(result__isnull=True, then=1), default=0)), 0)
        )

        return recitations

    # def get_user_progress(self):
    #     user_progress = self.object.userprogress_set.all()
    #     if not user_progress.exists():
    #         from apps.users.tasks import update_user_recitation_progress
    #         from quran_api_client.models import Narration
    #         for narration in Narration.objects.all():
    #             update_user_recitation_progress(user_id=self.object.id, narration_id=str(narration.id))
    #     return self.object.userprogress_set.all()


class CreateOrUpdateUserView(UserTypeValidationMixin, LoginRequiredMixin, PermissionRequiredMixin,
                             UpdateView):
    template_name = 'users/admin/form/index.html'

    def dispatch(self, request, *args, **kwargs):
        response = super().dispatch(request, *args, **kwargs)
        user_type = kwargs.get('user_type')
        if user_type not in ['admins', 'teachers']:
            raise Http404("Invalid parameter.")

        if user_type == 'teachers' and not self.kwargs.get('pk', None):
            raise Http404("Invalid parameter.")

        return response

    def get_permission_required(self):
        perm = 'add' if self.kwargs.get('pk', None) is None else 'change'
        return f"users.{perm}_{self.permission_model_name}",

    def get_title(self):
        user_type = config.get_user_type_verbose_name_plural_by_key(self.user_type)
        title = _("Add New {user_type}") if self.kwargs.get('pk', None) is None else _("Edit {user_type}")
        return title.format(user_type=user_type)

    def get_breadcrumb(self):
        breadcrumb = [
            {"title": _("Home"), "url": reverse("admin:main:home")},
            {
                "title": config.get_user_type_verbose_name_plural_by_key(self.user_type),
                "url": reverse("admin:users:listing", args=[self.kwargs.get('user_type')])
            }
        ]
        if not self.kwargs.get('pk', None):
            breadcrumb.append({"title": self.get_title()})
        else:
            breadcrumb.append({
                "title": self.object.get_full_name,
                "url": self.object.get_details_url
            })
            breadcrumb.append({"title": self.get_title()})
        return breadcrumb

    def get_form_class(self):
        return USER_FORMS.get(self.user_type)

    def get_object(self, queryset=None):
        if 'pk' in self.kwargs:
            return get_object_or_404(self.model, pk=self.kwargs['pk'])
        return None

    def get_success_url(self):
        return self.object.get_details_url

    def get_message(self):
        user_type = config.get_user_type_verbose_name_by_key(self.user_type)
        action = _("updated") if self.kwargs.get('pk', None) else _("created")
        return _("{user_type} {action} successfully!").format(
            user_type=user_type, action=action
        )

    def form_valid(self, form):
        valid = super(CreateOrUpdateUserView, self).form_valid(form)
        messages.success(self.request, self.get_message())
        return valid

    def get_context_data(self, **kwargs):
        context = super(CreateOrUpdateUserView, self).get_context_data(**kwargs)
        context['user_type'] = self.kwargs.get('user_type')
        context['title'] = self.get_title()
        context['breadcrumb'] = self.get_breadcrumb()
        context['verbose_name_plural'] = config.get_user_type_verbose_name_plural_by_key(self.user_type)
        context['verbose_name'] = config.get_user_type_verbose_name_by_key(self.user_type)
        return context
