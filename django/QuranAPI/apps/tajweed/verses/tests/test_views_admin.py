import inspect

from django.contrib.auth.mixins import LoginRequiredMixin
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.tajweed.factories import VerseFactory, TajweedBookFactory, CharacterFactory
from apps.tajweed.filters import VerseFilter
from apps.tajweed.models import Verse, Character
from apps.tajweed.tajweed_verse.views_admin import VersesListingView, VerseUpdateView, VerseDetailsView
from apps.users.factories import UserFactory


class VersesListingViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(VersesListingView, LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(issubclass(VersesListingView, AdminListView))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(VersesListingView, 'model'))

    def test_list_view_use_translation_model(self):
        self.assertEqual(VersesListingView.model, Verse)

    def test_list_view_has_filter_set_class(self):
        self.assertTrue(hasattr(VersesListingView, 'filterset_class'))

    def test_list_view_use_verse_filter(self):
        self.assertEqual(VersesListingView.filterset_class, VerseFilter)

    def test_list_view_has_title(self):
        self.assertTrue(hasattr(VersesListingView, 'title'))

    def test_list_view_title_value(self):
        self.assertEqual(VersesListingView.title, _('All Verses'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(VersesListingView, 'list_display'))

    def test_list_display_value(self):
        self.assertEqual(VersesListingView.list_display, (
            ('id', _('ID')),
            ('verse_text', _('Verse Text')),
            ('chapter', _('Chapter')),
            ('actions', _('Actions')),
        ))

    def test_list_view_has_book(self):
        self.assertTrue(hasattr(VersesListingView, 'book'))

    def test_book_value_is_none(self):
        self.assertIsNone(VersesListingView.book)

    def test_it_has_get_breadcrumb(self):
        self.assertTrue(hasattr(VersesListingView, 'get_breadcrumb'))

    def test_get_breadcrumb_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(VersesListingView.get_breadcrumb)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_get_title(self):
        self.assertTrue(hasattr(VersesListingView, 'get_title'))

    def test_get_title_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(VersesListingView.get_title)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_load_actions(self):
        self.assertTrue(hasattr(VersesListingView, 'load_actions'))

    def test_load_actions_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(VersesListingView.load_actions)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_get_queryset(self):
        self.assertTrue(hasattr(VersesListingView, 'get_queryset'))

    def test_get_queryset_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(VersesListingView.get_queryset)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_load_verse_text(self):
        self.assertTrue(hasattr(VersesListingView, 'load_verse_text'))

    def test_load_verse_text_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(VersesListingView.load_verse_text)[0]
        self.assertEqual(actual_signature, expected_signature)


class VersesListingViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.book = TajweedBookFactory()
        self.url = reverse('admin:tajweed:verses:listing', args=[self.book.pk])
        for i in range(10):
            VerseFactory(tajweed_book=self.book)

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


class VerseDetailsViewStructureTestCase(TestCase):
    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(VerseDetailsView, View))

    def test_it_has_get(self):
        self.assertTrue(hasattr(VerseDetailsView, 'get'))

    def test_method_get_is_callable(self):
        self.assertTrue(callable(VerseDetailsView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'verse_id']
        actual_signature = inspect.getfullargspec(VerseDetailsView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class VerseDetailsViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.book = TajweedBookFactory()
        self.verse = VerseFactory(tajweed_book=self.book)
        CharacterFactory(tajweed_verse=self.verse)
        for i in range(9):
            VerseFactory(tajweed_book=self.book)
        self.url = reverse('admin:tajweed:verses:details', args=[self.verse.pk])

    def test_it_return_404_if_translation_not_exists(self):
        response = self.client.get(reverse('admin:tajweed:verses:details', args=[10000]))
        self.assertEqual(response.status_code, 404)

    def test_context_contains_verse(self):
        response = self.client.get(self.url)
        self.assertIn('verses', response.context)

    def test_context_contains_characters(self):
        response = self.client.get(self.url)
        self.assertIn('characters', response.context)

    def test_characters_in_context_is_correct_one(self):
        response = self.client.get(self.url)
        self.assertQuerySetEqual(response.context['characters'], Character.objects.filter(tajweed_verse=self.verse),
                                 transform=lambda x: x)

    def test_context_contains_prev_verse_url(self):
        response = self.client.get(self.url)
        self.assertIn("prev_verse_url", response.context)

    def test_context_contains_next_verse_url(self):
        response = self.client.get(self.url)
        self.assertIn("next_verse_url", response.context)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_details_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"],
                      _('Verse ( {text} ) Tajweed Details').format(text=self.verse.verse_text))

    def test_object_in_context_is_correct_one(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['verses'], self.verse)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "tajweed/verses/details.html")


class VerseUpdateViewStructureTestCase(TestCase):
    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(VerseUpdateView, View))

    def test_it_has_get_formset(self):
        self.assertTrue(hasattr(VerseUpdateView, 'get_formset'))

    def test_method_get_formset_is_callable(self):
        self.assertTrue(callable(VerseUpdateView.get_formset))

    def test_get_formset_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(VerseUpdateView.get_formset)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_get(self):
        self.assertTrue(hasattr(VerseUpdateView, 'get'))

    def test_method_get_is_callable(self):
        self.assertTrue(callable(VerseUpdateView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'verse_id']
        actual_signature = inspect.getfullargspec(VerseUpdateView.get)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_post(self):
        self.assertTrue(hasattr(VerseUpdateView, 'post'))

    def test_method_post_is_callable(self):
        self.assertTrue(callable(VerseUpdateView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request', 'verse_id']
        actual_signature = inspect.getfullargspec(VerseUpdateView.post)[0]
        self.assertEqual(actual_signature, expected_signature)


class VerseUpdateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.book = TajweedBookFactory()
        self.verse = VerseFactory(tajweed_book=self.book)
        CharacterFactory(tajweed_verse=self.verse)
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:tajweed:verses:update', args=[self.verse.pk])

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, 'tajweed/verses/update.html')

    def test_context_contains_verse(self):
        response = self.client.get(self.url)
        self.assertIn("verses", response.context)

    def test_context_form_instance_is_equal_to_verse(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['verses'], self.verse)

    def test_characters_in_context_is_correct_one(self):
        response = self.client.get(self.url)
        self.assertQuerySetEqual(response.context['characters'], Character.objects.filter(tajweed_verse=self.verse),
                                 transform=lambda x: x)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_update_title(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context["title"], _('Update Characters'))

    def test_context_contains_prev_verse_url(self):
        response = self.client.get(self.url)
        self.assertIn("prev_verse_url", response.context)

    def test_context_contains_next_verse_url(self):
        response = self.client.get(self.url)
        self.assertIn("next_verse_url", response.context)

    def test_context_contains_formset(self):
        response = self.client.get(self.url)

        self.assertIn("formset", response.context)

    def test_all_field_in_the_form_set_is_CharacterForm_instance(self):
        response = self.client.get(self.url)
        a = []
        for form in response.context['formset'].forms:
            a.append(isinstance(form.instance, Character))
        self.assertTrue(all(a))


# todo: test update verses: POST
class VerseUpdateViewPOSTTestCase(TestCase):
    pass
