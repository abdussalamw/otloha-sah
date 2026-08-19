import shutil

from django.contrib.auth.mixins import LoginRequiredMixin
from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import Client, TestCase, override_settings
from django.urls import reverse
from django.views import View

from apps.files_handler.forms import FilesForm
from apps.files_handler.models import File
from apps.files_handler.views import CreateFileView, ProcessFileView
from apps.narrations.factories import NarrationFactory
from apps.quran.factories import BookFactory
from apps.users.factories import UserFactory

TEST_DIR = 'test_data'


class CreateFileViewStructureTestCase(TestCase):
    def test_uses_login_protection_and_a_standard_view(self):
        self.assertIsInstance(CreateFileView(), LoginRequiredMixin)
        self.assertIsInstance(CreateFileView(), View)
        self.assertTrue(callable(CreateFileView.get))
        self.assertTrue(callable(CreateFileView.post))


class CreateFileViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        self.url = reverse('admin:files:create', args=['quran', 'book', self.book.pk, 'pages'])

    def test_redirects_an_anonymous_user_to_login(self):
        response = self.client.get(self.url)

        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_renders_a_form_for_an_authenticated_user(self):
        self.client.login(email=self.user.email, password='secret')
        response = self.client.get(self.url + '?next=/admin/books/')

        self.assertEqual(200, response.status_code)
        self.assertTemplateUsed(response, 'files_handler/form.html')
        self.assertIsInstance(response.context['form'], FilesForm)
        self.assertEqual('Upload New ZIP File', str(response.context['title']))


class ProcessFileViewStructureTestCase(TestCase):
    def test_uses_login_protection_and_a_standard_view(self):
        self.assertIsInstance(ProcessFileView(), LoginRequiredMixin)
        self.assertIsInstance(ProcessFileView(), View)
        self.assertTrue(callable(ProcessFileView.get))
        self.assertTrue(callable(ProcessFileView.post))


class ProcessFileViewTestCase(TestCase):
    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        self.file_upload = File.objects.create(
            content_object=self.book,
            process_type='import_zip',
            process_name='pages',
            file_name='pages.zip',
            file=SimpleUploadedFile(
                name='pages.zip',
                content=b'PK\x03\x04',
                content_type='application/zip',
            ),
        )
        self.url = reverse(
            'admin:files:process',
            args=['quran', 'book', self.book.pk, 'pages', self.file_upload.pk],
        )

    def tearDown(self):
        shutil.rmtree(TEST_DIR, ignore_errors=True)

    def test_redirects_an_anonymous_user_to_login(self):
        response = self.client.get(self.url)

        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_renders_confirmation_for_an_authenticated_user(self):
        self.client.login(email=self.user.email, password='secret')
        response = self.client.get(self.url + '?next=/admin/books/')

        self.assertEqual(200, response.status_code)
        self.assertTemplateUsed(response, 'files_handler/confirm_process.html')
        self.assertEqual('/admin/books/', response.context['next'])
        self.assertEqual(self.book, response.context['instance'])

    def test_returns_404_for_a_missing_file(self):
        self.client.login(email=self.user.email, password='secret')
        missing_url = reverse(
            'admin:files:process',
            args=['quran', 'book', self.book.pk, 'pages', 999999],
        )

        response = self.client.get(missing_url + '?next=/admin/books/')

        self.assertEqual(404, response.status_code)
