import inspect

from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.narrations.factories import NarrationFactory
from apps.tajweed.books.filters import BookFilter
from apps.tajweed.books.views_admin import BookListingView, BookCreateAndUpdateView, BookDetailsView
from apps.tajweed.factories import TajweedBookFactory

from apps.tajweed.forms import BookForm
from apps.tajweed.models import Book
from apps.users.factories import UserFactory


class BookListingViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(BookListingView, LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(issubclass(BookListingView, AdminListView))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(BookListingView, 'model'))

    def test_list_view_use_translation_model(self):
        self.assertEqual(BookListingView.model, Book)

    def test_list_view_has_filter_set_class(self):
        self.assertTrue(hasattr(BookListingView, 'filterset_class'))

    def test_list_view_use_book_filter(self):
        self.assertEqual(BookListingView.filterset_class, BookFilter)

    def test_list_view_has_title(self):
        self.assertTrue(hasattr(BookListingView, 'title'))

    def test_list_view_title_value(self):
        self.assertEquals(BookListingView.title, _('All Tajweed Books'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(BookListingView, 'list_display'))

    def test_list_display_value(self):
        self.assertEquals(BookListingView.list_display, (
            ('id', _('ID')),
            ('name', _('Name')),
            ('narration', _('Narration')),
            ('author', _('Author')),
            ('actions', _('Actions'))
        ))

    def test_it_has_get_breadcrumb(self):
        self.assertTrue(hasattr(BookListingView, 'get_breadcrumb'))

    def test_get_breadcrumb_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(BookListingView.get_breadcrumb)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_load_name(self):
        self.assertTrue(hasattr(BookListingView, 'load_name'))

    def test_load_name_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(BookListingView.load_name)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_load_author(self):
        self.assertTrue(hasattr(BookListingView, 'load_author'))

    def test_load_author_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(BookListingView.load_author)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_load_actions(self):
        self.assertTrue(hasattr(BookListingView, 'load_actions'))

    def test_load_actions_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(BookListingView.load_actions)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_get_actions(self):
        self.assertTrue(hasattr(BookListingView, 'get_actions'))

    def test_get_actions_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(BookListingView.get_actions)[0]
        self.assertEquals(actual_signature, expected_signature)


class BookListingViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:tajweed:books:listing')
        for i in range(10):
            TajweedBookFactory()

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_has_object_list_context(self):
        response = self.client.get(self.url)
        self.assertIn('object_list', response.context)

    def test_it_return_all_data(self):
        response = self.client.get(self.url)
        self.assertGreater(len(response.context['object_list']), 0)


class BookDetailsViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(BookDetailsView, LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(BookDetailsView, View))

    def test_it_has_get(self):
        self.assertTrue(hasattr(BookDetailsView, 'get'))

    def test_method_get_is_callable(self):
        self.assertTrue(callable(BookDetailsView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'book_id']
        actual_signature = inspect.getfullargspec(BookDetailsView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class BookDetailsViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.book = TajweedBookFactory()
        for i in range(9):
            TajweedBookFactory()
        self.url = reverse('admin:tajweed:books:details', args=[1])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_404_if_translation_not_exists(self):
        response = self.client.get(reverse('admin:tajweed:books:details', args=[10000]))
        self.assertEqual(response.status_code, 404)

    def test_object_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('book', response.context)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_details_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _('{book} Book Details').format(book=self.book.translated_name))

    def test_object_in_context_is_correct_one(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['book'], self.book)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "tajweed/book/details.html")


class BookCreateAndUpdateViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(BookCreateAndUpdateView, LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(BookCreateAndUpdateView, View))

    def test_it_has_get(self):
        self.assertTrue(hasattr(BookCreateAndUpdateView, 'get'))

    def test_method_get_is_callable(self):
        self.assertTrue(callable(BookCreateAndUpdateView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(BookCreateAndUpdateView.get)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_post(self):
        self.assertTrue(hasattr(BookCreateAndUpdateView, 'post'))

    def test_method_post_is_callable(self):
        self.assertTrue(callable(BookCreateAndUpdateView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(BookCreateAndUpdateView.post)[0]
        self.assertEquals(actual_signature, expected_signature)


class BookCreateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.url = reverse('admin:tajweed:books:create')
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "tajweed/book/form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_book_form(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], BookForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_create_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _("Add New Tajweed Book"))

    def test_context_form_is_new_form(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['form'].instance.pk, None)


class BookUpdateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = TajweedBookFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:tajweed:books:update', args=[self.book.pk])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, 'tajweed/book/form.html')

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_book_form(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], BookForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_edit_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _("Edit {book}").format(book=self.book.translated_name))

    def test_context_form_instance_is_equal_to_book(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['form'].instance, self.book)


class BookCreateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:tajweed:books:create')

        self.data = {
            'name': '{"ar":"ترجمة محمد"}',
            'narrations': NarrationFactory().pk,
            'author': '{"ar":"محمد"}'
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used_on_failure(self):
        self.data.pop('name')
        response = self.client.post(self.url, self.data)
        self.assertTemplateUsed(response, "tajweed/book/form.html")

    def test_context_contains_form_instance_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn('form', response.context)

    def test_context_form_is_instance_of_book_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], BookForm)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_add_new_tajweed_book_on_failure(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _('Add New Tajweed Book'))

    def test_it_saves_created_book_into_database(self):
        self.client.post(self.url, data=self.data)
        instance = Book.objects.all().last()
        self.assertIn(instance, Book.objects.all())

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEquals(len(msgs), 1)

    def test_response_message_is_equal_to_created_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEquals(str(msgs[0]), _("Book Created Successfully"))


class BookUpdateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = TajweedBookFactory(narration=NarrationFactory())
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:tajweed:books:update', args=[self.book.pk])
        self.data = {
            'name': 'new book name',
            'narrations': self.book.narration_id,
            'author': self.book.translated_author
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_template_used(self):
        response = self.client.post(self.url)
        self.assertTemplateUsed(response, "tajweed/book/form.html")

    def test_context_contains_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("form", response.context)

    def test_it_returns_context_form_is_instance_of_translation_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], BookForm)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_edit_book_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn(response.context["title"], _("Edit {book}").format(book=self.book.translated_name))

    def test_it_saves_updated_book_into_database(self):
        self.client.post(self.url, data=self.data)
        self.book.refresh_from_db()
        self.assertEquals('new book name', self.book.name['ar'])

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEquals(len(msgs), 1)

    def test_response_message_is_equal_to_updated_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEquals(str(msgs[0]), _("Book Updated Successfully"))
