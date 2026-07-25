from django.test import TestCase
from django.urls import reverse, resolve

from apps.tajweed.verses.views_admin import VersesListingView, VerseDetailsView, VerseUpdateView


class VersesAdminUrlsTestCase(TestCase):

    def test_verses_listing_view_url_resolves(self):
        url = reverse('admin:tajweed:verses:listing', args=[1])
        self.assertEquals(resolve(url).func.view_class, VersesListingView)

    def test_detail_verses_admin_url_resolves(self):
        url = reverse('admin:tajweed:verses:details', args=[1])
        self.assertEquals(resolve(url).func.view_class, VerseDetailsView)

    def test_verses_update_view_url_resolves(self):
        url = reverse('admin:tajweed:verses:update', args=[1])
        self.assertEquals(resolve(url).func.view_class, VerseUpdateView)
