from django.views.generic import ListView


class DynamicListView(ListView):
    filterset_class = None
    template_name = 'dynamic_listing/list_view.html'
    paginate_by = 20
    title = None
    main_column = None
    columns = ()
    actions = None

    def get_context_data(self, *, object_list=None, **kwargs):
        context = super(DynamicListView, self).get_context_data(object_list=None, **kwargs)
        context['title'] = self.title
        context['filters'] = self.filterset_class
        context['actions'] = self.actions
        context['columns'] = self.columns
        context['main_column'] = self.main_column
        return context

    def get_actions(self):
        return self.actions

    def load(self, object_list):
        pass
