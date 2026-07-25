from django.test import TestCase
from django.urls import reverse, resolve

from apps.tajweed.rules.views_admin import RulesListingView, RuleCreateAndUpdateView, RuleDetailsView


class RulesAdminUrlsTestCase(TestCase):
    def test_rules_listing_view_url_resolves(self):
        url = reverse('admin:tajweed:rules:listing')
        self.assertEquals(resolve(url).func.view_class, RulesListingView)

    def test_details_rules_admin_url_resolves(self):
        url = reverse('admin:tajweed:rules:details', args=[1])
        self.assertEquals(resolve(url).func.view_class, RuleDetailsView)

    def test_rules_create_view_url_resolves(self):
        url = reverse('admin:tajweed:rules:create')
        self.assertEquals(resolve(url).func.view_class, RuleCreateAndUpdateView)

    def test_rules_update_view_url_resolves(self):
        url = reverse('admin:tajweed:rules:update', args=[1])
        self.assertEquals(resolve(url).func.view_class, RuleCreateAndUpdateView)