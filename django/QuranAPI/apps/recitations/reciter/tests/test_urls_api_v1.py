from django.test import TestCase
from django.urls import reverse, resolve

from apps.recitations.reciter.views_api_v1 import RecitersDetailsAPIView, RecitersListAPIView


class RecitersAPIUrlsTestCase(TestCase):

    def test_detail_reciters_api_url_resolves(self):
        url = reverse('api-v1:reciters:details', args=[1])
        self.assertEquals(resolve(url).func.view_class, RecitersDetailsAPIView)

    def test_reciters_listing_view_url_resolves(self):
        url = reverse('api-v1:reciters:listing')
        self.assertEquals(resolve(url).func.view_class, RecitersListAPIView)
