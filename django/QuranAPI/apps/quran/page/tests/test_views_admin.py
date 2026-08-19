import inspect

from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.contrib.auth.models import Permission
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.quran.page.views_admin import PageListAdminView, PageDetailsView
from apps.narrations.factories import NarrationFactory
from apps.quran.factories import BookFactory, PageFactory
from apps.quran.models import Page
from apps.users.factories import UserFactory


class PageAdminListViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        self.page = PageFactory(book=self.book)
        self.url = reverse('admin:books:pages:list', args=[self.book.id])
        self.client.login(email=self.user.email, password='secret')

    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(isinstance(PageListAdminView(), LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(isinstance(AdminListView(), View))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(PageListAdminView, 'model'))

    def test_list_view_use_book_model(self):
        self.assertEqual(PageListAdminView.model, Page)

    def test_list_view_has_filter_set_class(self):
        self.assertTrue(hasattr(PageListAdminView, 'filterset_class'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(PageListAdminView, 'list_display'))

    def test_narration_has_load_page_number(self):
        self.assertTrue(hasattr(PageListAdminView, 'load_page_number'))

    def test_page_number_is_callable(self):
        self.assertTrue(callable(getattr(PageListAdminView, 'load_page_number')))


class PageDetailsViewStructureTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(issubclass(PageDetailsView, LoginRequiredMixin))

    def test_it_extends_permission_required_mixin(self):
        self.assertTrue(issubclass(PageDetailsView, PermissionRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(PageDetailsView, View))

    def test_it_has_permission_required_attribute(self):
        self.assertTrue(hasattr(PageDetailsView, "permission_required"))

    def test_permission_required_attribute_is_set(self):
        self.assertTrue(type(PageDetailsView.permission_required), 'set')

    def test_view_book_in_permission_required_attribute(self):
        self.assertIn("quran.view_book", PageDetailsView.permission_required)

    def test_view_page_in_permission_required_attribute(self):
        self.assertIn("quran.view_page", PageDetailsView.permission_required)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(PageDetailsView, 'get'))

    def test_get_method_is_callable(self):
        self.assertTrue(callable(PageDetailsView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'book_id', 'page_id']
        actual_signature = inspect.getfullargspec(PageDetailsView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class PageDetailsViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.user.user_permissions.add(
            Permission.objects.get(codename='view_book'),
            Permission.objects.get(codename='view_page'))
        self.book = BookFactory(narration=NarrationFactory())
        self.page = PageFactory(book=self.book)
        self.url = reverse('admin:books:pages:details', args=[self.book.pk, self.page.pk])
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_403_if_user_does_not_have_permission(self):
        self.user.user_permissions.clear()
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, 403)

    def test_it_return_404_if_book_dose_not_exists(self):
        response = self.client.get(reverse('admin:books:pages:details', args=[10000, self.page.pk]))
        self.assertEqual(response.status_code, 404)

    def test_it_return_404_if_page_dose_not_exists(self):
        response = self.client.get(reverse('admin:books:pages:details', args=[self.book.pk, 1000]))
        self.assertEqual(response.status_code, 404)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "quran/book/pages/details.html")

    def test_book_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('book', response.context)

    def test_context_book_is_correct(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['book'], self.book)

    def test_page_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('page', response.context)

    def test_context_page_is_correct(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['page'], self.page)

    def test_title_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('title', response.context)

    def test_context_title_is_create_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], "{} {}".format(_("Details Of Page"), self.page.page_number))
