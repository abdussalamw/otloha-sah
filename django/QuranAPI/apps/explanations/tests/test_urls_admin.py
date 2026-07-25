from django.test import TestCase
from django.urls import reverse, resolve

from apps.explanations.views_admin import ExplanationListingView, ExplanationCreateAndUpdateView, ExplanationDetailsView


class ExplanationsAdminUrlsTestCase(TestCase):
    def test_explanations_listing_view_url_resolves(self):
        url = reverse('admin:explanations:listing')
        self.assertEquals(resolve(url).func.view_class, ExplanationListingView)

    def test_detail_explanations_admin_url_resolves(self):
        url = reverse('admin:explanations:details', args=[1])
        self.assertEquals(resolve(url).func.view_class, ExplanationDetailsView)

    def test_explanations_create_view_url_resolves(self):
        url = reverse('admin:explanations:create')
        self.assertEquals(resolve(url).func.view_class, ExplanationCreateAndUpdateView)

    def test_explanations_update_view_url_resolves(self):
        url = reverse('admin:explanations:update', args=[1])
        self.assertEquals(resolve(url).func.view_class, ExplanationCreateAndUpdateView)