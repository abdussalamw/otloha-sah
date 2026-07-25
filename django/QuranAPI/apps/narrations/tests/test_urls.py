from django.test import TestCase
from django.urls import reverse, resolve

import apps.narrations.urls_admin as urls_admin
import apps.narrations.urls_api_v1 as urls_api_v1
from apps.narrations.views_admin import NarrationListingView, NarrationCreateAndUpdateAdminView
from apps.narrations.views_api_v1 import NarrationsListView, NarrationsDetailView


class NarrationAPIUrlsStructureTestCase(TestCase):
    def test_it_has_app_name(self):
        self.assertTrue(hasattr(urls_api_v1, 'app_name'))

    def test_it_has_app_name_equals_chapters(self):
        self.assertEqual(urls_api_v1.app_name, 'narrations')

    def test_it_has_urlpatterns(self):
        self.assertTrue(hasattr(urls_api_v1, 'urlpatterns'))

    def test_urlpatterns_is_a_list(self):
        self.assertTrue(isinstance(urls_api_v1.urlpatterns, list))

class NarrationAPIUrlsTestCase(TestCase):
    def test_listing_all_narrations_api_url_resolves(self):
        url = reverse('api-v1:narrations:listing')
        self.assertEqual(resolve(url).func.view_class, NarrationsListView)

    def test_detail_narration_api_url_resolves(self):
        url = reverse('api-v1:narrations:details', args=[1])
        self.assertEquals(resolve(url).func.view_class, NarrationsDetailView)

class NarrationAdminUrlsStructureTestCase(TestCase):
    def test_it_has_app_name(self):
        self.assertTrue(hasattr(urls_admin, 'app_name'))

    def test_it_has_app_name_equals_chapters(self):
        self.assertEqual(urls_admin.app_name, 'narrations')

    def test_it_has_urlpatterns(self):
        self.assertTrue(hasattr(urls_admin, 'urlpatterns'))

    def test_urlpatterns_is_a_list(self):
        self.assertTrue(isinstance(urls_admin.urlpatterns, list))

class NarrationAdminUrlsTestCase(TestCase):
    def test_listing_url_resolves(self):
        url = reverse('admin:narrations:listing')
        self.assertEqual(resolve(url).func.view_class, NarrationListingView)

    def test_create_url_resolves(self):
        url = reverse('admin:narrations:create')
        self.assertEqual(resolve(url).func.view_class, NarrationCreateAndUpdateAdminView)

    def test_update_url_resolves(self):
        url = reverse('admin:narrations:update', args=[1])
        self.assertEqual(resolve(url).func.view_class, NarrationCreateAndUpdateAdminView)
