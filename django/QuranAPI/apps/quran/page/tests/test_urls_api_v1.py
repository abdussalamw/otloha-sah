from django.test import TestCase
from django.urls import reverse, resolve

from apps.quran.page.views_api_v1 import PagesListOrDownloadAPIView, PagesDetailAPIView


class PageAPIUrlsTestCase(TestCase):
    def test_listing_all_pages_api_url_resolves(self):
        url = reverse('api-v1:pages:list')
        self.assertEqual(resolve(url).func.view_class, PagesListOrDownloadAPIView)

    def test_detail_page_api_url_resolves(self):
        url = reverse('api-v1:pages:details', args=[1])
        self.assertEqual(resolve(url).func.view_class, PagesDetailAPIView)
