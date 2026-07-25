import inspect

from django.test import TestCase, override_settings

from apps.main.services.service_search.search import SearchAbstract, SearchProvider
from apps.main.tests.models import TestModel


class MockSearchProvider(SearchAbstract):
    def search(self, queryset, columns=None, value=""):
        if columns is None:
            columns = []
        return queryset.filter(name='name')


class SearchAbstractStructureClassTestCase(TestCase):
    def test_it_has_method_search(self):
        self.assertTrue(hasattr(SearchAbstract, 'search'))

    def test_search_method_is_callable(self):
        self.assertTrue(callable(getattr(SearchAbstract, 'search')))

    def test_search_method_signature(self):
        expected_signature = ['self', 'queryset', 'columns', 'value']
        actual_signature = inspect.getfullargspec(SearchAbstract.search)[0]
        self.assertEquals(actual_signature, expected_signature)


class SearchProviderStructureClassTestCase(TestCase):
    def test_it_has_method_search(self):
        self.assertTrue(hasattr(SearchProvider, 'search'))

    def test_it_has_method_get_service_class(self):
        self.assertTrue(hasattr(SearchProvider, 'get_service_class'))


class SearchProviderTestCase(TestCase):
    def setUp(self):
        for _ in range(10):
            if _ % 2:
                TestModel.objects.create(name='name', description='name description')
            else:
                TestModel.objects.create(name='x', description='x')
        self.queryset = TestModel.objects.all()

    @override_settings(SEARCH_SERVICE_PROVIDER="apps.main.tests.test_search_service.MockSearchProvider")
    def test_it_calls_the_select_service_send(self):
        self.assertEquals(self.queryset.filter(name='name'),
                          SearchProvider().search(queryset=self.queryset, columns=['name', 'description'],
                                                  value='name'))

    def test_it_returns_subclass_of_search_provider_abstract(self):
        class_ = SearchProvider().get_service_class()
        self.assertIsInstance(class_, SearchAbstract)
