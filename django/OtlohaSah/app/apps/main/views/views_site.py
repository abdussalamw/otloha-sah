from django.http import Http404
from django.shortcuts import render
from django.views import View

from dynamic_listing.views import DynamicTableView, DynamicListView


class Home(View):
    def get(self, request, *args, **kwargs):
        return render(request, 'main/site/home.html')


class SiteDynamicTableView(DynamicTableView):
    template_name = 'site/dynamic_listing/index.html'
    listing_template_name = 'site/dynamic_listing/_table_view.html'


class SiteDynamicListView(DynamicListView):
    template_name = 'site/dynamic_listing/index.html'
    listing_template_name = 'site/dynamic_listing/_list.html'


class SystemDocumentsView(View):
    def get(self, request, slug):
        if slug not in ['privacy', 'terms-and-conditions']:
            raise Http404
        return render(request, f"main/site/system-documents/{slug}.html")
