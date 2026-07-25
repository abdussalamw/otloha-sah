from django.test import TestCase
from django.urls import reverse, resolve

from apps.translations.translation_verses.views_api_v1 import TranslationVersesDetailsAPIView, \
    TranslationVersesListAPIView


class TranslationsAPIUrlsTestCase(TestCase):

    def test_detail_translations_api_url_resolves(self):
        url = reverse('api-v1:translations:verses:details', args=[1])
        self.assertEquals(resolve(url).func.view_class, TranslationVersesDetailsAPIView)

    def test_translations_listing_view_url_resolves(self):
        url = reverse('api-v1:translations:verses:listing')
        self.assertEquals(resolve(url).func.view_class, TranslationVersesListAPIView)
