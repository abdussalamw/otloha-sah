import inspect
import shutil

from django.contrib.auth.mixins import LoginRequiredMixin
from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import TestCase, Client
from django.test import override_settings
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View

from apps.quran.forms import BookImagesUploadForm, BookImagesPatternUploadForm
from apps.quran.images_processing.filters import ImagesFilter
from apps.quran.images_processing.views import BookImageDetailView, BookImageUploadView, BookImagePatternsView, \
    BookImageListView
from apps.quran.factories import NarrationFactory, BookFactory
from apps.quran.models import BookImageUpload, BookPattern
from apps.users.factories import UserFactory

TEST_DIR = 'test_data'


class BookImageListViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        file = SimpleUploadedFile('file.zip', b'content')
        for _ in range(10):
            BookImageUpload.objects.create(book=self.book, file=file, number_of_pages=10)

        self.url = reverse('admin:books:images:listing', args=[self.book.pk])
        self.client.login(email=self.user.email, password='secret')

    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(isinstance(BookImageListView(), LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(isinstance(BookImageListView(), View))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(BookImageListView, 'model'))

    def test_list_view_use_book_image_upload_model(self):
        self.assertEqual(BookImageListView.model, BookImageUpload)

    def test_list_view_has_filterset_class(self):
        self.assertTrue(hasattr(BookImageListView, 'filterset_class'))

    def test_list_view_filterset_class_is_ImagesFilter(self):
        self.assertEquals(BookImageListView.filterset_class, ImagesFilter)

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(BookImageListView, 'list_display'))

    def test_list_view_has_title(self):
        self.assertTrue(hasattr(BookImageListView, 'title'))

    def test_list_view_has_correct_title(self):
        self.assertEquals(BookImageListView.title, _('All Image Uploads'))


class BookImageDetailViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.book = BookFactory(narration=NarrationFactory())
        file = SimpleUploadedFile('file.txt', b"Content")
        self.uploaded_images = BookImageUpload.objects.create(book=self.book, file=file, number_of_pages=1)
        self.url = reverse('admin:books:images:details', args=[self.book.pk, self.uploaded_images.pk])

    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(isinstance(BookImageDetailView(), LoginRequiredMixin))

    def test_view_extend_View_class(self):
        self.assertTrue(isinstance(BookImageDetailView(), View))

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(BookImageDetailView(), 'get'))

    def test_if_method_get_is_callable(self):
        self.assertTrue(callable(BookImageDetailView().get))

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_404_if_image_upload_does_not_exists_not_exists(self):
        response = self.client.get(reverse('admin:books:images:details', args=[self.book.pk, 123]))
        self.assertEqual(response.status_code, 404)

    def test_ImageUpload_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('ImageUpload', response.context)

    def test_title_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('title', response.context)

    def test_context_ImageUpload_is_correct(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['ImageUpload'], self.uploaded_images)

    def test_context_title_is_correct(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['title'],
                          "{} for {}".format(self.book.translated_name, _("Image Book Details")))

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "quran/book/images_upload_details.html")


class BookImageUploadViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        # login the user
        self.client.login(email=self.user.email, password='secret')
        self.book = BookFactory(narration=NarrationFactory())
        self.url = reverse('admin:books:images:upload', args=[self.book.pk])

    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(isinstance(BookImageUploadView(), LoginRequiredMixin))

    def test_view_extend_View_class(self):
        self.assertTrue(isinstance(BookImageUploadView(), View))

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(BookImageUploadView(), 'get'))

    def test_get_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(BookImageUploadView.get)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_404_if_book_not_exists(self):
        url = reverse('admin:books:images:upload', args=[10000])
        response = self.client.get(url)
        self.assertEqual(response.status_code, 404)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "quran/book/form_images.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_contains_book(self):
        response = self.client.get(self.url)
        self.assertIn("book", response.context)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_form_is_instance_of_BookImagesUploadForm(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], BookImagesUploadForm)

    def test_context_form_is_new_form(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['form'].instance.pk, None)


class BookImageUploadViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.narration = NarrationFactory()
        self.book = BookFactory(narration=self.narration)
        # login the user
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:books:images:upload', args=[self.book.pk])

    def tearDown(self):
        try:
            shutil.rmtree(TEST_DIR)
        except OSError:
            pass

    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(isinstance(BookImageUploadView(), LoginRequiredMixin))

    def test_view_extend_View_class(self):
        self.assertTrue(isinstance(BookImageUploadView(), View))

    def test_post_signature(self):
        expected_signature = ['self', 'request', 'book_id']
        actual_signature = inspect.getfullargspec(BookImageUploadView.post)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_view_has_method_post(self):
        self.assertTrue(hasattr(BookImageUploadView(), 'post'))

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.post(self.url)
        self.assertTemplateUsed(response, "quran/book/form_images.html")

    def test_on_errors_context_contains_form(self):
        response = self.client.post(self.url, data={})
        self.assertIn("form", response.context)

    def test_on_errors_the_form_contain_errors(self):
        response = self.client.post(self.url, data={})
        self.assertTrue(len(response.context['form'].errors))

    def test_on_errors_context_form_is_instance_of_BookImagesUploadForm(self):
        response = self.client.post(self.url, data={})
        self.assertIsInstance(response.context['form'], BookImagesUploadForm)

    def test_on_errors_context_form_is_new_form(self):
        response = self.client.post(self.url, data={})
        self.assertEquals(response.context['form'].instance.pk, None)

    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def test_it_create_the_data_and_store_into_database(self):
        file = SimpleUploadedFile("file.txt", b"file_content")
        response = self.client.post(self.url, data={'file': file,
                                                    }, files={'file': file})

        self.assertNotEqual(BookImageUpload.objects.count, 0)


class BookImagesPatternsViewGETTestCase(TestCase):
    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        file = SimpleUploadedFile('test.txt', b'content')
        self.book_images = BookImageUpload.objects.create(file=file, book=self.book, number_of_pages=20)
        # login the user
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:books:images:patterns-upload', args=[self.book.pk, self.book_images.pk])

    def tearDown(self):
        try:
            shutil.rmtree(TEST_DIR)
        except OSError:
            pass

    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(isinstance(BookImagePatternsView(), LoginRequiredMixin))

    def test_view_extend_View_class(self):
        self.assertTrue(isinstance(BookImagePatternsView(), View))

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(BookImagePatternsView(), 'get'))

    def test_get_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(BookImageUploadView.get)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "quran/book/form_images.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_BookImagesPatternUploadForm(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], BookImagesPatternUploadForm)

    def test_context_form_is_new_form(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['form'].instance.pk, None)


class BookImagesPatternsViewPOSTTestCase(TestCase):
    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        file = SimpleUploadedFile('test.txt', b'content')
        self.book_images = BookImageUpload.objects.create(file=file, book=self.book, number_of_pages=20)
        # login the user
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:books:images:patterns-upload', args=[self.book.pk, self.book_images.pk])

    def tearDown(self):
        try:
            shutil.rmtree(TEST_DIR)
        except OSError:
            pass

    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(isinstance(BookImagePatternsView(), LoginRequiredMixin))

    def test_view_extend_View_class(self):
        self.assertTrue(isinstance(BookImagePatternsView(), View))

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(BookImagePatternsView(), 'get'))

    def test_view_has_method_post(self):
        self.assertTrue(hasattr(BookImagePatternsView(), 'post'))

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used_on_errors(self):
        response = self.client.post(self.url)
        self.assertTemplateUsed(response, "quran/book/form_images.html")

    def test_context_contains_form_on_errors(self):
        response = self.client.post(self.url)
        self.assertIn("form", response.context)

    def test_on_errors_the_form_contain_errors(self):
        response = self.client.post(self.url, data={})
        self.assertTrue(len(response.context['form'].errors))

    def test_context_form_is_instance_of_BookImagesPatternUploadForm_on_errors(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], BookImagesPatternUploadForm)

    @override_settings(MEDIA_ROOT=(TEST_DIR + '/media'))
    def test_it_create_the_record_on_data_base(self):
        file = SimpleUploadedFile("file.txt", b"file_content")
        response = self.client.post(self.url, data={'file': file,
                                                    'type': 'marker',
                                                    }, files={'file': file})

        self.assertNotEqual(0, BookPattern.objects.count())
