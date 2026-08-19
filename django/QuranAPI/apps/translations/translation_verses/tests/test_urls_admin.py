from django.test import TestCase
from django.urls import reverse, resolve

from apps.translations.translation_verses.views_admin import TranslationVersesListAdminView


class TranslationVerseAdminUrlsTestCase(TestCase):
    def test_listing_all_translation_verses_admin_url_resolves(self):
        url = reverse('admin:translations:verses:listing', args=[1])
        self.assertEqual(resolve(url).func.view_class, TranslationVersesListAdminView)