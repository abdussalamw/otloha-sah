import inspect

from django.conf import settings
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.narrations.factories import NarrationFactory
from apps.quran.forms import BookForm
from apps.quran.views_admin import BookCreateAndUpdateView, BookDetailsView, \
    BookListView
from apps.quran.factories import BookFactory
from apps.quran.models import Book
from apps.users.factories import UserFactory


class BookListViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        self.url = reverse('admin:books:listing')
        self.client.login(email=self.user.email, password='secret')

    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(isinstance(BookListView(), LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(isinstance(AdminListView(), View))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(BookListView, 'model'))

    def test_list_view_use_book_model(self):
        self.assertEqual(BookListView.model, Book)

    def test_list_view_has_filterset_class(self):
        self.assertTrue(hasattr(BookListView, 'filterset_class'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(BookListView, 'list_display'))


class BookDetailsViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        self.url = reverse('admin:books:details', args=[self.book.pk])
        self.client.login(email=self.user.email, password='secret')

    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(isinstance(BookDetailsView(), LoginRequiredMixin))

    def test_view_extend_View_class(self):
        self.assertTrue(isinstance(BookDetailsView(), View))

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(BookDetailsView(), 'get'))

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_404_if_book_not_exists(self):
        response = self.client.get(reverse('admin:books:details', args=[10000]))
        self.assertEqual(response.status_code, 404)

    def test_book_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('book', response.context)

    def test_context_book_is_correct(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['book'], self.book)

    def test_title_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('title', response.context)

    def test_context_title_is_correct(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['title'], "{} {}".format(self.book.translated_name, _("Book Details")))

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "quran/book/details.html")


class BookCreateAndUpdateViewTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(isinstance(BookCreateAndUpdateView(), LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(isinstance(BookCreateAndUpdateView(), View))

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(BookCreateAndUpdateView(), 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(BookCreateAndUpdateView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(BookCreateAndUpdateView.get)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_view_has_method_post(self):
        self.assertTrue(hasattr(BookCreateAndUpdateView(), 'post'))

    def test_view_has_method_post_is_callable(self):
        self.assertTrue(callable(BookCreateAndUpdateView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(BookCreateAndUpdateView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class BookCreateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.url = reverse('admin:books:create')
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "quran/book/form.html")

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
        self.assertIn(response.context["title"], _("Add New Book"))

    def test_context_form_is_new_form(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['form'].instance.pk, None)


class BookUpdateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.narration = NarrationFactory()
        self.book = BookFactory(narration=self.narration)
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:books:update', args=[self.book.pk])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "quran/book/form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_BookForm(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], BookForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_edit_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], "{} {}".format(_("Edit"), self.book.translated_name))

    def test_context_form_instance_is_equal_to_book(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['form'].instance, self.book)


class BookCreateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:books:create')
        self.narration = NarrationFactory()
        self.data = {
            'narration': self.narration.pk,
            'name': 'new name'
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used_on_failure(self):
        self.data.pop('narration')
        response = self.client.post(self.url, self.data)
        self.assertTemplateUsed(response, "quran/book/form.html")

    def test_context_contains_form_instance_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn('form', response.context)

    def test_context_form_is_instance_of_book_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], BookForm)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn('title', response.context)

    def test_context_is_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertEqual(response.context['title'], _("Add New Book"))

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_it_redirects_to_details_on_success(self):
        response = self.client.post(self.url, data=self.data)
        self.assertRedirects(response, reverse("admin:books:details", args=[1]))

    def test_it_saves_created_book_into_database(self):
        self.client.post(self.url, data=self.data)
        instance = Book.objects.get(narration=self.narration, name={settings.LANGUAGE_CODE: self.data['name']})
        self.assertIn(instance, Book.objects.all())

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEqual(len(msgs), 1)

    def test_response_message_is_equal_to_created_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEqual(str(msgs[0]), _("Book Created Successfully"))


class BookUpdateViewPostTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.narration = NarrationFactory()
        self.book = BookFactory(narration=self.narration)
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:books:update', args=[self.book.pk])
        self.data = {
            'narration': self.narration.pk,
            'name': 'new name'
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used_on_failure(self):
        self.data.pop('narration')
        response = self.client.post(self.url, self.data)
        self.assertTemplateUsed(response, "quran/book/form.html")

    def test_context_contains_form_instance_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn('form', response.context)

    def test_context_form_is_instance_of_book_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], BookForm)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn('title', response.context)

    def test_context_is_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertEqual(response.context['title'], "{} {}".format(_("Edit"), self.book.translated_name))

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_form_instance_is_equal_to_book_instance(self):
        response = self.client.post(self.url)
        self.assertEqual(response.context['form'].instance, self.book)

    def test_it_redirects_to_details_on_success(self):
        response = self.client.post(self.url, data=self.data)
        self.assertRedirects(response, reverse("admin:books:details", args=[1]))

    def test_it_saves_request_data_on_success(self):
        response = self.client.post(self.url, data={
            "name": "this is book name",
            "narration": self.narration.pk
        })
        self.book.refresh_from_db()
        self.assertEqual(self.book.name['ar'], "this is book name")

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEqual(len(msgs), 1)

    def test_response_message_is_equal_to_created_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEqual(str(msgs[0]), _("Book Updated Successfully"))
