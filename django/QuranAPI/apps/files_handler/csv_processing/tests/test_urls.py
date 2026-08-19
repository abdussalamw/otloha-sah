from django.test import TestCase
from django.urls import reverse, resolve

from apps.files_handler.csv_processing.views import CSVUploadView, CSVListingView, CSVDetailsView, CSVProcessView


class BookUrlsTestCase(TestCase):
    def test_book_csv_listing_view_urls_resolves(self):
        url = reverse('admin:files:csv:listing', args=["quran", "book", 1])
        self.assertEqual(resolve(url).func.view_class, CSVListingView)

    def test_book_csv_details_view_urls_resolves(self):
        url = reverse('admin:files:csv:details', args=['quran', 'book', 1, 1])
        self.assertEqual(resolve(url).func.view_class, CSVDetailsView)

    def test_admin_book_upload_view_urls_resolves(self):
        url = reverse('admin:files:csv:create', args=["test", "test", 1])
        self.assertEqual(resolve(url).func.view_class, CSVUploadView)

    def test_admin_book_csv_process_view_urls_resolves(self):
        url = reverse('admin:files:csv:process', args=['quran', 'book', 1, 1])
        self.assertEqual(resolve(url).func.view_class, CSVProcessView)
