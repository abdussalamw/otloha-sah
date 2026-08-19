from django.test import TestCase
from django.urls import reverse, resolve

import apps.chapters.urls_admin as urls_admin
import apps.chapters.urls_api_v1 as urls_api_v1
from apps.chapters.views_admin import ChapterListingAdminView, ChapterCreateAndUpdateAdminView
from apps.chapters.views_api_v1 import ChaptersListAPIView, ChaptersDetailAPIView


class ChaptersAPIUrlsStructureTestCase(TestCase):
    def test_it_has_app_name(self):
        self.assertTrue(hasattr(urls_api_v1, 'app_name'))

    def test_it_has_app_name_equals_chapters(self):
        self.assertEqual(urls_api_v1.app_name, 'chapters')

    def test_it_has_urlpatterns(self):
        self.assertTrue(hasattr(urls_api_v1, 'urlpatterns'))

    def test_urlpatterns_is_a_list(self):
        self.assertTrue(isinstance(urls_api_v1.urlpatterns, list))

class ChaptersAPIUrlsTestCase(TestCase):
    def test_listing_all_chapter_api_url_resolves(self):
        url = reverse('api-v1:chapters:listing')
        self.assertEqual(resolve(url).func.view_class, ChaptersListAPIView)

    def test_detail_chapter_api_url_resolves(self):
        url = reverse('api-v1:chapters:details', args=[1])
        self.assertEqual(resolve(url).func.view_class, ChaptersDetailAPIView)

class ChaptersAdminUrlsStructureTestCase(TestCase):
    def test_it_has_app_name(self):
        self.assertTrue(hasattr(urls_admin, 'app_name'))

    def test_it_has_app_name_equals_chapters(self):
        self.assertEqual(urls_admin.app_name, 'chapters')

    def test_it_has_urlpatterns(self):
        self.assertTrue(hasattr(urls_admin, 'urlpatterns'))

    def test_urlpatterns_is_a_list(self):
        self.assertTrue(isinstance(urls_admin.urlpatterns, list))

class ChaptersAdminUrlsTestCase(TestCase):
    def test_listing_view_url_resolves(self):
        url = reverse('admin:chapters:listing')
        self.assertEqual(resolve(url).func.view_class, ChapterListingAdminView)

    def test_create_view_resolves(self):
        url = reverse('admin:chapters:create')
        self.assertEqual(resolve(url).func.view_class, ChapterCreateAndUpdateAdminView)

    def test_update_view_resolves(self):
        url = reverse('admin:chapters:update', args=[1])
        self.assertEqual(resolve(url).func.view_class, ChapterCreateAndUpdateAdminView)
