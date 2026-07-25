import inspect

from django.test import TestCase, RequestFactory
from django.views.generic import ListView

from dynamic_listing.tests.setups import ProductTestListView
from dynamic_listing.views import DynamicListView


class DynamicListViewStructureTestCase(TestCase):
    def test_in_extends_django_generic_list_view(self):
        self.assertTrue(issubclass(DynamicListView, ListView))

    def test_it_has_filterset_class_attribute(self):
        self.assertTrue(hasattr(DynamicListView, 'filterset_class'))

    def test_filterset_class_is_none(self):
        self.assertIsNone(DynamicListView.filterset_class)

    def test_it_has_template_name_attribute(self):
        self.assertTrue(hasattr(DynamicListView, 'template_name'))

    def test_template_name_is_equal_to_template_name(self):
        self.assertEquals('dynamic_listing/list_view.html', DynamicListView.template_name)

    def test_it_has_paginate_by_attribute(self):
        self.assertTrue(hasattr(DynamicListView, 'paginate_by'))

    def test_paginate_by_is_equal_to_20(self):
        self.assertEquals(20, DynamicListView.paginate_by)

    def test_it_has_title_attribute(self):
        self.assertTrue(hasattr(DynamicListView, 'title'))

    def test_title_is_equal_to_none(self):
        self.assertIsNone(DynamicListView.title)

    def test_it_has_main_column_attribute(self):
        self.assertTrue(hasattr(DynamicListView, 'main_column'))

    def test_main_column_is_equal_to_none(self):
        self.assertIsNone(DynamicListView.main_column)

    def test_it_has_actions_attribute(self):
        self.assertTrue(hasattr(DynamicListView, 'actions'))

    def test_actions_is_equal_to_none(self):
        self.assertIsNone(DynamicListView.actions)

    def test_it_has_columns_attribute(self):
        self.assertTrue(hasattr(DynamicListView, 'columns'))

    def test_columns_is_equal_to_empty_tuple(self):
        self.assertEquals(tuple(), DynamicListView.columns)

    def test_it_has_get_context_data_attribute(self):
        self.assertTrue(hasattr(DynamicListView, 'get_context_data'))

    def test_get_context_data_is_callable(self):
        self.assertTrue(callable(DynamicListView.get_context_data))


class DynamicListViewGetActionsTestCase(TestCase):
    def test_it_has_get_actions_attribute(self):
        self.assertTrue(hasattr(DynamicListView, 'get_actions'))

    def test_get_actions_is_callable(self):
        self.assertTrue(callable(DynamicListView.get_actions))

    def test_it_returns_actions_attribute_value(self):
        view = DynamicListView()
        self.assertEquals(view.actions, view.get_actions())


class DynamicListViewLoadTestCase(TestCase):
    def setUp(self):
        self.view = ProductTestListView()
        request = RequestFactory().get('/test/')
        self.view.setup(request)
        self.view.object_list = self.view.get_queryset()
        self.context = self.view.get_context_data()

    def test_it_has_load_attribute(self):
        self.assertTrue(hasattr(DynamicListView, 'load'))

    def test_load_is_callable(self):
        self.assertTrue(callable(DynamicListView.load))

    def test_it_takes_object_list_parameter(self):
        expected_signature = ['self', 'object_list']
        actual_signature = inspect.getfullargspec(DynamicListView.load)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_returns_list_of_items(self):
        view = DynamicListView()
        # view.load()


class DynamicListViewResponseTestCase(TestCase):
    def setUp(self):
        # for i in range(10):
        # ProductTestModel.objects.create(title=Faker().job())
        request = RequestFactory().get('/test/')
        self.view1 = ProductTestListView()
        self.view1.setup(request)
        self.view1.object_list = self.view1.get_queryset()
        self.context = self.view1.get_context_data()

    # def test_it_returns_rows_in_context(self):
    #     self.assertIn('rows', self.context)

    def test_it_returns_columns_in_context(self):
        self.assertIn('columns', self.context)

    def test_context_columns_is_equal_to_columns_attribute(self):
        self.assertEquals(self.view1.columns, self.context['columns'])

    def test_it_returns_main_column_in_context(self):
        self.assertIn('main_column', self.context)

    def test_context_main_column_is_equal_to_main_column_attribute(self):
        self.assertEquals(self.view1.main_column, self.context['main_column'])

    def test_it_returns_actions_in_context(self):
        self.assertIn('actions', self.context)

    def test_context_actions_is_equal_to_actions_attribute(self):
        self.assertEquals(self.view1.actions, self.context['actions'])

    def test_it_returns_title_in_context(self):
        self.assertIn('title', self.context)

    def test_context_title_value_is_equal_to_title_attribute(self):
        self.assertEquals(self.view1.title, self.context['title'])

    def test_it_returns_filters_in_context(self):
        self.assertIn('filters', self.context)

    def test_context_filters_value_is_equal_to_filterset_class_attribute(self):
        self.assertEquals(self.view1.filterset_class, self.context['filters'])
