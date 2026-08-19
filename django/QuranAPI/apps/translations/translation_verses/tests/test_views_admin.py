import inspect

from django.contrib.auth.mixins import LoginRequiredMixin
from django.test import TestCase
from django.utils.translation import gettext as _

from apps.main.views_admin import AdminListView
from apps.translations.models import TranslationVerse
from apps.translations.translation_verses.views_admin import TranslationVersesListAdminView


class TranslationVersesListAdminViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(TranslationVersesListAdminView, LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(issubclass(TranslationVersesListAdminView, AdminListView))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(TranslationVersesListAdminView, 'model'))

    def test_list_view_use_translation_verse_model(self):
        self.assertEqual(TranslationVersesListAdminView.model, TranslationVerse)

    def test_list_view_has_filter_set_class(self):
        self.assertTrue(hasattr(TranslationVersesListAdminView, 'filterset_class'))

    def test_list_view_filter_set_is_none(self):
        self.assertIsNone(TranslationVersesListAdminView.filterset_class)

    def test_list_view_has_title(self):
        self.assertTrue(hasattr(TranslationVersesListAdminView, 'title'))

    def test_list_view_title_value(self):
        self.assertEqual(TranslationVersesListAdminView.title, _('All Translation Verses'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(TranslationVersesListAdminView, 'list_display'))

    def test_list_display_value(self):
        self.assertEqual(TranslationVersesListAdminView.list_display, (
            ('id', _('ID')),
            ('text', _('Text')),
            ('verse_number', _('Verse Number')),
            ('translation', _('Translation')),
            ('narrations', _('Narration')),
            ('chapter', _('Chapter')),
            ('chapter_number', _('Chapter Number')),
        ))

    def test_it_has_get_breadcrumb(self):
        self.assertTrue(hasattr(TranslationVersesListAdminView, 'get_breadcrumb'))

    def test_get_breadcrumb_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(TranslationVersesListAdminView.get_breadcrumb)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_get_query_set(self):
        self.assertTrue(hasattr(TranslationVersesListAdminView, 'get_queryset'))

    def test_get_queryset_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(TranslationVersesListAdminView.get_queryset)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_get_actions(self):
        self.assertTrue(hasattr(TranslationVersesListAdminView, 'get_actions'))

    def test_get_actions_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(TranslationVersesListAdminView.get_actions)[0]
        self.assertEqual(actual_signature, expected_signature)