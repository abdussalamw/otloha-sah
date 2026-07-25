from django.test import TestCase
from django.urls import reverse, resolve

from apps.translations.views_admin import TranslationDetailAdminView, \
    TranslationListAdminView, TranslationCreateAndUpdateView


class TranslationAdminUrlsTestCase(TestCase):
    def test_listing_all_translation_admin_url_resolves(self):
        url = reverse('admin:translations:listing')
        self.assertEquals(resolve(url).func.view_class, TranslationListAdminView)

    def test_detail_translation_admin_url_resolves(self):
        url = reverse('admin:translations:detail', args=[1])
        self.assertEquals(resolve(url).func.view_class, TranslationDetailAdminView)

    def test_listing_all_translations_admin_url_resolves(self):
        url = reverse('admin:translations:create')
        self.assertEquals(resolve(url).func.view_class, TranslationCreateAndUpdateView)

    def test_detail_translations_admin_url_resolves(self):
        url = reverse('admin:translations:update', args=[1])
        self.assertEquals(resolve(url).func.view_class, TranslationCreateAndUpdateView)
