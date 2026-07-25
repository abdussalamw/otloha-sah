from django.test import TestCase
from django.urls import reverse, resolve

from apps.tajweed.books.views_api_v1 import BooksListAPIView, BooksDetailsAPIView


class BooksAPIUrlsTestCase(TestCase):

    def test_books_listing_view_url_resolves(self):
        url = reverse('api-v1:tajweed:books:listing')
        self.assertEquals(resolve(url).func.view_class, BooksListAPIView)

    def test_detail_books_api_url_resolves(self):
        url = reverse('api-v1:tajweed:books:details', args=[1])
        self.assertEquals(resolve(url).func.view_class, BooksDetailsAPIView)
