import inspect

from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View

from apps.explanations.factories import ExplanationFactory
from apps.explanations.filters import ExplanationAdminFilter
from apps.explanations.forms import ExplanationForm
from apps.explanations.models import Explanation
from apps.explanations.views_admin import ExplanationListingView, ExplanationDetailsView, ExplanationCreateAndUpdateView
from apps.main.views_admin import AdminListView
from apps.narrations.factories import NarrationFactory
from apps.users.factories import UserFactory


class ExplanationListingViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(ExplanationListingView, LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(issubclass(ExplanationListingView, AdminListView))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(ExplanationListingView, 'model'))

    def test_list_view_use_Explanation_model(self):
        self.assertEqual(ExplanationListingView.model, Explanation)

    def test_list_view_has_filterset_class(self):
        self.assertTrue(hasattr(ExplanationListingView, 'filterset_class'))

    def test_list_view_use_explanation_filter(self):
        self.assertEqual(ExplanationListingView.filterset_class, ExplanationAdminFilter)

    def test_list_view_has_title(self):
        self.assertTrue(hasattr(ExplanationListingView, 'title'))

    def test_list_view_title_value(self):
        self.assertEqual(ExplanationListingView.title, _('All Explanations'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(ExplanationListingView, 'list_display'))

    def test_list_display_value(self):
        self.assertEqual(ExplanationListingView.list_display, (
            ('id', _('ID')),
            ('name', _('Name')),
            ('narration', _('Narration')),
            ('actions', _('Actions')),
        ))

    def test_it_has_get_breadcrumb(self):
        self.assertTrue(hasattr(ExplanationListingView, 'get_breadcrumb'))

    def test_get_breadcrumb_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(ExplanationListingView.get_breadcrumb)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_load_name(self):
        self.assertTrue(hasattr(ExplanationListingView, 'get_actions'))

    def test_load_name_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(ExplanationListingView.load_name)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_load_actions(self):
        self.assertTrue(hasattr(ExplanationListingView, 'load_actions'))

    def test_load_actions_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(ExplanationListingView.load_actions)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_get_actions(self):
        self.assertTrue(hasattr(ExplanationListingView, 'get_actions'))

    def test_get_actions_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(ExplanationListingView.get_actions)[0]
        self.assertEqual(actual_signature, expected_signature)


class ExplanationListingViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:explanations:listing')
        for i in range(10):
            ExplanationFactory(narration=NarrationFactory())

    def test_if_narration_create_redirects_to_login_when_no_authentication_done(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)


class ExplanationDetailsViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(ExplanationDetailsView, LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(ExplanationDetailsView, View))

    def test_it_has_get(self):
        self.assertTrue(hasattr(ExplanationDetailsView, 'get'))

    def test_method_get_is_callable(self):
        self.assertTrue(callable(ExplanationDetailsView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'explanation_id']
        actual_signature = inspect.getfullargspec(ExplanationDetailsView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class BookDetailsViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.explanation = ExplanationFactory()
        for i in range(9):
            ExplanationFactory()
        self.url = reverse('admin:explanations:details', args=[1])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_404_if_explanation_not_exists(self):
        response = self.client.get(reverse('admin:explanations:details', args=[10000]))
        self.assertEqual(response.status_code, 404)

    def test_object_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('explanation', response.context)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_details_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"],
                      "{} {}".format(self.explanation.translated_name, _('Explanation Details')))

    def test_object_in_context_is_correct_one(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['explanation'], self.explanation)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "explanations/details.html")


class ExplanationCreateAndUpdateViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(ExplanationCreateAndUpdateView, LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(ExplanationCreateAndUpdateView, View))

    def test_it_has_get(self):
        self.assertTrue(hasattr(ExplanationCreateAndUpdateView, 'get'))

    def test_method_get_is_callable(self):
        self.assertTrue(callable(ExplanationCreateAndUpdateView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(ExplanationCreateAndUpdateView.get)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_post(self):
        self.assertTrue(hasattr(ExplanationCreateAndUpdateView, 'post'))

    def test_method_post_is_callable(self):
        self.assertTrue(callable(ExplanationCreateAndUpdateView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(ExplanationCreateAndUpdateView.post)[0]
        self.assertEqual(actual_signature, expected_signature)


class ExplanationCreateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.url = reverse('admin:explanations:create')
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "explanations/form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_explanation_form(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], ExplanationForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_create_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _('Add New Explanation'))

    def test_context_form_is_new_form(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['form'].instance.pk, None)


class ExplanationUpdateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.explanation = ExplanationFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:explanations:update', args=[self.explanation.pk])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, 'explanations/form.html')

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_explanation_form(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], ExplanationForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_edit_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], "{} {}".format(_("Edit"), self.explanation.translated_name))

    def test_context_form_instance_is_equal_to_explanation(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['form'].instance, self.explanation)


class ExplanationCreateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:explanations:create')

        self.data = {
            'name': '{"ar":"تفسير محمد"}',
            'narrations': NarrationFactory().pk,
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used_on_failure(self):
        self.data.pop('name')
        response = self.client.post(self.url, self.data)
        self.assertTemplateUsed(response, "explanations/form.html")

    def test_context_contains_form_instance_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn('form', response.context)

    def test_context_form_is_instance_of_book_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], ExplanationForm)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_add_new_explanation_on_failure(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _('Add New Explanation'))

    def test_it_saves_created_explanation_into_database(self):
        self.client.post(self.url, data=self.data)
        instance = Explanation.objects.all().last()
        self.assertIn(instance, Explanation.objects.all())

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEqual(len(msgs), 1)

    def test_response_message_is_equal_to_created_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEqual(str(msgs[0]), _("Explanation Created Successfully"))


class ExplanationUpdateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.explanation = ExplanationFactory(narration=NarrationFactory())
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:explanations:update', args=[self.explanation.pk])
        self.data = {
            'name': 'new explanation name',
            'narrations': self.explanation.narration_id,
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_template_used(self):
        response = self.client.post(self.url)
        self.assertTemplateUsed(response, "explanations/form.html")

    def test_context_contains_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("form", response.context)

    def test_it_returns_context_form_is_instance_of_explanation_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], ExplanationForm)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_edit_explanation_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn(response.context["title"], "{} {}".format(_("Edit"), self.explanation.translated_name))

    def test_it_saves_updated_explanation_into_database(self):
        self.client.post(self.url, data=self.data)
        self.explanation.refresh_from_db()
        self.assertEqual('new explanation name', self.explanation.name['ar'])

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEqual(len(msgs), 1)

    def test_response_message_is_equal_to_updated_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEqual(str(msgs[0]), _("Explanation Updated Successfully"))
