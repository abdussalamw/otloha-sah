from django.test import TestCase
from django.urls import reverse, resolve

from apps.narrations.verses.views_admin import VerseListAdminView


class VerseAdminUrlsTestCase(TestCase):
    def test_listing_all_verses_admin_url_resolves(self):
        url = reverse('admin:narrations:verses:listing', args=[1])
        self.assertEquals(resolve(url).func.view_class, VerseListAdminView)
