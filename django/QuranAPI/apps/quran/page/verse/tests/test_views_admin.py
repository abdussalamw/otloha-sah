from django.contrib.auth.mixins import LoginRequiredMixin
from django.test import TestCase, Client
from django.urls import reverse
from django.views import View

from apps.main.views_admin import AdminListView
from apps.quran.page.verse.views_admin import VerseListAdminView
from apps.quran.factories import VerseFactory, NarrationFactory, BookFactory
from apps.quran.models import Verse
from apps.users.factories import UserFactory


class VerseAdminListViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = BookFactory(narration=NarrationFactory())
        self.verse = VerseFactory()
        self.url = reverse('admin:books:verses:list', args=[self.book.pk])
        self.client.login(email=self.user.email, password='secret')

    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(isinstance(VerseListAdminView(), LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(isinstance(AdminListView(), View))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(VerseListAdminView, 'model'))

    def test_list_view_use_book_model(self):
        self.assertEqual(VerseListAdminView.model, Verse)

    def test_list_view_has_filter_set_class(self):
        self.assertTrue(hasattr(VerseListAdminView, 'filterset_class'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(VerseListAdminView, 'list_display'))

    def test_narration_has_load_image(self):
        self.assertTrue(hasattr(VerseListAdminView, 'load_image'))

    def test_load_image_is_callable(self):
        self.assertTrue(callable(getattr(VerseListAdminView, 'load_image')))