from django.contrib import messages
from django.contrib.auth.mixins import PermissionRequiredMixin, LoginRequiredMixin
from django.contrib.contenttypes.models import ContentType
from django.db.models import F, Count, Case, When, Sum, Q, Subquery, OuterRef, IntegerField, CharField
from django.db.models.functions import ExtractHour, ExtractMinute, Cast
from django.http import JsonResponse
from django.shortcuts import get_object_or_404, redirect, render
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View
from django.views.generic import DetailView
from dynamic_listing import DynamicListFactory
from dynamic_listing.views import DynamicListView

from apps.chat.models import Room
from apps.recitation.filters import RecitationFilter
from apps.recitation.models import Recitation
from apps.users import countries_config
from quran_api_client.models import Narration

RecitationDynamicListingFactory = DynamicListFactory(
    model=Recitation,
    filterset_class=RecitationFilter,
    item_template_name="recitations/admin/listing/_list_item.html",
    header_template_name="users/admin/details/tab_contents/partials/__recitations.html"
)


class RecitationsListingView(LoginRequiredMixin, PermissionRequiredMixin, DynamicListView):
    permission_required = "recitation.view_recitation"
    model = Recitation
    filterset_class = RecitationFilter
    title = _("All Recitations")
    item_template_name = "recitations/admin/listing/_list_item.html"
    header_template_name = "recitations/admin/listing/_header_template.html"

    def get_context_data(self, *args, **kwargs):
        context = super().get_context_data(*args, **kwargs)
        recitations = Recitation.objects.all()
        context['all_recitations_count'] = recitations.count()
        context['rejected_recitations_count'] = recitations.rejected().count()
        context['corrected_recitations_count'] = recitations.accepted().count()
        context['remarkable_recitations_count'] = recitations.remarkable().count()
        return context

    def get_breadcrumb(self):
        return [
            {"url": "/", "title": _("Home"), },
            {"title": _("All Recitations"), },
        ]


class DetailsView(LoginRequiredMixin, PermissionRequiredMixin, DetailView):
    permission_required = "recitation.view_recitation"
    model = Recitation
    template_name = 'recitations/admin/details/index.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        content_type = ContentType.objects.get_for_model(context['object'])
        room = Room.objects.filter(object_id=context['object'].id, content_type=content_type)
        context['room'] = room.first() if room.exists() else None
        context['title'] = _("Recitation ID-{}").format(self.object.id)
        context['breadcrumb'] = [
            {"url": "/", "title": _("Home"), },
            {"title": _("All Recitations"), "url": reverse("admin:recitations:listing")},
            {"title": context['title'], },
        ]
        return context


class RecitationDeleteView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = "recitation.delete_recitation"

    def post(self, request, pk):
        instance = get_object_or_404(Recitation, pk=pk)
        previous_page = request.META.get('HTTP_REFERER')

        if not instance.is_teacher_recitation:
            messages.error(request, _("Can't delete student recitation!"))
            return redirect(previous_page)

        instance.delete()
        messages.success(request, _("Teacher recitation deleted successfully!"))
        return redirect(previous_page)


class RecitationStatisticsView(LoginRequiredMixin, PermissionRequiredMixin, View):
    permission_required = "recitation.view_recitation"

    def get(self, request):
        return render(request, 'recitations/admin/statistics.html', {
            "title": _("Recitations Statistics"),
            "breadcrumb": [
                {"url": "/", "title": _("Home"), },
                {"title": _("Recitations"), "url": reverse("admin:recitations:listing")},
                {"title": _("Statistics"), },
            ]
        })


