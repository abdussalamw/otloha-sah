from django.test import TestCase
from django.urls import reverse, resolve

from apps.quran.page.verse.views_admin import VerseListAdminView


class VerseAdminUrlsTestCase(TestCase):
    def test_listing_all_verses_admin_url_resolves(self):
        url = reverse('admin:books:verses:list', args=[1])
        self.assertEquals(resolve(url).func.view_class, VerseListAdminView)
