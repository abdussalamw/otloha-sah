from django.test import TestCase, RequestFactory
from django.utils.safestring import mark_safe
from django.utils.translation import gettext_lazy as _
from faker import Faker

from apps.main.views_admin import AdminListView
from .models import TestModel


class TestListView(AdminListView):
    model = TestModel
    create_link = 'test/create/'
    title = _('Test Data')
    list_display = (
        ('id', _('id')),
        ('title', _('title')),
        ('created_at', _('created_at')),
        ('updated_at', _('updated_at')),
    )

    def load_title(self, obj):
        return mark_safe('<td>{}</td>'.format(obj.title))


class Test2ListView(AdminListView):
    model = TestModel
    create_link = 'test/create/'
    title = _('Test Data')
    list_display = (
        ('id', _('id')),
        ('title', _('title')),
        ('created_at', _('created_at')),
        ('updated_at', _('updated_at')),
    )

    def get_create_link(self):
        link = super(Test2ListView, self).get_create_link()
        return 'test/create/122'


class AdminListViewTestCase(TestCase):
    def setUp(self):
        for i in range(10):
            TestModel.objects.create(title=Faker().job())
        request = RequestFactory().get('/test/')
        self.view = TestListView()
        self.view.setup(request)
        self.view.object_list = self.view.get_queryset()
        self.context = self.view.get_context_data()

    def test_it_returns_rows_in_context(self):
        """ test response has rows attribute """
        self.assertIn('rows', self.context)

    def test_rows_represents_view_model_data(self):
        """ test rows are loaded correctly """
        rows = []
        for obj in self.view.object_list:
            row = []
            for column_name, text in self.view.list_display:
                function_name = "load_{}".format(column_name)
                if hasattr(self.view, function_name) and callable(getattr(self.view, function_name)):
                    call = getattr(self.view, function_name)
                    row.append(call(obj))
                else:
                    row.append(mark_safe('<td class="text-center">{}</td>'.format(getattr(obj, column_name))))
            rows.append(row)
        self.assertListEqual(self.context['rows'], rows)

    def test_it_returns_columns_in_context(self):
        """ test response has columns attribute """
        self.assertIn('columns', self.context)

    def test_it_returns_main_column_in_context(self):
        """ test response has columns attribute """
        self.assertIn('main_column', self.context)

    def test_it_returns_title_in_context(self):
        """ test response has columns attribute """
        self.assertIn('title', self.context)
        self.assertEqual('Test Data', self.context['title'])

    # def test_it_returns_create_link_in_context(self):
    #     """ test response has create_link attribute """
    #     self.assertIn('create_link', self.context)
    #     self.view.create_link = 'test/create/'
    #     self.assertEqual('test/create/', self.context['create_link'])
    #
    # def test_get_create_link_method_overrides_create_link(self):
    #     """ get_create_link method overrides default create link """
    #     request = RequestFactory().get('/test/')
    #     v = Test2ListView()
    #     v.setup(request)
    #     v.object_list = self.view.get_queryset()
    #     c = v.get_context_data()
    #     self.assertEqual('test/create/122', c['create_link'])
    #
    # def test_query_search_filter(self):
    #     request = RequestFactory().get('/test/')
    #     v = Test2ListView()
    #     v.setup(request)
    #     v.object_list = self.view.get_queryset()
    #     self.assertEqual(1, v.object_list.count())


class TestingFilteration(TestCase):
    def setUp(self):
        self.adminView = AdminListView()

    def test_query_search_filter(self):
        qs = self.adminView.get_queryset()
        self.assertEqual(3, qs.count())

