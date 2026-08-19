from django.test import TestCase
from django.urls import reverse, resolve

from apps.recitations.recitation_verse.views_api_v1 import RecitationVerseListingView, RecitationVerseDetailsView


class RecitationVerseAPIUrlsTestCase(TestCase):
    def test_recitation_verse_api_listing(self):
        url = reverse('api-v1:recitations:recitation-verses:listing')
        self.assertEqual(resolve(url).func.view_class, RecitationVerseListingView)

    def test_recitation_verse_api_details(self):
        url = reverse('api-v1:recitations:recitation-verses:details')
        self.assertEqual(resolve(url).func.view_class, RecitationVerseDetailsView)


