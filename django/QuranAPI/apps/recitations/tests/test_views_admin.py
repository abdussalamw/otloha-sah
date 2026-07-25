import inspect

from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.narrations.factories import NarrationFactory
from apps.recitations.views_admin import RecitationListAdminView, \
    RecitationDetailAdminView, RecitationCreateAndUpdateView
from apps.recitations.factories import ReciterFactory, RecitationFactory
from apps.recitations.filters import RecitationFilter
from apps.recitations.forms import RecitationForm
from apps.recitations.models import Recitation
from apps.users.factories import UserFactory


class RecitationAdminListViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(RecitationListAdminView, LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(issubclass(RecitationListAdminView, AdminListView))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(RecitationListAdminView, 'model'))

    def test_list_view_use_recitation_model(self):
        self.assertEqual(RecitationListAdminView.model, Recitation)

    def test_list_view_has_filter_set_class(self):
        self.assertTrue(hasattr(RecitationListAdminView, 'filterset_class'))

    def test_list_view_use_recitation_filter(self):
        self.assertEqual(RecitationListAdminView.filterset_class, RecitationFilter)

    def test_list_view_has_title(self):
        self.assertTrue(hasattr(RecitationListAdminView, 'title'))

    def test_list_view_title_value(self):
        self.assertEquals(RecitationListAdminView.title, _('All Recitations'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(RecitationListAdminView, 'list_display'))

    def test_list_display_value(self):
        self.assertEquals(RecitationListAdminView.list_display, (
            ('id', _('ID')),
            ('name', _('Name')),
            ('narration', _('Narration')),
            ('reciter', _('Reciter')),
            ('actions', _('Actions'))
        ))

    def test_it_has_load_narration(self):
        self.assertTrue(hasattr(RecitationListAdminView, 'load_narration'))

    def test_load_narration_is_callable(self):
        self.assertTrue(callable(getattr(RecitationListAdminView, 'load_narration')))
        
    def test_load_narration_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(RecitationListAdminView.load_narration)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_load_reciter(self):
        self.assertTrue(hasattr(RecitationListAdminView, 'load_reciter'))

    def test_load_reciter_is_callable(self):
        self.assertTrue(callable(getattr(RecitationListAdminView, 'load_reciter')))

    def test_load_reciter_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(RecitationListAdminView.load_reciter)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_load_actions(self):
        self.assertTrue(hasattr(RecitationListAdminView, 'load_actions'))

    def test_load_actions_at_is_callable(self):
        self.assertTrue(callable(getattr(RecitationListAdminView, 'load_actions')))

    def test_load_actions_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(RecitationListAdminView.load_actions)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_load_name(self):
        self.assertTrue(hasattr(RecitationListAdminView, 'load_name'))

    def test_load_name_is_callable(self):
        self.assertTrue(callable(getattr(RecitationListAdminView, 'load_name')))

    def test_load_name_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(RecitationListAdminView.load_name)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_get_queryset(self):
        self.assertTrue(hasattr(RecitationListAdminView, 'get_queryset'))

    def test_get_queryset_is_callable(self):
        self.assertTrue(callable(getattr(RecitationListAdminView, 'get_queryset')))

    def test_get_queryset_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(RecitationListAdminView.get_queryset)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_get_actions(self):
        self.assertTrue(hasattr(RecitationListAdminView, 'get_actions'))

    def test_get_actions_at_is_callable(self):
        self.assertTrue(callable(getattr(RecitationListAdminView, 'get_actions')))

    def test_get_actions_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(RecitationListAdminView.get_actions)[0]
        self.assertEquals(actual_signature, expected_signature)


class RecitationAdminListViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.recitation = RecitationFactory(reciter=ReciterFactory(), narration=NarrationFactory())
        self.url = reverse('admin:recitations:listing')
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
        self.assertQuerysetEqual(Recitation.objects.all(), response.context['object_list'], ordered=False)


class RecitationDetailAdminViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(RecitationDetailAdminView, LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(RecitationDetailAdminView, View))

    def test_it_has_get(self):
        self.assertTrue(hasattr(RecitationDetailAdminView, 'get'))

    def test_method_get_is_callable(self):
        self.assertTrue(callable(RecitationDetailAdminView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'recitation_id']
        actual_signature = inspect.getfullargspec(RecitationDetailAdminView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class RecitationDetailAdminViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.reciter = ReciterFactory()
        self.narration = NarrationFactory()
        self.recitation = RecitationFactory(reciter=self.reciter, narration=self.narration)
        self.url = self.recitation.get_details_url
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_404_if_book_not_exists(self):
        response = self.client.get(reverse('admin:recitations:details', args=[10000]))
        self.assertEqual(response.status_code, 404)

    def test_recitation_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('recitation', response.context)

    def test_title_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('title', response.context)

    def test_context_title_is_details_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _('Recitation Details'))

    def test_object_in_context_is_correct_one(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['recitation'], self.recitation)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "recitations/recitation/details.html")


class RecitationCreateAndUpdateViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(RecitationCreateAndUpdateView, LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(RecitationCreateAndUpdateView, View))

    def test_it_has_get(self):
        self.assertTrue(hasattr(RecitationCreateAndUpdateView, 'get'))

    def test_method_get_is_callable(self):
        self.assertTrue(callable(RecitationCreateAndUpdateView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(RecitationCreateAndUpdateView.get)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_post(self):
        self.assertTrue(hasattr(RecitationCreateAndUpdateView, 'post'))

    def test_method_post_is_callable(self):
        self.assertTrue(callable(RecitationCreateAndUpdateView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(RecitationCreateAndUpdateView.post)[0]
        self.assertEquals(actual_signature, expected_signature)


class RecitationCreateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.url = reverse('admin:recitations:create')
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "recitations/recitation/form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_recitation_form(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], RecitationForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_create_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _("Add New Recitation"))

    def test_context_form_is_new_form(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['form'].instance.pk, None)


class RecitationUpdateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.reciter = ReciterFactory()
        self.narration = NarrationFactory()
        self.recitation = RecitationFactory(reciter=self.reciter, narration=self.narration)
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:recitations:update', args=[self.recitation.pk])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "recitations/recitation/form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_RecitationForm(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], RecitationForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_edit_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], "{} {}".format(_("Edit"), self.recitation.translated_name))

    def test_context_form_instance_is_equal_to_recitation(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['form'].instance, self.recitation)


class RecitationCreateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:recitations:create')
        self.reciter = ReciterFactory()

        self.data = {
            'name': '{"ar":"تست"}',
            'reciter': self.reciter.pk,
            'narration': NarrationFactory().pk
        }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_template_used_on_failure(self):
        self.data.pop('name')
        response = self.client.post(self.url, self.data)
        self.assertTemplateUsed(response, "recitations/recitation/form.html")

    def test_context_contains_form_instance_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn('form', response.context)

    def test_context_form_is_instance_of_book_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], RecitationForm)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_add_new_translation_title_on_failure(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _('Add New Recitation'))

    def test_it_saves_created_reciter_into_database(self):
        self.client.post(self.url, data=self.data)
        instance = Recitation.objects.all().last()
        self.assertIn(instance, Recitation.objects.all())

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEquals(len(msgs), 1)

    def test_response_message_is_equal_to_created_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEquals(str(msgs[0]), _("Recitation Created Successfully"))


class RecitationUpdateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.reciter = ReciterFactory()
        self.narration = NarrationFactory()
        self.recitation = RecitationFactory(reciter=self.reciter, narration=self.narration)
        self.data = {
            "name": "this is recitation name",
            'narration': self.narration.pk,
            'reciter': self.reciter.pk,
        }
        # login the user
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:recitations:update', args=[self.recitation.pk])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_template_used(self):
        response = self.client.post(self.url)
        self.assertTemplateUsed(response, "recitations/recitation/form.html")

    def test_context_contains_form(self):
        response = self.client.post(self.url)
        self.assertIn("form", response.context)

    def test_it_returns_context_form_is_instance_from_RecitationForm(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], RecitationForm)

    def test_context_contains_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_add_edit_translation_title_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn(response.context["title"], "{} {}".format(_("Edit"), self.recitation.translated_name))

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEquals(len(msgs), 1)

    def test_response_message_is_equal_to_updated_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEquals(str(msgs[0]), _("Recitation Updated Successfully"))

    def test_it_saves_request_data_on_success(self):
        response = self.client.post(self.url, data=self.data)
        self.recitation.refresh_from_db()
        self.assertEquals(self.recitation.name['ar'], "this is recitation name")