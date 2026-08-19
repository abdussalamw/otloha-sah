from django.test import TestCase
from django.urls import reverse, resolve

from apps.recitations.reciter.views_admin import ReciterListAdminView, ReciterDetailsView, \
    ReciterCreateOrUpdateView


class ReciterAdminUrlsTestCase(TestCase):
    def test_listing_all_reciters_admin_url_resolves(self):
        url = reverse('admin:recitations:reciters:listing')
        self.assertEqual(resolve(url).func.view_class, ReciterListAdminView)

    def test_detail_reciters_admin_url_resolves(self):
        url = reverse('admin:recitations:reciters:details', args=[1])
        self.assertEqual(resolve(url).func.view_class, ReciterDetailsView)

    def test_create_all_recitations_admin_url_resolves(self):
        url = reverse('admin:recitations:reciters:create')
        self.assertEqual(resolve(url).func.view_class, ReciterCreateOrUpdateView)

    def test_update_recitations_admin_url_resolves(self):
        url = reverse('admin:recitations:reciters:update', args=[1])
        self.assertEqual(resolve(url).func.view_class, ReciterCreateOrUpdateView)
