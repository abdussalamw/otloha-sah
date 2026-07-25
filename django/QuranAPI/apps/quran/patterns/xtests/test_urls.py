from django.test import TestCase
from django.urls import reverse, resolve

from apps.quran.images_processing.views import BookImageDetailView, BookImagePatternsView, BookImageUploadView, \
    BookImageListView, BookImagesProcess


class BookImagesUrlsTestCase(TestCase):
    def test_admin_book_images_detail_view(self):
        url = reverse('admin:books:images:details', args=[1, 1])
        self.assertEqual(resolve(url).func.view_class, BookImageDetailView)

    def test_listing_all_book_images_url_resolves(self):
        url = reverse('admin:books:images:listing', args=[1])
        self.assertEqual(resolve(url).func.view_class, BookImageListView)

    def test_book_images_upload_url_resolves(self):
        url = reverse('admin:books:images:upload', args=[1])
        self.assertEqual(resolve(url).func.view_class, BookImageUploadView)

    def test_images_patterns_urls_resolves(self):
        url = reverse('admin:books:images:patterns-upload', args=[1, 1])
        self.assertEqual(resolve(url).func.view_class, BookImagePatternsView)


class BookProcessImagesUrlsTestCase(TestCase):
    def test_process_images_url_resolve(self):
        url = reverse('admin:books:images:process-book', args=[1, 1])
        self.assertEqual(resolve(url).func.view_class, BookImagesProcess)
