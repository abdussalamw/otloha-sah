import inspect

from django.conf import settings
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.contrib.auth.models import Permission
from django.test import TestCase, Client, RequestFactory
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View

from apps.main.views_admin import AdminListView
from apps.recitations.factories import ReciterFactory
from apps.recitations.models import Reciter
from apps.recitations.reciter.filters import ReciterAPIFilter
from apps.recitations.reciter.forms import ReciterForm
from apps.recitations.reciter.views_admin import ReciterListAdminView, ReciterDetailsView, \
    ReciterCreateOrUpdateView
from apps.users.factories import UserFactory


class ReciterAdminListViewStructureTestCase(TestCase):
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(ReciterListAdminView, LoginRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(issubclass(ReciterListAdminView, AdminListView))
        
    def test_view_extend_PermissionRequiredMixin_class(self):
        self.assertTrue(issubclass(ReciterListAdminView, PermissionRequiredMixin))

    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(ReciterListAdminView, 'model'))

    def test_list_view_use_recitation_model(self):
        self.assertEqual(ReciterListAdminView.model, Reciter)

    def test_list_view_has_permission_required_attribute(self):
        self.assertTrue(hasattr(ReciterListAdminView, 'permission_required'))

    def test_permission_required_attribute_value_has_view_permission(self):
        self.assertIn('recitations.view_reciter', ReciterListAdminView.permission_required)

    def test_list_view_has_filter_set_class(self):
        self.assertTrue(hasattr(ReciterListAdminView, 'filterset_class'))

    def test_list_view_use_recitation_filter(self):
        self.assertEqual(ReciterListAdminView.filterset_class, ReciterAPIFilter)

    def test_list_view_has_title(self):
        self.assertTrue(hasattr(ReciterListAdminView, 'title'))

    def test_list_view_title_value(self):
        self.assertEquals(ReciterListAdminView.title, _('All Reciters'))

    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(ReciterListAdminView, 'list_display'))

    def test_list_display_value(self):
        self.assertEquals(ReciterListAdminView.list_display, (
            ('id', _('ID')),
            ('name', _('name')),
            ('created_at', _('created at')),
            ('updated_at', _('updated_at')),
        ))

    def test_reciter_has_load_name(self):
        self.assertTrue(hasattr(ReciterListAdminView, 'load_name'))

    def test_load_name_is_callable(self):
        self.assertTrue(callable(getattr(ReciterListAdminView, 'load_name')))

    def test_load_name_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(ReciterListAdminView.load_name)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_get_queryset(self):
        self.assertTrue(hasattr(ReciterListAdminView, 'get_queryset'))

    def test_get_queryset_is_callable(self):
        self.assertTrue(callable(getattr(ReciterListAdminView, 'get_queryset')))

    def test_get_queryset_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(ReciterListAdminView.get_queryset)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_get_actions(self):
        self.assertTrue(hasattr(ReciterListAdminView, 'get_actions'))

    def test_get_actions_at_is_callable(self):
        self.assertTrue(callable(getattr(ReciterListAdminView, 'get_actions')))

    def test_get_actions_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(ReciterListAdminView.get_actions)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_reciter_has_load_created_at(self):
        self.assertTrue(hasattr(ReciterListAdminView, 'load_created_at'))

    def test_load_created_at_is_callable(self):
        self.assertTrue(callable(getattr(ReciterListAdminView, 'load_created_at')))

    def test_load_created_at_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(ReciterListAdminView.load_created_at)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_reciter_has_load_updated_at(self):
        self.assertTrue(hasattr(ReciterListAdminView, 'load_updated_at'))

    def test_load_updated_at_is_callable(self):
        self.assertTrue(callable(getattr(ReciterListAdminView, 'load_updated_at')))

    def test_load_updated_at_method_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(ReciterListAdminView.load_updated_at)[0]
        self.assertEquals(actual_signature, expected_signature)


class ReciterAdminListViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.reciter = ReciterFactory()
        self.user.user_permissions.add(Permission.objects.get(codename='view_reciter'))
        self.url = reverse('admin:recitations:reciters:listing')
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    # todo: solve the error
    # def test_it_has_object_list_in_the_context(self):
    #     response = self.client.get(self.url)
    #     print(response.context['object_list'])
    #     self.assertIn('object_list', response.context)
    #
    # def test_it_return_the_correct_data(self):
    #     response = self.client.get(self.url)
    #     self.assertQuerysetEqual(Reciter.objects.all(), response.context['object_list'], ordered=False)


class ReciterDetailsViewStructureTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(issubclass(ReciterDetailsView, LoginRequiredMixin))

    def test_view_extend_permission_required_mixin(self):
        self.assertTrue(issubclass(ReciterDetailsView, PermissionRequiredMixin))

    def test_view_extend_View_class(self):
        self.assertTrue(issubclass(ReciterDetailsView, View))

    def test_it_has_permission_required_attribute(self):
        self.assertTrue(hasattr(ReciterDetailsView, 'permission_required'))

    def test_permission_required_attribute_value_has_view_permission(self):
        self.assertIn('recitations.view_reciter', ReciterDetailsView.permission_required)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(ReciterDetailsView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(ReciterDetailsView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'reciter_id']
        actual_signature = inspect.getfullargspec(ReciterDetailsView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class ReciterDetailsViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.reciter = ReciterFactory()
        self.user.user_permissions.add(Permission.objects.get(codename='view_reciter'))
        self.url = reverse('admin:recitations:reciters:details', args=[self.reciter.pk])
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_403_if_user_does_not_have_permission(self):
        self.user.user_permissions.clear()
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, 403)

    def test_it_return_404_if_reciter_does_not_exists(self):
        response = self.client.get(reverse('admin:recitations:reciters:details', args=[10000]))
        self.assertEqual(response.status_code, 404)

    def test_reciter_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('reciter', response.context)

    def test_context_reciter_is_correct(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['reciter'], self.reciter)

    def test_title_exists_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn('title', response.context)

    def test_context_title_is_create_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], "{} {}".format(self.reciter.translated_name, _("Details")))

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "recitations/reciter/details.html")


class ReciterCreateOrUpdateViewStructureTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(issubclass(ReciterCreateOrUpdateView, LoginRequiredMixin))

    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(ReciterCreateOrUpdateView, View))

    def test_view_extend_permission_required_mixin(self):
        self.assertTrue(issubclass(ReciterCreateOrUpdateView, PermissionRequiredMixin))

    def test_it_has_get_permission_required_attribute(self):
        self.assertTrue(hasattr(ReciterCreateOrUpdateView, 'get_permission_required'))

    def test_view_has_method_get_permission_required_is_callable(self):
        self.assertTrue(callable(ReciterCreateOrUpdateView.get_permission_required))

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(ReciterCreateOrUpdateView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(ReciterCreateOrUpdateView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(ReciterCreateOrUpdateView.get)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_view_has_method_post(self):
        self.assertTrue(hasattr(ReciterCreateOrUpdateView(), 'post'))

    def test_view_has_method_post_is_callable(self):
        self.assertTrue(callable(ReciterCreateOrUpdateView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(ReciterCreateOrUpdateView.post)[0]
        self.assertEquals(actual_signature, expected_signature)


class ReciterCreateOrUpdateViewGetPermissionRequiredTestCase(TestCase):
    def setup_view(self, view, request, *args, **kwargs):
        view.request = request
        view.args = args
        view.kwargs = kwargs
        return view

    def setUp(self):
        self.factory = RequestFactory()

    def test_it_has_returns_add_permission_if_reciter_id_is_not_available(self):
        request = self.factory.get(reverse('admin:recitations:reciters:create'))
        view = self.setup_view(ReciterCreateOrUpdateView(), request)
        self.assertEquals(view.get_permission_required(), ("recitations.add_reciter",))

    def test_it_has_returns_change_permission_if_reciter_id_is_available(self):
        reciter = ReciterFactory()
        request = self.factory.get(reverse('admin:recitations:reciters:update', kwargs={"reciter_id": reciter.id}))
        view = self.setup_view(ReciterCreateOrUpdateView(), request, reciter_id=reciter.id)
        self.assertEquals(view.get_permission_required(), ("recitations.change_reciter",))


class ReciterCreateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.user.user_permissions.add(Permission.objects.get(codename='add_reciter'))
        self.url = reverse('admin:recitations:reciters:create')
        self.client.login(email=self.user.email, password='secret')

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_403_if_user_does_not_have_permission(self):
        self.user.user_permissions.clear()
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, 403)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "recitations/reciter/form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_book_form(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], ReciterForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_create_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _("Add New Reciter"))

    def test_context_form_is_new_form(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['form'].instance.pk, None)


class ReciterUpdateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.user.user_permissions.add(Permission.objects.get(codename='change_reciter'))
        self.reciter = ReciterFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:recitations:reciters:update', args=[self.reciter.pk])

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_403_if_user_does_not_have_permission(self):
        self.user.user_permissions.clear()
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, 403)

    def test_template_used(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "recitations/reciter/form.html")

    def test_context_contains_form(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_ReciterForm(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], ReciterForm)

    def test_context_contains_title(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_edit_title(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], "{} {}".format(_("Edit"), self.reciter.translated_name))

    def test_context_form_instance_is_equal_to_reciter(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['form'].instance, self.reciter)


class ReciterCreateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.user.user_permissions.add(Permission.objects.get(codename='add_reciter'))
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:recitations:reciters:create')
        self.data = {'name': "test", }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_403_if_user_does_not_have_permission(self):
        self.user.user_permissions.clear()
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, 403)

    def test_template_used_on_failure(self):
        self.data.pop('name')
        response = self.client.post(self.url, self.data)
        self.assertTemplateUsed(response, "recitations/reciter/form.html")

    def test_context_contains_form_instance_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn('form', response.context)

    def test_context_form_is_instance_of_book_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], ReciterForm)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_context_contains_title_on_failure(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_create_title_on_failure(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], _("Add New Reciter"))

    def test_it_saves_created_reciter_into_database(self):
        self.client.post(self.url, data=self.data)
        instance = Reciter.objects.get(name={settings.LANGUAGE_CODE: self.data['name']})
        self.assertIn(instance, Reciter.objects.all())

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEquals(len(msgs), 1)

    def test_response_message_is_equal_to_created_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEquals(str(msgs[0]), _("Reciter Created Successfully"))


class ReciterUpdateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.user.user_permissions.add(Permission.objects.get(codename='change_reciter'))
        self.reciter = ReciterFactory()
        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:recitations:reciters:update', args=[self.reciter.pk])
        self.data = {'name': "test", }

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_returns_403_if_user_does_not_have_permission(self):
        self.user.user_permissions.clear()
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, 403)

    def test_template_used_on_failure(self):
        self.data.pop('name')
        response = self.client.post(self.url, self.data)
        self.assertTemplateUsed(response, "recitations/reciter/form.html")

    def test_context_contains_form_instance_on_failure(self):
        response = self.client.post(self.url)
        self.assertIn('form', response.context)

    def test_context_form_is_instance_of_book_form_on_failure(self):
        response = self.client.post(self.url)
        self.assertIsInstance(response.context['form'], ReciterForm)

    def test_context_form_contains_errors_on_failure(self):
        response = self.client.post(self.url)
        self.assertGreater(len(response.context['form'].errors.as_data().keys()), 0)

    def test_context_contains_title_on_failure(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_create_title_on_failure(self):
        response = self.client.get(self.url)
        self.assertIn(response.context["title"], "{} {}".format(_("Edit"), self.reciter.translated_name))

    def test_it_updates_reciter_instance(self):
        self.client.post(self.url, data=self.data)
        self.reciter.refresh_from_db()
        self.assertEquals(self.reciter.name[settings.LANGUAGE_CODE], self.data['name'])

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEquals(len(msgs), 1)

    def test_response_message_is_equal_to_created_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEquals(str(msgs[0]), _("Reciter Updated Successfully"))
