from django.test import TestCase
from django.urls import reverse, resolve

from apps.quran.page.views_admin import PageListAdminView, PageDetailsView


class AdminUrlsTestCase(TestCase):
    def test_listing_url_resolves(self):
        url = reverse('admin:books:pages:listing', args=[1])
        self.assertEqual(resolve(url).func.view_class, PageListAdminView)

    def test_detail_page_api_url_resolves(self):
        url = reverse('admin:books:pages:details', args=[1, 1])
        self.assertEqual(resolve(url).func.view_class, PageDetailsView)