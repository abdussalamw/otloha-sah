from django.test import TestCase
from django.urls import reverse, resolve

from apps.explanations.explanation_verse.views_admin import ExplanationVerseListingView


class ExplanationVerseListingViewAdminUrlsTestCase(TestCase):
    def test_explanation_verses_listing_view_url_resolves(self):
        url = reverse('admin:explanations:verses:listing', args=[1])
        self.assertEqual(resolve(url).func.view_class, ExplanationVerseListingView)
