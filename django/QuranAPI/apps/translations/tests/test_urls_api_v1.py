from django.test import TestCase
from django.urls import reverse, resolve

from apps.translations.views_api_v1 import TranslationsDetailsAPIView, TranslationsListAPIView


class TranslationsAPIUrlsTestCase(TestCase):

    def test_detail_translations_api_url_resolves(self):
        url = reverse('api-v1:translations:details', args=[1])
        self.assertEqual(resolve(url).func.view_class, TranslationsDetailsAPIView)

    def test_translations_listing_view_url_resolves(self):
        url = reverse('api-v1:translations:listing')
        self.assertEqual(resolve(url).func.view_class, TranslationsListAPIView)
