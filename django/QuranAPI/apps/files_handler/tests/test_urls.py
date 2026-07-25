from django.test import TestCase
from django.urls import reverse, resolve

from apps.files_handler.views import FileListingView, CreateFileView, ProcessFileView


class FilesUrlsTestCase(TestCase):
    def test_files_listing_view_urls_resolves(self):
        url = reverse('admin:files:listing', args=['app', 'model', 1])
        self.assertEqual(resolve(url).func.view_class, FileListingView)

    def test_files_upload_view_urls(self):
        url = reverse('admin:files:upload', args=['app', 'model', 1])
        self.assertEqual(resolve(url).func.view_class, CreateFileView)

    def test_files_process_view_urls(self):
        url = reverse('admin:files:process', args=['app', 'model', 1, 1])
        self.assertEqual(resolve(url).func.view_class, ProcessFileView)
