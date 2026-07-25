from django.test import TestCase
from django.urls import reverse, resolve

from apps.tajweed.rules.views_api_v1 import RulesListingAPIView, RuleDetailsAPIView


class RulesAPIUrlsTestCase(TestCase):
    def test_rules_listing_view_url_resolves(self):
        url = reverse('api-v1:tajweed:rules:listing')
        self.assertEquals(resolve(url).func.view_class, RulesListingAPIView)

    def test_details_rules_api_url_resolves(self):
        url = reverse('api-v1:tajweed:rules:details', args=[1])
        self.assertEquals(resolve(url).func.view_class, RuleDetailsAPIView)

