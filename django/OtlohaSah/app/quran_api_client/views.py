from django.contrib.auth.mixins import LoginRequiredMixin
from django.core.paginator import Paginator
from django.http import JsonResponse
from django.views import View

from quran_api_client.models import Verse
from quran_api_client.tasks import load_quran


def get_narrations(request):
    load_quran.delay()
    return JsonResponse({"data": 'ok'})


class VerseChapterNarrationView(LoginRequiredMixin, View):

    def get_paginated_data(self, queryset, page_number):
        paginator = Paginator(queryset, 50)
        items_page = paginator.get_page(page_number)

        data = [{
            "id": getattr(attr, 'id', None),
            "text": getattr(attr, 'text', None)
        } for attr in items_page]

        return data, items_page.has_next()

    def get(self, request, *args, **kwargs):
        search = request.GET.get('q', None)

        page_number = request.GET.get('page', 1)
        verses = Verse.objects.filter(narration=kwargs['narration'], chapter=kwargs['chapter'])

        data, has_next = self.get_paginated_data(verses, page_number)
        return JsonResponse({
            "results": data,
            "pagination": {
                "more": has_next
            }
        })
