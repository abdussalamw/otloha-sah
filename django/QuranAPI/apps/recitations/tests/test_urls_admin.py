from django.test import TestCase
from django.urls import reverse, resolve

from apps.recitations.views_admin import RecitationDetailAdminView, \
    RecitationListAdminView, RecitationCreateAndUpdateView


class RecitationAdminUrlsTestCase(TestCase):
    def test_listing_all_recitation_admin_url_resolves(self):
        url = reverse('admin:recitations:listing')
        self.assertEqual(resolve(url).func.view_class, RecitationListAdminView)

    def test_detail_recitation_admin_url_resolves(self):
        url = reverse('admin:recitations:details', args=[1])
        self.assertEqual(resolve(url).func.view_class, RecitationDetailAdminView)

    def test_listing_all_recitations_admin_url_resolves(self):
        url = reverse('admin:recitations:create')
        self.assertEqual(resolve(url).func.view_class, RecitationCreateAndUpdateView)

    def test_detail_recitations_admin_url_resolves(self):
        url = reverse('admin:recitations:update', args=[1])
        self.assertEqual(resolve(url).func.view_class, RecitationCreateAndUpdateView)
