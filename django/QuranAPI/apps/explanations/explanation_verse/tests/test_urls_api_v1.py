from django.test import TestCase
from django.urls import reverse, resolve

from apps.explanations.explanation_verse.views_api_v1 import ExplanationVerseListingView, ExplanationVerseDetailsView


class ExplanationVersesAPIUrlsTestCase(TestCase):

    def test_explanation_verses_listing_view_url_resolves(self):
        url = reverse('api-v1:explanations:verses:listing')
        self.assertEquals(resolve(url).func.view_class, ExplanationVerseListingView)

    def test_details_explanations_api_url_resolves(self):
        url = reverse('api-v1:explanations:verses:details', args=[1])
        self.assertEquals(resolve(url).func.view_class,ExplanationVerseDetailsView)