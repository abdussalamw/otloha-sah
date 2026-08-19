from django.test import TestCase
from django.urls import reverse, resolve

from apps.tajweed.books.views_admin import BookListingView, BookCreateAndUpdateView, BookDetailsView


class BooksAdminUrlsTestCase(TestCase):

    def test_books_listing_view_url_resolves(self):
        url = reverse('admin:tajweed:books:listing')
        self.assertEqual(resolve(url).func.view_class, BookListingView)

    def test_detail_books_admin_url_resolves(self):
        url = reverse('admin:tajweed:books:details', args=[1])
        self.assertEqual(resolve(url).func.view_class, BookDetailsView)

    def test_books_create_view_url_resolves(self):
        url = reverse('admin:tajweed:books:create')
        self.assertEqual(resolve(url).func.view_class, BookCreateAndUpdateView)

    def test_books_update_view_url_resolves(self):
        url = reverse('admin:tajweed:books:update', args=[1])
        self.assertEqual(resolve(url).func.view_class, BookCreateAndUpdateView)