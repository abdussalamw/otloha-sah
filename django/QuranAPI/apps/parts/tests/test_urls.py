from django.test import TestCase
from django.urls import resolve

import apps.parts.urls_admin as urls_admin
import apps.parts.urls_api_v1 as urls_api_v1
from apps.parts.views_admin import *
from apps.parts.views_api_v1 import PartsListAPIView, PartDetailAPIView


class PartApiUrlsStructureTestCase(TestCase):
    def test_it_has_app_name(self):
        self.assertTrue(hasattr(urls_api_v1, 'app_name'))

    def test_it_has_app_name_equals_chapters(self):
        self.assertEqual(urls_api_v1.app_name, 'parts')

    def test_it_has_urlpatterns(self):
        self.assertTrue(hasattr(urls_api_v1, 'urlpatterns'))

    def test_urlpatterns_is_a_list(self):
        self.assertTrue(isinstance(urls_api_v1.urlpatterns, list))

class PartApiUrlsTestCase(TestCase):
    def test_listing_all_parts_api_url_resolves(self):
        url = reverse('api-v1:parts:listing')
        self.assertEqual(resolve(url).func.view_class, PartsListAPIView)

    def test_detail_chapter_api_url_resolves(self):
        url = reverse('api-v1:parts:details', args=[1])
        self.assertEqual(resolve(url).func.view_class, PartDetailAPIView)

class PartsAdminUrlsStructureTestCase(TestCase):
    def test_it_has_app_name(self):
        self.assertTrue(hasattr(urls_admin, 'app_name'))

    def test_it_has_app_name_equals_chapters(self):
        self.assertEqual(urls_admin.app_name, 'parts')

    def test_it_has_urlpatterns(self):
        self.assertTrue(hasattr(urls_admin, 'urlpatterns'))

    def test_urlpatterns_is_a_list(self):
        self.assertTrue(isinstance(urls_admin.urlpatterns, list))

class PartsAdminUrlsTestCase(TestCase):
    def test_admin_listing_url_resolves(self):
        url = reverse('admin:parts:listing')
        self.assertEqual(resolve(url).func.view_class, PartListingAdminView)

    def test_admin_create_url_resolves(self):
        url = reverse('admin:parts:create')
        self.assertEqual(resolve(url).func.view_class, PartCreateAndUpdateAdminView)

    def test_admin_update_url_resolves(self):
        url = reverse('admin:parts:update', args=[1])
        self.assertEqual(resolve(url).func.view_class, PartCreateAndUpdateAdminView)
