from django.test import TestCase
from django.urls import reverse, resolve

from apps.quran.views_admin import BookCreateAndUpdateView, BookDetailsView


class BookUrlsTestCase(TestCase):
    def test_admin_book_create_view_urls_resolves(self):
        url = reverse('admin:books:create')
        self.assertEqual(resolve(url).func.view_class, BookCreateAndUpdateView)

    def test_admin_book_update_view_urls_resolves(self):
        url = reverse('admin:books:update', args=[1])
        self.assertEqual(resolve(url).func.view_class, BookCreateAndUpdateView)

    def test_admin_book_detail_view(self):
        url = reverse('admin:books:details', args=[1])
        self.assertEqual(resolve(url).func.view_class, BookDetailsView)