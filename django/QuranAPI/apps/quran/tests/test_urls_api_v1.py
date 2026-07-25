from django.test import TestCase
from django.urls import reverse, resolve

from apps.quran.views_api_v1 import BooksListAPIView, BookDetailsAPIView


class BookUrlsTestCase(TestCase):
    def test_listing_all_books_api_url_resolves(self):
        url = reverse('api-v1:books:list')
        self.assertEqual(resolve(url).func.view_class, BooksListAPIView)

    def test_book_details_api_url_resolves(self):
        url = reverse('api-v1:books:details', args=[1])
        self.assertEquals(resolve(url).func.view_class, BookDetailsAPIView)
