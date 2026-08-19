from django.test import TestCase
from django.urls import reverse, resolve

from apps.recitations.recitation_verse.views_admin import RecitationVerseListAdminView


class RecitationVerseAdminUrlsTestCase(TestCase):
    def test_recitation_verse_admin_listing(self):
        url = reverse('admin:recitations:recitation-verses:list')
        self.assertEqual(resolve(url).func.view_class, RecitationVerseListAdminView)
