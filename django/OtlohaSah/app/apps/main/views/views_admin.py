import json

from django.contrib.auth.mixins import LoginRequiredMixin
from django.core.serializers.json import DjangoJSONEncoder
from django.db.models import Count, Case, Sum, When, Q, F
from django.http import JsonResponse
from django.shortcuts import render
from django.utils.encoding import force_str
from django.utils.functional import Promise
from django.utils.translation import gettext as _
from django.views import View

from apps.main.filters import StatisticsForm, UserFilterset, RecitationFilterset
from apps.recitation.models import Recitation
from apps.users import countries_config
from apps.users.models import User


def get_percentage(value, total):
    if value == 0 or value is None:
        return 0
    return round(value / total * 100, 2)


class LazyEncoder(DjangoJSONEncoder):
    def default(self, obj):
        if isinstance(obj, Promise):
            return force_str(obj)
        return super(LazyEncoder, self).default(obj)


class HomeFiltersMixin:
    def get_users_statistics(self, conf):
        queryset = User.objects.filter(is_staff=False)
        queryset = UserFilterset(self.request.GET, queryset=queryset).qs
        users = queryset.aggregate(
            count=Count('id'),
            students_total=Sum(Case(When(is_a_teacher=False, then=1), default=0)),
            blocked_students=Sum(Case(When(Q(is_a_teacher=False) & Q(is_blocked=True), then=1), default=0)),
            active_students=Sum(Case(When(Q(is_a_teacher=False) & Q(is_blocked=False), then=1), default=0)),
            teachers_total=Sum(Case(When(is_a_teacher=True, then=1), default=0)),
            active_teachers=Sum(Case(When(Q(is_a_teacher=True) & Q(is_blocked=False), then=1), default=0)),
            blocked_teachers=Sum(Case(When(Q(is_a_teacher=True) & Q(is_blocked=True), then=1), default=0)),
            approved_teachers=Sum(
                Case(When(Q(is_a_teacher=True) & Q(teacherprofile__status='approved'), then=1), default=0)),
            pending_teachers=Sum(
                Case(When(Q(is_a_teacher=True) & Q(teacherprofile__status='pending'), then=1), default=0)),
            rejected_teachers=Sum(
                Case(When(Q(is_a_teacher=True) & Q(teacherprofile__status='rejected'), then=1), default=0)),
            paid_teachers=Sum(
                Case(When(Q(is_a_teacher=True) & Q(teacherprofile__teacher_type='paid'), then=1), default=0)),
            volunteer_teachers=Sum(
                Case(When(Q(is_a_teacher=True) & Q(teacherprofile__teacher_type='volunteer'), then=1), default=0)),
        )
        charts_data = {
            "users": json.dumps({
                "label": _("Users"),
                "total": users["count"] or 0,
                "conf": conf,
                "categories": [
                    {
                        "name": "students",
                        "label": _("Students"),
                        "color": "--bs-primary",
                        "is_variable_color": True,
                        "value": users["students_total"],
                        "percentage": get_percentage(users['students_total'], users['count'])
                    },
                    {
                        "name": "teachers",
                        "label": _("Teachers"),
                        "color": "--bs-warning",
                        "is_variable_color": True,
                        "value": users["teachers_total"],
                        "percentage": get_percentage(users['teachers_total'], users['count'])
                    },
                ]
            }),
            "students": json.dumps({
                "label": _("Students"),
                "total": users["students_total"] or 0,
                "conf": conf,
                "categories": [
                    {
                        "name": "active",
                        "label": _("Active"),
                        "color": "--bs-success",
                        "is_variable_color": True,
                        "value": users["active_students"],
                        "percentage": get_percentage(users['active_students'], users['students_total'])
                    },
                    {
                        "name": "blocked",
                        "label": _("Blocked"),
                        "color": "--bs-danger",
                        "is_variable_color": True,
                        "value": users["blocked_students"],
                        "percentage": get_percentage(users['blocked_students'], users['students_total'])
                    },
                ]
            }),
            "teachers": json.dumps({
                "label": _("Teachers"),
                "total": users["teachers_total"] or 0,
                "conf": conf,
                "categories": [
                    {
                        "name": "active",
                        "label": _("Active"),
                        "color": "--bs-success",
                        "is_variable_color": True,
                        "value": users["active_teachers"],
                        "percentage": get_percentage(users['active_teachers'], users['teachers_total'])
                    },
                    {
                        "name": "blocked",
                        "label": _("Blocked"),
                        "color": "--bs-danger",
                        "is_variable_color": True,
                        "value": users["blocked_teachers"],
                        "percentage": get_percentage(users['blocked_teachers'], users['teachers_total'])
                    },
                ]
            }),
            "teachers_profiles": json.dumps({
                "label": _("Teachers Profiles"),
                "total": users["teachers_total"] or 0,
                "conf": conf,
                "categories": [
                    {
                        "name": "approved",
                        "label": _("Approved"),
                        "color": "--bs-success",
                        "is_variable_color": True,
                        "value": users["approved_teachers"],
                        "percentage": get_percentage(users['approved_teachers'], users['teachers_total'])
                    },
                    {
                        "name": "pending",
                        "label": _("Pending"),
                        "color": "--bs-warning",
                        "is_variable_color": True,
                        "value": users["pending_teachers"],
                        "percentage": get_percentage(users['pending_teachers'], users['teachers_total'])
                    },
                    {
                        "name": "rejected",
                        "label": _("Rejected"),
                        "color": "--bs-danger",
                        "is_variable_color": True,
                        "value": users["rejected_teachers"],
                        "percentage": get_percentage(users['rejected_teachers'], users['teachers_total'])
                    },
                ]
            }),
            "teachers_types": json.dumps({
                "label": _("Teachers Types"),
                "total": users["teachers_total"] or 0,
                "conf": conf,
                "categories": [
                    {
                        "name": "paid",
                        "label": _("Paid"),
                        "color": "--bs-success",
                        "is_variable_color": True,
                        "value": users["paid_teachers"],
                        "percentage": get_percentage(users['paid_teachers'], users['teachers_total'])
                    },
                    {
                        "name": "volunteer",
                        "label": _("Volunteer"),
                        "color": "--bs-warning",
                        "is_variable_color": True,
                        "value": users["volunteer_teachers"],
                        "percentage": get_percentage(users['volunteer_teachers'], users['teachers_total'])
                    },
                ]
            })

        }
        return queryset, charts_data

    def get_recitations_statistics(self, conf):
        queryset = Recitation.objects.all()
        queryset = RecitationFilterset(self.request.GET, queryset=queryset).qs
        recitations = queryset.aggregate(
            total=Count('id'),
            evaluated=Sum(Case(When(result__isnull=False, then=1), default=0)),
            pending=Sum(Case(When(result__isnull=True, then=1), default=0)),
            reported=Sum(Case(When(result=Recitation.RESULT_REPORTED, then=1), default=0)),
            accepted=Sum(Case(When(result=Recitation.RESULT_ACCEPTED, then=1), default=0)),
            rejected=Sum(Case(When(result=Recitation.RESULT_REJECTED, then=1), default=0)),
            from_general_box=Sum(Case(When(
                Q(teacher__isnull=False) & ~Q(teacher=F('owner__favorite_teacher')), then=1
            ), default=0)),
            with_favorite_teacher=Sum(Case(When(
                Q(teacher__isnull=False) & Q(teacher=F('owner__favorite_teacher')), then=1
            ), default=0)),
        )
        if recitations['with_favorite_teacher'] is None:
            recitations['with_favorite_teacher'] = 0
        if recitations['from_general_box'] is None:
            recitations['from_general_box'] = 0

        sum_of_count = recitations['with_favorite_teacher'] + recitations['from_general_box']
        charts_data = {
            "recitations_evaluations": json.dumps({
                "label": _("Recitations Evaluations"),
                "total": recitations["total"] or 0,
                "conf": conf,
                "categories": [
                    {
                        "name": "pending",
                        "label": _("Pending"),
                        "color": "--bs-info",
                        "is_variable_color": True,
                        "value": recitations["pending"],
                        "percentage": get_percentage(recitations['pending'], recitations['total'])
                    },
                    {
                        "name": "accepted",
                        "label": _("Accepted"),
                        "color": "--bs-success",
                        "is_variable_color": True,
                        "value": recitations["accepted"],
                        "percentage": get_percentage(recitations['accepted'], recitations['total'])
                    },
                    {
                        "name": "rejected",
                        "label": _("Rejected"),
                        "color": "--bs-warning",
                        "is_variable_color": True,
                        "value": recitations["rejected"],
                        "percentage": get_percentage(recitations['rejected'], recitations['total'])
                    },
                    {
                        "name": "reported",
                        "label": _("Reported"),
                        "color": "--bs-danger",
                        "is_variable_color": True,
                        "value": recitations["reported"],
                        "percentage": get_percentage(recitations['reported'], recitations['total'])
                    },
                ]
            }),
            "recitations_sources": json.dumps({
                "label": _("Recitations Sources"),
                "total": sum_of_count or 0,
                "conf": conf,
                "categories": [
                    {
                        "name": "from_general_box",
                        "label": _("From General Box"),
                        "color": "--bs-success",
                        "is_variable_color": True,
                        "value": recitations["from_general_box"],
                        "percentage": get_percentage(recitations['from_general_box'], sum_of_count)
                    },
                    {
                        "name": "with_favorite_teacher",
                        "label": _("With Favorite Teacher"),
                        "color": "--bs-warning",
                        "is_variable_color": True,
                        "value": recitations["with_favorite_teacher"],
                        "percentage": get_percentage(recitations['with_favorite_teacher'], sum_of_count)
                    },
                ]
            })
        }
        return recitations, charts_data

    def get_countries_statistics(self, users):
        users = users.values('country').annotate(count=Count('country'))
        countries_dict = dict(countries_config.COUNTRIES)
        countries = {}
        for user in users:
            if user['country'] in countries.keys():
                countries[user['country']]['count'] += user['count']
            else:
                countries[user['country']] = {
                    "count": user['count'],
                    "code": user['country'],
                    "name": countries_dict.get(user['country'])
                }
        return json.dumps(list(countries.values()), cls=LazyEncoder)


class Home(HomeFiltersMixin, LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        conf = {"size": 100, "line_width": 15, }
        users, users_charts = self.get_users_statistics(conf)

        recitations, recitations_charts = self.get_recitations_statistics(conf)
        countries = self.get_countries_statistics(users)
        charts_data = {**users_charts, **recitations_charts}

        return render(request, 'main/admin/home/index.html', {
            "title": _("Home"),
            "breadcrumb": [
                {"title": _("Home"), "url": request.path}
            ],
            "charts_data": charts_data,
            "countries": countries,
            "form": StatisticsForm(request.GET or None),
            # 'actions': 'main/admin/home/_filter.html'
        })


class StatisticsView(HomeFiltersMixin, LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        conf = {"size": 100, "line_width": 15, }
        users, users_charts = self.get_users_statistics(conf)

        recitations, recitations_charts = self.get_recitations_statistics(conf)
        countries = self.get_countries_statistics(users)
        charts_data = {**users_charts, **recitations_charts}

        return JsonResponse({
            "charts_data": charts_data,
            "countries": countries,
        })
