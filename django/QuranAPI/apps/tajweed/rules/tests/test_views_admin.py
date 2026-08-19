import inspect

from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.tajweed.factories import RuleFactory, TajweedBookFactory
from apps.tajweed.filters import RuleFilter
from apps.tajweed.forms import RuleForm
from apps.tajweed.models import Rule
from apps.tajweed.rules.views_admin import RulesListingView, RuleCreateAndUpdateView, RuleDetailsView
from apps.users.factories import UserFactory


class RulesListingViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(RulesListingView, LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(issubclass(RulesListingView, AdminListView))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(RulesListingView, 'model'))

    def test_list_view_use_rule_model(self):
        self.assertEqual(RulesListingView.model, Rule)

    def test_list_view_has_filter_set_class(self):
        self.assertTrue(hasattr(RulesListingView, 'filterset_class'))

    def test_list_view_use_rule_filter(self):
        self.assertEqual(RulesListingView.filterset_class, RuleFilter)

    def test_list_view_has_title(self):
        self.assertTrue(hasattr(RulesListingView, 'title'))

    def test_list_view_title_value(self):
        self.assertEqual(RulesListingView.title, _('All Rules'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(RulesListingView, 'list_display'))

    def test_list_display_value(self):
        self.assertEqual(RulesListingView.list_display, (
            ('id', _('ID')),
            ('name', _('Name')),
            ('rule_number', _('Rule Number')),
            ('color', _('Color')),
            ('actions', _('Actions'))
        ))

    def test_it_has_get_breadcrumb(self):
        self.assertTrue(hasattr(RulesListingView, 'get_breadcrumb'))

    def test_get_breadcrumb_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(RulesListingView.get_breadcrumb)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_load_name(self):
        self.assertTrue(hasattr(RulesListingView, 'load_name'))

    def test_load_name_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(RulesListingView.load_name)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_load_actions(self):
        self.assertTrue(hasattr(RulesListingView, 'load_actions'))

    def test_load_actions_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(RulesListingView.load_actions)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_get_actions(self):
        self.assertTrue(hasattr(RulesListingView, 'get_actions'))

    def test_get_actions_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(RulesListingView.get_actions)[0]
        self.assertEqual(actual_signature, expected_signature)


class RulesListingViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:tajweed:rules:listing')
        for i in range(10):
            RuleFactory(tajweed_book=TajweedBookFactory())

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


class RuleDetailsViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(RuleDetailsView, LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(RuleDetailsView, View))

    def test_it_has_get(self):
        self.assertTrue(hasattr(RuleDetailsView, 'get'))

    def test_method_get_is_callable(self):
        self.assertTrue(callable(RuleDetailsView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'rule_id']
        actual_signature = inspect.getfullargspec(RuleDetailsView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class RuleDetailsViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.rule = RuleFactory(tajweed_book=TajweedBookFactory())
        for i in range(9):
            RuleFactory(tajweed_book=TajweedBookFactory())
        self.url = reverse('admin:tajweed:rules:details', args=[1])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_404_if_translation_not_exists(self):
        response = self.client.get(reverse('admin:tajweed:rules:details', args=[10000]))
        self.assertEqual(response.status_code, 404)

    def test_object_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('rule', response.context)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_details_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _('{rule} Details').format(rule=self.rule.translated_name))

    def test_object_in_context_is_correct_one(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['rule'], self.rule)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "tajweed/rules/details.html")


class RuleCreateAndUpdateViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(RuleCreateAndUpdateView, LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(RuleCreateAndUpdateView, View))

    def test_it_has_get(self):
        self.assertTrue(hasattr(RuleCreateAndUpdateView, 'get'))

    def test_method_get_is_callable(self):
        self.assertTrue(callable(RuleCreateAndUpdateView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(RuleCreateAndUpdateView.get)[0]
        self.assertEqual(actual_signature, expected_signature)

    def test_it_has_post(self):
        self.assertTrue(hasattr(RuleCreateAndUpdateView, 'post'))

    def test_method_post_is_callable(self):
        self.assertTrue(callable(RuleCreateAndUpdateView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(RuleCreateAndUpdateView.post)[0]
        self.assertEqual(actual_signature, expected_signature)


class RuleCreateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.url = reverse('admin:tajweed:rules:create')
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "tajweed/rules/form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_rule_form(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], RuleForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_create_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _('Add New Rule'))

    def test_context_form_is_new_form(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['form'].instance.pk, None)


class RuleUpdateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.rule = RuleFactory(description='desc', tajweed_book=TajweedBookFactory())
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:tajweed:rules:update', args=[self.rule.pk])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)

        self.assertTemplateUsed(response, 'tajweed/rules/form.html')

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_rule_form(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], RuleForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_edit_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _("Edit {rule}").format(rule=self.rule.translated_name))

    def test_context_form_instance_is_equal_to_rule(self):
        response = self.client.get(self.url)
        self.assertEqual(response.context['form'].instance, self.rule)


class RuleCreateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:tajweed:rules:create')

        self.data = {
            'rule_number': 5,
            'name': 'rule name',
            'description': 'desc of rule',
            'tajweed_book': TajweedBookFactory().pk,
            'color': 'red',
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used_on_failure(self):
        self.data.pop('name')
        response = self.client.post(self.url, self.data)
        self.assertTemplateUsed(response, "tajweed/rules/form.html")

    def test_context_contains_form_instance_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn('form', response.context)

    def test_context_form_is_instance_of_rule_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], RuleForm)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_add_new_tajweed_rule_on_failure(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _('Add New Rule'))

    def test_it_saves_created_rule_into_database(self):
        self.client.post(self.url, data=self.data)
        instance = Rule.objects.all().last()
        self.assertIn(instance, Rule.objects.all())

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEqual(len(msgs), 1)

    def test_response_message_is_equal_to_created_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEqual(str(msgs[0]), _("Rule Created Successfully"))


class RuleUpdateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.rule = RuleFactory(description={'ar': 'desc'}, tajweed_book=TajweedBookFactory())
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:tajweed:rules:update', args=[self.rule.pk])
        self.data = {
            'rule_number': self.rule.rule_number,
            'name': 'new rule name',
            'description': self.rule.description,
            'tajweed_book': self.rule.tajweed_book.pk,
            'color': self.rule.color,
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_template_used(self):
        response = self.client.post(self.url)
        self.assertTemplateUsed(response, "tajweed/rules/form.html")

    def test_context_contains_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("form", response.context)

    def test_it_returns_context_form_is_instance_of_translation_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], RuleForm)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_edit_rule_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn(response.context["title"], _("Edit {rule}").format(rule=self.rule.translated_name))

    def test_it_saves_updated_rule_into_database(self):
        self.client.post(self.url, data=self.data)
        self.rule.refresh_from_db()
        self.assertEqual('new rule name', self.rule.name['ar'])

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEqual(len(msgs), 1)

    def test_response_message_is_equal_to_updated_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEqual(str(msgs[0]), _("Rule Updated Successfully"))
