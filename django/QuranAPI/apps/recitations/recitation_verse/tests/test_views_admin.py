import inspect

from django.contrib.auth.mixins import LoginRequiredMixin
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.translation import gettext as _

from apps.chapters.factories import ChapterFactory
from apps.main.views_admin import AdminListView
from apps.narrations.factories import NarrationFactory
from apps.recitations.factories import ReciterFactory, RecitationFactory, RecitationVerseFactory
from apps.recitations.models import RecitationVerse
from apps.recitations.recitation_verse.filters import RecitationVerseFilter
from apps.recitations.recitation_verse.views_admin import RecitationVerseListAdminView
from apps.users.factories import UserFactory


class RecitationVerseAdminListViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(RecitationVerseListAdminView, LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(issubclass(RecitationVerseListAdminView, AdminListView))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(RecitationVerseListAdminView, 'model'))

    def test_list_view_use_recitation_model(self):
        self.assertEqual(RecitationVerseListAdminView.model, RecitationVerse)

    def test_list_view_has_filter_set_class(self):
        self.assertTrue(hasattr(RecitationVerseListAdminView, 'filterset_class'))

    def test_list_view_use_recitation_verse_filter(self):
        self.assertEqual(RecitationVerseListAdminView.filterset_class, RecitationVerseFilter)

    def test_list_view_has_title(self):
        self.assertTrue(hasattr(RecitationVerseListAdminView, 'title'))

    def test_list_view_title_value(self):
        self.assertEqual(RecitationVerseListAdminView.title, _('All Recitation Verses'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(RecitationVerseListAdminView, 'list_display'))

    def test_list_display_value(self):
        self.assertEqual(RecitationVerseListAdminView.list_display, (
            ('id', _('ID')),
            ('recitation', _('recitation')),
            ('chapter', _('chapter')),
            ('verse_number', _('verse_number')),
            ('play', _('Play'))
        ))

    def test_it_has_load_play(self):
        self.assertTrue(hasattr(RecitationVerseListAdminView, 'load_play'))

    def test_load_play_is_callable(self):
        self.assertTrue(callable(getattr(RecitationVerseListAdminView, 'load_play')))

    def test_load_play_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(RecitationVerseListAdminView.load_play)[0]
        self.assertEqual(actual_signature, expected_signature)


class RecitationVerseAdminListViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.reciter = ReciterFactory()
        self.recitation = RecitationFactory(reciter=self.reciter, narration=NarrationFactory())
        self.chapter = ChapterFactory()
        self.recitation_verse = RecitationVerseFactory(chapter=self.chapter, recitation=self.recitation, record='file')
        self.url = reverse('admin:recitations:recitation-verse:list')
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_has_object_list_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('object_list', response.context)

    def test_it_return_the_correct_data(self):
        response = self.client.get(self.url)
        self.assertQuerySetEqual(RecitationVerse.objects.all(), response.context['object_list'], ordered=False)
