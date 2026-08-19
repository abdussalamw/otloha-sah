import inspect

from django.contrib.auth.mixins import LoginRequiredMixin
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.translation import gettext as _

from apps.explanations.explanation_verse.views_admin import ExplanationVerseListingView
from apps.explanations.factories import ExplanationVerseFactory, ExplanationFactory
from apps.explanations.models import ExplanationVerse
from apps.main.views_admin import AdminListView
from apps.narrations.factories import NarrationFactory
from apps.users.factories import UserFactory


class ExplanationVerseListingAdminViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(ExplanationVerseListingView, LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(issubclass(ExplanationVerseListingView, AdminListView))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(ExplanationVerseListingView, 'model'))

    def test_list_view_use_explanation_verse_model(self):
        self.assertEqual(ExplanationVerseListingView.model, ExplanationVerse)

    def test_list_view_has_filter_set_class(self):
        self.assertTrue(hasattr(ExplanationVerseListingView, 'filterset_class'))

    def test_list_view_filter_set_is_none(self):
        self.assertIsNone(ExplanationVerseListingView.filterset_class)

    def test_list_view_has_title(self):
        self.assertTrue(hasattr(ExplanationVerseListingView, 'title'))

    def test_list_view_title_value(self):
        self.assertEqual(ExplanationVerseListingView.title, _('All Explanation Verses'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(ExplanationVerseListingView, 'list_display'))

    def test_list_display_value(self):
        self.assertEqual(ExplanationVerseListingView.list_display, (
            ('id', _('ID')),
            ('explanations', _('Explanation')),
            ('verse_number', _('Verse Number')),
            ('chapter_number', _('Chapter Number')),
            ('page_number', _('Page Number')),
            ('text', _('Tafseer')),
        ))

    def test_it_has_get_breadcrumb(self):
        self.assertTrue(hasattr(ExplanationVerseListingView, 'get_breadcrumb'))

    def test_get_breadcrumb_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(ExplanationVerseListingView.get_breadcrumb)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_get_query_set(self):
        self.assertTrue(hasattr(ExplanationVerseListingView, 'get_queryset'))

    def test_get_queryset_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(ExplanationVerseListingView.get_queryset)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_get_actions(self):
        self.assertTrue(hasattr(ExplanationVerseListingView, 'get_actions'))

    def test_get_actions_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(ExplanationVerseListingView.get_actions)[0]
        self.assertEqual(actual_signature, expected_signature)


class ExplanationVerseListingViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.explanation = ExplanationFactory(narration=NarrationFactory())
        self.url = reverse('admin:explanations:verses:listing', args=[self.explanation.pk])
        for i in range(10):
            ExplanationVerseFactory(explanation=self.explanation)

    def test_if_explanation_verse_redirects_to_login_when_no_authentication_done(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_has_object_list_context(self):
        response = self.client.get(self.url)
        self.assertIn('object_list', response.context)

    def test_it_return_all_data(self):
        response = self.client.get(self.url)
        self.assertGreater(len(response.context['object_list']), 0)