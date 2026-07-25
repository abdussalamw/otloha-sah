import inspect
import os
import shutil

from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import TestCase, Client
from django.test import override_settings
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View
from rest_framework.test import APIClient

from apps.files_handler.csv_processing.forms import CSVUploadForm, ProcessCSVForm
from apps.files_handler.csv_processing.views import CSVListingView, CSVUploadView, CSVDetailsView, \
    BookCSVProcessView
from apps.files_handler.models import File
from apps.main.views_admin import AdminListView
from apps.quran.factories import NarrationFactory, BookFactory, BookCSVFactory
from apps.users.factories import UserFactory

TEST_DIR = 'test_data'


class CSVUploadViewStructureTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(isinstance(CSVUploadView(), LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(isinstance(CSVUploadView(), View))

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(CSVUploadView(), 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(CSVUploadView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', "book_id"]
        actual_signature = inspect.getfullargspec(CSVUploadView.get)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_view_has_method_post(self):
        self.assertTrue(hasattr(CSVUploadView(), 'post'))

    def test_view_has_method_post_is_callable(self):
        self.assertTrue(callable(CSVUploadView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request', "book_id"]
        actual_signature = inspect.getfullargspec(CSVUploadView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class CSVUploadViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:files:csv:create', args=[self.book.id])
        print(self.url)

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_404_if_book_not_found(self):
        response = self.client.get(reverse("admin:files:csv:create", args=[200]))
        self.assertEquals(response.status_code, 404)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "quran/book/csv/upload_form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_CSVUploadForm(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], CSVUploadForm)

    def test_context_form_is_new_form(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['form'].instance.pk, None)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_upload_new_file(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['title'], _("Upload New CSV"))

    def test_context_contains_book(self):
        response = self.client.get(self.url)
        self.assertIn("book", response.context)

    def test_context_book_is_correct(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['book'], self.book)


class CSVUploadViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:files:csv:create', args=[self.book.id])
        self.data = {"file": SimpleUploadedFile("file.csv", b"a,b,c", 'text/csv')}

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_404_if_book_not_found(self):
        response = self.client.post(reverse("admin:books:csv:create", args=[200]))
        self.assertEquals(response.status_code, 404)

    def test_template_used_on_failure(self):
        response = self.client.post(self.url)
        self.assertTemplateUsed(response, "quran/book/csv/upload_form.html")

    def test_context_contains_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_csv_upload_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], CSVUploadForm)

    def test_context_form_is_instance_of_book_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], CSVUploadForm)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_form_instance_is_new(self):
        response = self.client.post(self.url)
        self.assertEquals(response.context['form'].instance.pk, None)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_upload_new_file_on_failure(self):
        response = self.client.post(self.url)
        self.assertEquals(response.context['title'], _("Upload New CSV"))

    def test_context_contains_book_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("book", response.context)

    def test_context_book_is_correct_on_failure(self):
        response = self.client.post(self.url)
        self.assertEquals(response.context['book'], self.book)

    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def test_it_redirects_to_details_after_submit(self):
        response = self.client.post(self.url, self.data)
        file = File.objects.all().first()
        self.assertRedirects(response, reverse("admin:files:csv:details",
                                               args=[self.book.id, file.pk]), fetch_redirect_response=False)

    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEquals(len(msgs), 1)

    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def test_response_message_is_equal_to_created_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEquals(str(msgs[0]), _("CSV Uploaded Successfully"))


class CSVListingViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:files:csv:listing', args=[1])

    def test_view_extend_login_required_mixin_class(self):
        self.assertIsInstance(CSVListingView(), LoginRequiredMixin)

    def test_view_extend_admin_list_view_class(self):
        self.assertIsInstance(CSVListingView(), AdminListView)

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(CSVListingView, 'model'))

    def test_it_uses_book_csv_model(self):
        self.assertEqual(CSVListingView.model, File)

    def test_list_view_has_filterset_class(self):
        self.assertTrue(hasattr(CSVListingView, 'filterset_class'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(CSVListingView, 'list_display'))

    def test_book_csv_upload_has_load_created_at_attribute(self):
        self.assertTrue(hasattr(CSVListingView, 'load_created_at'))

    def test_book_csv_upload_has_load_file_attribute(self):
        self.assertTrue(hasattr(CSVListingView, 'load_file'))

    def test_narration_has_load_updated_at_attribute(self):
        self.assertTrue(hasattr(CSVListingView, 'get_actions'))

    def test_load_updated_at_is_callable(self):
        self.assertTrue(callable(getattr(CSVListingView, 'get_actions')))

    def test_narration_has_load_actions(self):
        self.assertTrue(hasattr(CSVListingView, 'load_actions'))

    def test_load_actions_is_callable(self):
        self.assertTrue(callable(getattr(CSVListingView, 'load_actions')))


class CSVDetailsViewTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(isinstance(CSVDetailsView(), LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(isinstance(CSVDetailsView(), View))

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(CSVDetailsView(), 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(CSVDetailsView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', "book_id", "book_csv_id"]
        actual_signature = inspect.getfullargspec(CSVDetailsView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class CSVDetailsViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        base_path = os.path.dirname(os.path.realpath(__file__))
        data = open(base_path + '/sample.csv', 'rb')
        file = SimpleUploadedFile(content=data.read(), name=data.name, content_type='multipart/form-data')
        self.book_csv_upload = BookCSVFactory(book=self.book, file=file)
        self.url = reverse('admin:books:csv:details', args=[self.book.pk, self.book_csv_upload.pk])
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_404_if_book_is_not_found(self):
        response = self.client.get(reverse('admin:books:csv:details', args=[2, 10]))
        self.assertEqual(response.status_code, 404)

    def test_it_returns_404_if_book_csv_is_not_found(self):
        response = self.client.get(reverse('admin:books:csv:details', args=[self.book.id, 10]))
        self.assertEqual(response.status_code, 404)

    def test_it_uses_correct_template(self):
        response = self.client.get(reverse('admin:books:csv:details', args=[self.book.id, self.book_csv_upload.id]))
        self.assertTemplateUsed(response, 'quran/book/csv/details.html')

    def test_context_contains_book_instance(self):
        response = self.client.get(reverse('admin:books:csv:details', args=[self.book.id, self.book_csv_upload.id]))
        self.assertIn('book', response.context)

    def test_context_book_instance_is_correct(self):
        response = self.client.get(reverse('admin:books:csv:details', args=[self.book.id, self.book_csv_upload.id]))
        self.assertEquals(response.context['book'], self.book)

    def test_context_contains_book_csv_instance(self):
        response = self.client.get(reverse('admin:books:csv:details', args=[self.book.id, self.book_csv_upload.id]))
        self.assertIn('book_csv', response.context)

    def test_context_book_csv_instance_is_correct(self):
        response = self.client.get(reverse('admin:books:csv:details', args=[self.book.id, self.book_csv_upload.id]))
        self.assertEquals(response.context['book_csv'], self.book_csv_upload)

    def test_context_contains_title(self):
        response = self.client.get(reverse('admin:books:csv:details', args=[self.book.id, self.book_csv_upload.id]))
        self.assertIn('title', response.context)

    def test_context_title_is_correct(self):
        response = self.client.get(reverse('admin:books:csv:details', args=[self.book.id, self.book_csv_upload.id]))
        self.assertEquals(response.context['title'], _("Book CSV Details"))


class BookCSVProcessViewTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(isinstance(BookCSVProcessView(), LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(isinstance(BookCSVProcessView(), View))

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(BookCSVProcessView(), 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(BookCSVProcessView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', "book_id", "book_csv_id"]
        actual_signature = inspect.getfullargspec(BookCSVProcessView.get)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_view_has_method_post(self):
        self.assertTrue(hasattr(BookCSVProcessView(), 'post'))

    def test_view_has_method_post_is_callable(self):
        self.assertTrue(callable(BookCSVProcessView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request', "book_id", "book_csv_id"]
        actual_signature = inspect.getfullargspec(BookCSVProcessView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class BookCSVProcessViewGETTestCase(TestCase):
    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.book = BookFactory(narration=NarrationFactory())
        self.book_csv = BookCSVFactory(book=self.book)
        self.url = reverse('admin:books:csv:process', args=[self.book.id, self.book_csv.pk])

    def tearDown(self):
        try:
            shutil.rmtree(TEST_DIR)
        except OSError:
            pass

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_404_if_book_not_found(self):
        response = self.client.get(reverse('admin:books:csv:process', args=[10, 12]))
        self.assertEquals(response.status_code, 404)

    def test_it_return_404_if_book_csv_not_found(self):
        response = self.client.get(reverse('admin:books:csv:process', args=[self.book.id, 12]))
        self.assertEquals(response.status_code, 404)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "quran/book/csv/process_file.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_process_book_csv_form(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], ProcessCSVForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_test_context_title_is_process_csv(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['title'], _("Prepare CSV for Processing"))

    def test_context_contains_book(self):
        response = self.client.get(self.url)
        self.assertIn("book", response.context)

    def test_context_book_is_correct(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['book'], self.book)

    def test_context_contains_book_csv(self):
        response = self.client.get(self.url)
        self.assertIn("book_csv", response.context)

    def test_context_book_csv_is_correct(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['book_csv'], self.book_csv)


class BookCSVProcessViewPOSTTestCase(TestCase):
    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.book = BookFactory(narration=NarrationFactory())
        self.book_csv = BookCSVFactory(book=self.book)
        self.url = reverse('admin:books:csv:process', args=[self.book.id, self.book_csv.pk])
        self.data = {
            "line_start": 0,
            "line_end": 1,
            "part": 2,
            "text": 3,
            "uthmanic_text": 4,
            "verse_number": 5,
            "chapter": 7,
            "page": 8,
        }

    def tearDown(self):
        try:
            shutil.rmtree(TEST_DIR)
        except OSError:
            pass

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_404_if_book_not_found(self):
        response = self.client.post(reverse('admin:books:csv:process', args=[10, 12]))
        self.assertEquals(response.status_code, 404)

    def test_it_return_404_if_book_csv_not_found(self):
        response = self.client.post(reverse('admin:books:csv:process', args=[self.book.id, 12]))
        self.assertEquals(response.status_code, 404)

    def test_template_used_on_failure(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "quran/book/csv/process_file.html")

    def test_context_contains_form_on_failure(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_context_form_is_instance_of_process_book_csv_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], ProcessCSVForm)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_process_csv_on_failure(self):
        response = self.client.post(self.url)
        self.assertEquals(response.context['title'], _("Prepare CSV for Processing"))

    def test_context_contains_book_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("book", response.context)

    def test_context_book_is_correct_on_failure(self):
        response = self.client.post(self.url)
        self.assertEquals(response.context['book'], self.book)

    def test_context_contains_book_csv_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("book_csv", response.context)

    def test_context_book_csv_is_correct_on_failure(self):
        response = self.client.post(self.url)
        self.assertEquals(response.context['book_csv'], self.book_csv)

    def test_it_saves_user_choices_to_columns_field_in_book_csv(self):
        self.client.post(self.url, self.data)
        self.book_csv.refresh_from_db()
        self.assertDictEqual(self.book_csv.columns, self.data)

    def test_it_redirects_to_details_after_submit(self):
        response = self.client.post(self.url, self.data)
        self.assertRedirects(response, reverse("admin:books:csv:details",
                                               args=[self.book.id, self.book_csv.id]))

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEquals(len(msgs), 1)

    def test_response_message_is_equal_to_created_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEquals(str(msgs[0]), _("CSV is Being Processed"))
