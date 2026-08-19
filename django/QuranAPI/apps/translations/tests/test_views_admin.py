import inspect

from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.translations.factories import TranslationFactory
from apps.translations.filters import TranslationFilter
from apps.translations.forms import TranslationForm
from apps.translations.models import Translation
from apps.translations.views_admin import TranslationListAdminView, TranslationDetailAdminView, \
    TranslationCreateAndUpdateView
from apps.users.factories import UserFactory


class TranslationListAdminViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(TranslationListAdminView, LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(issubclass(TranslationListAdminView, AdminListView))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(TranslationListAdminView, 'model'))

    def test_list_view_use_translation_model(self):
        self.assertEqual(TranslationListAdminView.model, Translation)

    def test_list_view_has_filter_set_class(self):
        self.assertTrue(hasattr(TranslationListAdminView, 'filterset_class'))

    def test_list_view_use_translation_filter(self):
        self.assertEqual(TranslationListAdminView.filterset_class, TranslationFilter)

    def test_list_view_has_title(self):
        self.assertTrue(hasattr(TranslationListAdminView, 'title'))

    def test_list_view_title_value(self):
        self.assertEqual(TranslationListAdminView.title, _('All Translations'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(TranslationListAdminView, 'list_display'))

    def test_list_display_value(self):
        self.assertEqual(TranslationListAdminView.list_display, (
            ('id', _('ID')),
            ('name', _('name')),
            ('language', _('language')),
            ('author', _('author')),
            ('actions', _('actions'))
        ))

    def test_it_has_get_breadcrumb(self):
        self.assertTrue(hasattr(TranslationListAdminView, 'get_breadcrumb'))

    def test_get_breadcrumb_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(TranslationListAdminView.get_breadcrumb)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_load_name(self):
        self.assertTrue(hasattr(TranslationListAdminView, 'load_name'))

    def test_load_name_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(TranslationListAdminView.load_name)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_load_language(self):
        self.assertTrue(hasattr(TranslationListAdminView, 'load_language'))

    def test_load_language_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(TranslationListAdminView.load_language)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_load_author(self):
        self.assertTrue(hasattr(TranslationListAdminView, 'load_author'))

    def test_load_author_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(TranslationListAdminView.load_author)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_load_actions(self):
        self.assertTrue(hasattr(TranslationListAdminView, 'load_actions'))

    def test_load_actions_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(TranslationListAdminView.load_actions)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_get_actions(self):
        self.assertTrue(hasattr(TranslationListAdminView, 'get_actions'))

    def test_get_actions_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(TranslationListAdminView.get_actions)[0]
        self.assertEqual(actual_signature, expected_signature)


class TranslationListAdminViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:translations:listing')
        for i in range(10):
            TranslationFactory()

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


class TranslationDetailAdminViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(TranslationDetailAdminView, LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(TranslationDetailAdminView, View))

    def test_it_has_get(self):
        self.assertTrue(hasattr(TranslationDetailAdminView, 'get'))

    def test_method_get_is_callable(self):
        self.assertTrue(callable(TranslationDetailAdminView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'translation_id']
        actual_signature = inspect.getfullargspec(TranslationDetailAdminView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class TranslationDetailAdminViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.translation = TranslationFactory()
        for i in range(9):
            TranslationFactory()
        self.url = reverse('admin:translations:detail', args=[1])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_404_if_translation_not_exists(self):
        response = self.client.get(reverse('admin:translations:detail', args=[10000]))
        self.assertEqual(response.status_code, 404)

    def test_object_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('translation', response.context)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_details_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], "{} {}".format(self.translation.translated_name, _('Translation '
                                                                                                    'Details')))

    def test_object_in_context_is_correct_one(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['translation'], self.translation)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "translations/details.html")


class TranslationCreateAndUpdateViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(TranslationCreateAndUpdateView, LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(TranslationCreateAndUpdateView, View))

    def test_it_has_get(self):
        self.assertTrue(hasattr(TranslationCreateAndUpdateView, 'get'))

    def test_method_get_is_callable(self):
        self.assertTrue(callable(TranslationCreateAndUpdateView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(TranslationCreateAndUpdateView.get)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_post(self):
        self.assertTrue(hasattr(TranslationCreateAndUpdateView, 'post'))

    def test_method_post_is_callable(self):
        self.assertTrue(callable(TranslationCreateAndUpdateView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(TranslationCreateAndUpdateView.post)[0]
        self.assertEqual(actual_signature, expected_signature)


class TranslationCreateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.url = reverse('admin:translations:create')
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "translations/form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_translation_form(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], TranslationForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_create_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _('Add New Translation'))

    def test_context_form_is_new_form(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['form'].instance.pk, None)


class TranslationUpdateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.translation = TranslationFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:translations:update', args=[self.translation.pk])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "translations/form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_TranslationForm(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], TranslationForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_edit_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], "{} {}".format(_("Edit"), self.translation.translated_name))

    def test_context_form_instance_is_equal_to_translation(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['form'].instance, self.translation)


class TranslationCreateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:translations:create')

        self.data = {
            'name': '{"ar":"ترجمة محمد"}',
            'language':"ar",
            'author': '{"ar":"محمد"}'
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used_on_failure(self):
        self.data.pop('name')
        response = self.client.post(self.url, self.data)
        self.assertTemplateUsed(response, "translations/form.html")

    def test_context_contains_form_instance_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn('form', response.context)

    def test_context_form_is_instance_of_translation_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], TranslationForm)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_add_new_translation_title_on_failure(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _('Add New Translation'))

    def test_it_saves_created_translation_into_database(self):
        self.client.post(self.url, data=self.data)
        instance = Translation.objects.all().last()
        self.assertIn(instance, Translation.objects.all())

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEqual(len(msgs), 1)

    def test_response_message_is_equal_to_created_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEqual(str(msgs[0]), _("Translation Created Successfully"))


class TranslationUpdateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.translation = TranslationFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:translations:update', args=[self.translation.pk])
        self.data = {
            'name': 'new translation name',
            'language': self.translation.language,
            'author': self.translation.translated_author
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_template_used(self):
        response = self.client.post(self.url)
        self.assertTemplateUsed(response, "translations/form.html")

    def test_context_contains_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("form", response.context)

    def test_it_returns_context_form_is_instance_of_translation_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], TranslationForm)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_add_edit_translation_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn(response.context["title"], "{} {}".format(_("Edit"), self.translation.translated_name))

    def test_it_saves_updated_translation_into_database(self):
        response = self.client.post(self.url, data=self.data)
        self.translation.refresh_from_db()
        self.assertEqual("new translation name", self.translation.name['ar'])

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEqual(len(msgs), 1)

    def test_response_message_is_equal_to_updated_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEqual(str(msgs[0]), _("Translation Updated Successfully"))
