import inspect
import os
import shutil

from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.contrib.contenttypes.models import ContentType
from django.core.files.uploadedfile import SimpleUploadedFile
from django.http import HttpResponseNotFound
from django.test import TestCase, Client
from django.test import override_settings
from django.urls import reverse
from django.utils.translation import gettext as _
from django.utils.translation import gettext_lazy as _
from django.views import View

from apps.files_handler.forms import FilesForm
from apps.files_handler.models import File
from apps.files_handler.views import CreateFileView, ProcessFileView
from apps.quran.factories import NarrationFactory, BookFactory
from apps.quran.models import Book
from apps.users.factories import UserFactory

TEST_DIR = 'test_data'


class UploadFileViewStructureTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(isinstance(CreateFileView(), LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(isinstance(CreateFileView(), View))

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(CreateFileView(), 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(CreateFileView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(CreateFileView.get)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_view_has_method_post(self):
        self.assertTrue(hasattr(CreateFileView(), 'post'))

    def test_view_has_method_post_is_callable(self):
        self.assertTrue(callable(CreateFileView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(CreateFileView.post)[0]
        self.assertEquals(actual_signature, expected_signature)


class UploadFileViewGETTestCas(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.book = BookFactory(narration=NarrationFactory())
        self.url = reverse('admin:files:upload', args=['quran', 'book', self.book.pk])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "files_handler/form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_FilesForm(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], FilesForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_upload_new_file(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['title'], _("upload files"))

    def test_context_contains_next(self):
        response = self.client.get(self.url)
        self.assertIn("next", response.context)

    def test_context_contains_back(self):
        response = self.client.get(self.url)
        self.assertIn("back", response.context)


class UploadFileViewPOSTTestCase(TestCase):
    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.book = BookFactory(narration=NarrationFactory())
        self.url = reverse('admin:files:upload', args=['quran', 'book', self.book.pk])

    def tearDown(self):
        try:
            shutil.rmtree(TEST_DIR)
        except OSError:
            pass

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used_on_failure(self):
        response = self.client.post(self.url)
        self.assertTemplateUsed(response, "files_handler/form.html")

    def test_context_contains_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_file_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], FilesForm)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_form_instance_is_new(self):
        response = self.client.post(self.url)
        self.assertEquals(response.context['form'].instance.pk, None)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("title", response.context)

    def test_context_contains_next_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("next", response.context)

    def test_context_contains_back_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("back", response.context)

    def test_context_title_is_upload_new_file_on_failure(self):
        response = self.client.post(self.url)
        self.assertEquals(response.context['title'], _("upload files"))

    def test_it_redirects_to_details_after_submit(self):
        base_path = os.path.dirname(os.path.realpath(__file__))
        file = open(base_path + '/files/001.zip', 'rb')
        response = self.client.post(self.url + '?next=' + reverse('admin:books:listing'),
                                    data={'file': SimpleUploadedFile(content=file.read(), name=file.name,
                                                                     content_type='application/zip')})
        self.assertGreater(File.objects.count(), 0)

    def test_response_contains_success_message(self):
        base_path = os.path.dirname(os.path.realpath(__file__))
        file = open(base_path + '/files/001.zip', 'rb')
        response = self.client.post(self.url + '?next=' + reverse('admin:books:listing'),
                                    data={'file': SimpleUploadedFile(content=file.read(), name=file.name,
                                                                     content_type='application/zip')})
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEquals(len(msgs), 1)

    def test_response_message_is_equal_to_created_successfully(self):
        base_path = os.path.dirname(os.path.realpath(__file__))
        file = open(base_path + '/files/001.zip', 'rb')
        response = self.client.post(self.url + '?next=' + reverse('admin:books:listing'),
                                    data={'file': SimpleUploadedFile(content=file.read(), name=file.name,
                                                                     content_type='application/zip')})
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEquals(str(msgs[0]), _("Files is uploaded successfully"))


class ProcessFileViewStructureTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(isinstance(ProcessFileView(), LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(isinstance(ProcessFileView(), View))

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(ProcessFileView(), 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(ProcessFileView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(ProcessFileView.get)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_view_has_method_post(self):
        self.assertTrue(hasattr(ProcessFileView(), 'post'))

    def test_view_has_method_post_is_callable(self):
        self.assertTrue(callable(ProcessFileView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(ProcessFileView.post)[0]
        self.assertEquals(actual_signature, expected_signature)


class ProcessFileViewGetTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.book = BookFactory(narration=NarrationFactory())
        base_path = os.path.dirname(os.path.realpath(__file__))

        book = BookFactory(narration=NarrationFactory())
        file = open(base_path + '/files/001.zip', 'rb')
        self.file_upload = File.objects.create(content_type=ContentType.objects.get_for_model(Book)
                                               , object_id=book.pk,
                                               file=SimpleUploadedFile(content=file.read(), name=file.name,
                                                                       content_type='multipart/form-data'),
                                               file_name='file')
        self.url = reverse('admin:files:process', args=['quran', 'book', self.book.pk, self.file_upload.pk])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "files_handler/confirm_process.html")

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_contains_next(self):
        response = self.client.get(self.url)
        self.assertIn("next", response.context)

    def test_context_contains_obj(self):
        response = self.client.get(self.url)
        self.assertIn("obj", response.context)

    def test_title_value(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['title'], _('Confirm Process File'))

    def test_next_value_is_correct(self):
        response = self.client.get(self.url + '?next=/some/url/')
        self.assertEquals(response.context['next'], '/some/url/')

    def test_the_object_is_correct(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['obj'], self.file_upload)


class ProcessFileViewViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.book = BookFactory(narration=NarrationFactory())
        base_path = os.path.dirname(os.path.realpath(__file__))

        book = BookFactory(narration=NarrationFactory())
        file = open(base_path + '/files/001.zip', 'rb')
        self.file_upload = File.objects.create(content_type=ContentType.objects.get_for_model(Book)
                                               , object_id=book.pk,
                                               file=SimpleUploadedFile(content=file.read(), name=file.name,
                                                                       content_type='multipart/form-data'),
                                               file_name='file')
        self.url = reverse('admin:files:process', args=['quran', 'book', self.book.pk, self.file_upload.pk])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_if_file_does_not_exists(self):
        response = self.client.post(reverse('admin:files:process', args=['quran', 'book', self.book.pk, 1000]))
        self.assertIsInstance(response, HttpResponseNotFound)