class RecitationStatisticsAjaxView(LoginRequiredMixin, PermissionRequiredMixin, View):
    """
      5- total number of remarkable recitations
      11- total number of chat rooms (open, closed)

      """
    permission_required = "recitation.view_recitation"

    def get_response_object(self, data, title):
        items = {
            "totals": {
                "label": _("Total Recitations"),
                "count": data["total_count"],
                'test': data['total_count'] > 0,
                'component': {'component': 'donut-chart', 'props': {}},
                "segments": [
                    {"name": _("Pending"), "count": data["pending"], "color": "#198754"},
                    {"name": _("Accepted"), "count": data["accepted"], "color": "#dc3545"},
                    {"name": _("Rejected"), "count": data["rejected"], "color": "#6f42c1"},
                    {"name": _("Reported"), "count": data["reported"], "color": "#0dcaf0"},
                    {"name": _("Remarkable"), "count": data["remarkable"], "color": "#198754"},
                ],
            },
            "teachers_vs_students": {
                "label": _("Teachers vs Students Recitations"),
                "count": data['total_count'],
                'test': data['total_count'] > 0,
                'component': {'component': 'donut-chart', 'props': {}},
                "segments": [
                    {"name": _("Teachers Recitations"), "count": data["teachers_recitations"],
                     "color": "#198754"},
                    {"name": _("Students Recitations"), "count": data["students_recitations"],
                     "color": "#dc3545"},
                ]
            },
            "teachers_gender": {
                "label": _("Teachers Recitations by Gender"),
                "count": data['teachers_recitations'],
                'test': data['teachers_recitations'] > 0,
                'component': {'component': 'donut-chart', 'props': {}},
                "segments": [
                    {"name": _("Male Recitations"), "count": data["male_teachers_recitations"],
                     "color": "#198754"},
                    {"name": _("Female Recitations"),
                     "count": data["female_teachers_recitations"],
                     "color": "#dc3545"},
                ]
            },
            "students_gender": {
                "label": _("Students Recitations by Gender"),
                "count": data['students_recitations'],
                'component': {'component': 'donut-chart', 'props': {}},
                "test": data['students_recitations'] > 0,
                "segments": [
                    {"name": _("Male Recitations"), "count": data["male_students_recitations"],
                     "color": "#ffc107"},
                    {"name": _("Female Recitations"),
                     "count": data["female_students_recitations"],
                     "color": "#0dcaf0"},
                ]
            },
            "total_record_duration": {
                "label": _("Total Record Duration"),
                "count": f"{data['total_hours']}H {data['total_minutes']}M",
                'test': data['total_hours'] and data['total_minutes'],
                'component': {'component': 'statistics-icon',
                              "props": {'classes': 'fa-solid fa-microphone-lines fs-5x text-primary'}},
                "segments": [
                    {"name": _("Total Hours"), "count": data["total_hours"],
                     "color": "#0dcaf0"},
                    {"name": _("Total Minutes"), "count": data["total_minutes"],
                     "color": "#ffc107"},
                ]
            },
            "total_rooms": {
                "label": _("Total Rooms"),
                "count": data["total_rooms"],
                'test': data['total_rooms'] > 0,
                'component': {'component': 'donut-chart', 'props': {}},
                "segments": [
                    {"name": _("Total Open Rooms"), "count": data["total_open_rooms"],
                     "color": "#0dcaf0"},
                    {"name": _("Total Closed Rooms"), "count": data["total_closed_rooms"],
                     "color": "#ffc107"},
                ]
            }
        }
        # items = {key: value for key, value in items['items'].items() if value['test']}
        filtered_items = {}
        for key, value in items.items():
            if value['test']:
                filtered_items[key] = value

        return {
            "title": title,
            "items": filtered_items
        }

    def aggregate_totals(self, queryset, title):
        aggregation_expressions = {
            "total_count": Count('id'),
            "pending": Sum(Case(When(result__isnull=True, then=1), default=0)),
            "accepted": Sum(Case(When(result='accepted', then=1), default=0)),
            "rejected": Sum(Case(When(result='rejected', then=1), default=0)),
            "reported": Sum(Case(When(result='reported', then=1), default=0)),
            "remarkable": Sum(Case(When(is_remarkable=True, then=1), default=0)),
            "teachers_recitations": Sum(Case(When(is_teacher_recitation=True, then=1), default=0)),
            "students_recitations": Sum(Case(When(is_teacher_recitation=False, then=1), default=0)),
            "male_teachers_recitations": Sum(Case(When(is_teacher_recitation=True, gender='male', then=1), default=0)),
            "female_teachers_recitations": Sum(
                Case(When(is_teacher_recitation=True, gender='female', then=1), default=0)),
            "male_students_recitations": Sum(Case(When(is_teacher_recitation=False, gender='male', then=1), default=0)),
            "female_students_recitations": Sum(
                Case(When(is_teacher_recitation=False, gender='female', then=1), default=0)),
            "total_hours": ExtractHour(Sum(F('records__duration'))),
            "total_minutes": ExtractMinute(Sum(F('records__duration'))),

            "total_rooms": Count('room'),
            "total_open_rooms": Count('room', filter=Q(room__is_closed=False)),
            "total_closed_rooms": Count('room', filter=Q(room__is_closed=True)),
        }

        # Overall totals
        return self.get_response_object(queryset.aggregate(**aggregation_expressions), title)

    def get_heatmap_data(self, data):
        data = data.values('country').annotate(count=Count('country'))
        countries_dict = dict(countries_config.COUNTRIES)
        countries = {}
        for item in data:
            if item['country'] in countries.keys():
                countries[item['country']]['count'] += item['count']
            else:
                countries[item['country']] = {
                    "count": item['count'],
                    "code": item['country'],
                    "name": countries_dict.get(item['country'])
                }
        countries_list = list(countries.values())
        filtered_countries = [country for country in countries_list if country['count'] > 0]

        # Sort the countries by count in descending order
        sorted_countries = sorted(filtered_countries, key=lambda x: x['count'], reverse=True)

        return sorted_countries

    def get(self, request):
        queryset = Recitation.objects.annotate(
            country=F('owner__country'),
            narration=Cast(F('narration_id'), output_field=IntegerField()),
            narration_name=Subquery(
                Narration.objects.filter(
                    id=Cast(OuterRef('narration_id'), output_field=IntegerField())
                ).values('name')[:1],
                output_field=CharField()
            )
        ).exclude(narration_name__isnull=True)

        overall_totals = self.aggregate_totals(queryset, _("Overall Recitations Statistics"))

        narrations = list({(item['narration_name'], item['narration_id']) for item in
                           queryset.values('narration_name', 'narration_id')})

        narrations_totals = []
        for narration in narrations:
            narrations_totals.append(self.aggregate_totals(
                queryset.filter(narration_id=str(narration[1])),
                _("{name} Recitations Statistics").format(name=narration[0])
            ))

        return JsonResponse({
            "heatmap_data": self.get_heatmap_data(queryset),
            "overall": overall_totals,
            "narrations": narrations_totals
        })
