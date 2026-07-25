from django.contrib.auth.mixins import LoginRequiredMixin
from django.shortcuts import render
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View
from django.views.generic import ListView
from django_filters.views import FilterView


class AdminListView(ListView, FilterView):
    class Meta:
        abstract = True

    template_name = 'dynamic_listing/list_view.html'
    list_display = ()
    main_column = None
    paginate_by = 10
    title = _("All Pages")
    actions = None
    filterset_class = None
    many_column = None

    def get_queryset(self):
        queryset = super().get_queryset()
        if self.filterset_class:
            queryset = self.filterset_class(self.request.GET, queryset).qs
        return queryset

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(object_list=None, **kwargs)
        context["breadcrumb"] = self.get_breadcrumb()
        context['title'] = self.get_title()
        context['actions'] = self.get_actions()
        context['columns'] = self.list_display
        context['main_column'] = self.main_column
        context['rows'] = self.load(context['object_list'])
        context['filter'] = self.filterset_class
        context['many_column'] = self.many_column
        return context

    def load(self, object_list):
        items = []
        for item in object_list:
            items.append(self._load_object_row(item))
        return items

    def _load_object_row(self, obj):
        row = []
        for column_name, text in self.list_display:
            method = "load_{}".format(column_name)
            if hasattr(self, method) and callable(getattr(self, method)):
                call = getattr(self, method)
                row.append(call(obj))
            else:
                row.append(mark_safe('<td>{}</td>'.format(getattr(obj, column_name))))
        return row

    def get_actions(self):
        return self.actions

    def get_breadcrumb(self):
        return []

    def get_title(self):
        return self.title


class Home(LoginRequiredMixin, View):
    def get(self, request, *args, **kwargs):
        return render(request, 'main/site/home.html')
