from django.test import TestCase
from django.urls import reverse, resolve

from apps.explanations.views_api_v1 import ExplanationListingView, ExplanationDetailsView


class ExplanationsAPIUrlsTestCase(TestCase):

    def test_explanations_listing_view_url_resolves(self):
        url = reverse('api-v1:explanations:listing')
        self.assertEquals(resolve(url).func.view_class, ExplanationListingView)

    def test_detail_explanations_api_url_resolves(self):
        url = reverse('api-v1:explanations:details', args=[1])
        self.assertEquals(resolve(url).func.view_class, ExplanationDetailsView)
