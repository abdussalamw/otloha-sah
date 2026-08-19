import inspect

from django.test import TestCase, override_settings

from apps.chapters.factories import ChapterFactory
from apps.chapters.models import Chapter
from apps.main.services.service_search.search import SearchAbstract, SearchProvider


class MockSearchProvider(SearchAbstract):
    def search(self, queryset, columns=None, value=""):
        if columns is None:
            columns = []
        return queryset.filter(name='name')

    def ranked_search(self, queryset, columns, value):
        return self.search(queryset=queryset, columns=columns, value=value)


class SearchAbstractStructureClassTestCase(TestCase):
    def test_it_has_method_search(self):
        self.assertTrue(hasattr(SearchAbstract, 'search'))

    def test_search_method_is_callable(self):
        self.assertTrue(callable(getattr(SearchAbstract, 'search')))

    def test_search_method_signature(self):
        expected_signature = ['self', 'queryset', 'columns', 'value']
        actual_signature = inspect.getfullargspec(SearchAbstract.search)[0]
        self.assertEqual(actual_signature, expected_signature)


class SearchProviderStructureClassTestCase(TestCase):
    def test_it_has_method_search(self):
        self.assertTrue(hasattr(SearchProvider, 'search'))

    def test_it_has_method_get_service_class(self):
        self.assertTrue(hasattr(SearchProvider, 'get_service_class'))


class SearchProviderTestCase(TestCase):
    def setUp(self):
        for _ in range(10):
            if _ % 2:
                ChapterFactory(name='name')
            else:
                ChapterFactory(name='x')
        self.queryset = Chapter.objects.all()

    @override_settings(SEARCH_SERVICE_PROVIDER="apps.main.tests.test_search_service.MockSearchProvider")
    def test_it_calls_the_select_service_send(self):
        expected_ids = list(self.queryset.filter(name='name').values_list('pk', flat=True))
        actual_ids = list(
            SearchProvider().search(
                queryset=self.queryset,
                columns=['name'],
                value='name',
            ).values_list('pk', flat=True)
        )

        self.assertEqual(expected_ids, actual_ids)

    def test_it_returns_subclass_of_search_provider_abstract(self):
        class_ = SearchProvider().get_service_class()
        self.assertIsInstance(class_, SearchAbstract)
