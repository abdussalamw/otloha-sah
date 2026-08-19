from django.test import TestCase
from django.urls import reverse, resolve

from apps.recitations.views_api_v1 import RecitationListAPIView, RecitationDetailsView


class RecitationAPIUrlsTestCase(TestCase):
    def test_recitation_listing_view_url_resolves(self):
        url = reverse('api-v1:recitations:list-recitations')
        self.assertEqual(resolve(url).func.view_class, RecitationListAPIView)

    def test_recitation_details_view_url_resolves(self):
        url = reverse('api-v1:recitations:details', args=[1])
        self.assertEqual(resolve(url).func.view_class, RecitationDetailsView)
