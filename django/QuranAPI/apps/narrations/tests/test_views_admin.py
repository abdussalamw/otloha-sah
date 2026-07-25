import inspect

from django.contrib.auth.models import Permission
from django.http import HttpResponseForbidden, HttpResponseNotFound
from django.test import TestCase, Client, RequestFactory
from django.utils.translation import gettext as _
from rest_framework.test import APIClient

from apps.narrations.factories import NarrationFactory
from apps.narrations.views_admin import *
from apps.users.factories import UserFactory


class NarrationListingViewStructureTestCase(TestCase):
    # Test extended classes
    def test_it_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(NarrationListingView, LoginRequiredMixin))

    def test_it_extend_AdminListView_class(self):
        self.assertTrue(issubclass(NarrationListingView, AdminListView))

    # Test model attribute
    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(NarrationListingView, 'model'))

    def test_list_view_use_narration_model(self):
        self.assertEqual(NarrationListingView.model, Narration)

    # Test list_display attribute
    def test_it_has_list_display(self):
        self.assertTrue(hasattr(NarrationListingView, 'list_display'))

    def test_list_display_with_correct_value(self):
        list_display = (
            ('id', _('ID')),
            ('name', _('Name')),
            ('is_active', _('Is Active')),
            ('created_at', _('Created At')),
            ('updated_at', _('Updated At')),
            ('actions', _('Actions'))
        )
        self.assertEqual(NarrationListingView.list_display, list_display)

    # Test get_breadcrumb function
    def test_it_has_get_breadcrumb(self):
        self.assertTrue(hasattr(NarrationListingView, 'get_breadcrumb'))

    def test_get_breadcrumb_is_callable(self):
        self.assertTrue(callable(getattr(NarrationListingView, 'get_breadcrumb')))

    def test_get_breadcrumb_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(NarrationListingView.get_breadcrumb)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test load_name function
    def test_it_has_load_name_attribute(self):
        self.assertTrue(hasattr(NarrationListingView, 'load_name'))

    def test_load_name_is_callable(self):
        self.assertTrue(callable(getattr(NarrationListingView, 'load_name')))

    def test_load_name_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(NarrationListingView.load_name)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_it_has_load_is_active_attribute(self):
        self.assertTrue(hasattr(NarrationListingView, 'load_is_active'))

    def test_load_is_active_is_callable(self):
        self.assertTrue(callable(getattr(NarrationListingView, 'load_is_active')))

    def test_load_is_active_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(NarrationListingView.load_is_active)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test load_created_at function
    def test_it_has_load_created_at_attribute(self):
        self.assertTrue(hasattr(NarrationListingView, 'load_created_at'))

    def test_load_created_at_is_callable(self):
        self.assertTrue(callable(getattr(NarrationListingView, 'load_created_at')))

    def test_load_created_at_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(NarrationListingView.load_created_at)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test load_updated_at function
    def test_it_has_load_updated_at_attribute(self):
        self.assertTrue(hasattr(NarrationListingView, 'load_updated_at'))

    def test_load_updated_at_is_callable(self):
        self.assertTrue(callable(getattr(NarrationListingView, 'load_updated_at')))

    def test_load_updated_at_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(NarrationListingView.load_updated_at)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test get_actions function
    def test_it_has_get_actions_attribute(self):
        self.assertTrue(hasattr(NarrationListingView, 'get_actions'))

    def test_get_actions_is_callable(self):
        self.assertTrue(callable(getattr(NarrationListingView, 'get_actions')))

    def test_get_actions_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(NarrationListingView.get_actions)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test load_actions function
    def test_it_has_load_actions_attribute(self):
        self.assertTrue(hasattr(NarrationListingView, 'load_actions'))

    def test_load_actions_is_callable(self):
        self.assertTrue(callable(getattr(NarrationListingView, 'load_actions')))

    def test_load_actions_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(NarrationListingView.load_actions)[0]
        self.assertEquals(actual_signature, expected_signature)


class NarrationListingViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.narration = NarrationFactory()
        # self.token = Token.objects.create(user=self.user)
        # self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.token.key)
        self.user.user_permissions.add(
            Permission.objects.filter(codename='view_narration').last()
        )
        self.client.login(username=self.user.email, password='secret')
        self.url = reverse('admin:narrations:listing')

    def test_load_name_returns_correct_html_template_for_narration_name(self):
        self.assertEquals(NarrationListingView().load_name(self.narration),
                          '<td class="main-cell"><a href="{}">{}</a></td>'.format(
                              reverse('admin:narrations:details', args=[self.narration.pk]),
                              self.narration.translated_name))

    def test_created_at_returns_correct_html_template_for_narration_created_at(self):
        self.assertEquals(NarrationListingView().load_created_at(self.narration),
                          mark_safe('<td>{}</td>'.format(humanize.datetime.date(self.narration.created_at))))

    def test_updated_at_returns_correct_html_template_for_narration_updated_at(self):
        obj = self.narration
        self.assertEquals(NarrationListingView().load_updated_at(self.narration),
                          mark_safe('<td>{}</td>'.format(humanize.datetime.date(self.narration.updated_at))))

    def test_get_actions_returns_correct_html_template_for_creating_new_narration(self):
        obj = self.narration
        details = reverse('admin:narrations:create')
        self.assertEquals(NarrationListingView().get_actions(),
                          '<a href="{}" class="btn btn-primary btn-sm">'
                          '<i class="fas fa-plus"></i>{}</a>'.format(reverse("admin:narrations:create"),
                                                                     _("Add New Narration")))

    def test_load_actions_returns_correct_html_template_for_translation(self):
        obj = self.narration
        self.assertEquals(
            NarrationListingView().load_actions(obj),
            mark_safe(
                '<td class="td--nowrap">' +
                '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-primary"><i class="fa fa-edit"></i></a>'
                .format(obj.get_edit_url, _('Edit')) +
                '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-info"><i class="fa fa-globe"></i></a>'
                .format(obj.get_translate_url, _('Translate')) +
                '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-danger"><i class="fa fa-trash"></i></a>'
                .format(obj.get_delete_url, _('Delete')) +
                '</td>'
            ))

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_has_object_list_context(self):
        response = self.client.get(self.url)
        self.assertIn('object_list', response.context)

    def test_it_list_all_the_data(self):
        for _ in range(10):
            NarrationFactory()
        response = self.client.get(self.url)
        self.assertEquals(len(response.context_data['object_list']), 10)


class NarrationCreateOrUpdateViewStructureTestCase(TestCase):
    # Test extended classed
    def test_if_narration_create_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(NarrationCreateAndUpdateAdminView, LoginRequiredMixin))

    def test_if_narration_create_view_extend_PermissionRequiredMixin_class(self):
        self.assertTrue(issubclass(NarrationCreateAndUpdateAdminView, PermissionRequiredMixin))

    def test_if_view_extends_View_class(self):
        self.assertTrue(issubclass(NarrationCreateAndUpdateAdminView, View))

    # Test get_permssion_required
    def test_it_has_get_permission_required_attribute(self):
        self.assertTrue(hasattr(NarrationCreateAndUpdateAdminView, 'get_permission_required'))

    def test_view_has_method_get_permission_required_is_callable(self):
        self.assertTrue(callable(NarrationCreateAndUpdateAdminView.get_permission_required))

    def test_get_permission_required_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(NarrationCreateAndUpdateAdminView.get_permission_required)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test get method
    def test_it_has_method_get(self):
        self.assertTrue(hasattr(NarrationCreateAndUpdateAdminView, 'get'))

    def test_get_method_is_callable(self):
        self.assertTrue(callable(NarrationCreateAndUpdateAdminView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(NarrationCreateAndUpdateAdminView.get)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test post method
    def test_view_has_method_post(self):
        self.assertTrue(hasattr(NarrationCreateAndUpdateAdminView, 'post'))

    def test_view_has_method_post_is_callable(self):
        self.assertTrue(callable(NarrationCreateAndUpdateAdminView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(NarrationCreateAndUpdateAdminView.post)[0]
        self.assertEquals(actual_signature, expected_signature)


class NarrationCreateAndUpdateAdminViewGetPermissionRequiredTestCase(TestCase):
    def setup_view(self, view, request, *args, **kwargs):
        view.request = request
        view.args = args
        view.kwargs = kwargs
        return view

    def setUp(self):
        self.factory = RequestFactory()

    def test_it_returns_add_permission_if_narration_id_is_not_available(self):
        request = self.factory.get(reverse('admin:narrations:create'))
        view = self.setup_view(NarrationCreateAndUpdateAdminView(), request)
        self.assertEquals(view.get_permission_required(), ("narrations.add_narration",))

    def test_it_returns_change_permission_if_narration_id_is_available(self):
        narration = NarrationFactory()
        request = self.factory.get(reverse('admin:narrations:update', args=[narration.id]))
        view = self.setup_view(NarrationCreateAndUpdateAdminView(), request, narration_id=narration.pk)
        self.assertEquals(view.get_permission_required(), ("narrations.change_narration",))


class NarrationCreateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.url = reverse('admin:narrations:create')
        self.client.login(email=self.user.email, password='secret')
        self.permission = Permission.objects.filter(codename='add_narration').last()
        self.user.user_permissions.add(self.permission)

    def test_it_return_HttpResponseForbidden_if_user_has_no_permission(self):
        self.user.user_permissions.clear()
        response = self.client.get(self.url)
        self.assertIsInstance(response, HttpResponseForbidden)

    def test_if_narration_create_redirects_to_login_when_no_authentication_done(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_the_used_template(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "narrations/form.html")

    def test_form_is_included_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_title_is_included_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_create_new_narration(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['title'], _("Add New Narration"))

    def test_context_form_is_instance_of_NarrationForm(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], NarrationForm)

    def test_if_the_form_of_context_is_new_form(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['form'].instance.pk, None)


class NarrationCreateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.permission = Permission.objects.get(codename='add_narration')
        self.user.user_permissions.add(
            Permission.objects.filter(codename='view_narration').last(),
            Permission.objects.filter(codename='add_narration').last()
        )
        self.url = reverse('admin:narrations:create')
        self.client.login(email=self.user.email, password='secret')
        self.data = {'name': 'hafs', 'description': 'desc'}

    def test_it_return_HttpResponseForbidden_if_user_has_no_permission(self):
        self.user.user_permissions.clear()
        response = self.client.post(self.url)
        self.assertIsInstance(response, HttpResponseForbidden)

    def test_if_narration_create_redirects_to_login_when_no_authentication_done(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_the_returned_template_used_on_errors(self):
        response = self.client.post(self.url, data={})
        self.assertTemplateUsed(response, "narrations/form.html")

    def test_title_is_included_in_the_context_on_errors(self):
        response = self.client.post(self.url, data={})
        self.assertIn("title", response.context)

    def test_context_title_is_create_new_narration_on_errors(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['title'], _("Add New Narration"))

    def test_form_is_included_in_the_context_on_errors(self):
        response = self.client.post(self.url, data={})
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_NarrationForm(self):
        response = self.client.post(self.url, data={})
        self.assertIsInstance(response.context['form'], NarrationForm)

    def test_for_has_errors(self):
        response = self.client.post(self.url, data={})
        self.assertIsNotNone(response.context['form'].errors)

    def test_it_create_save_the_data_in_database(self):
        response = self.client.post(self.url, data={'name': 'hafs', 'description': 'desc'})
        self.assertGreater(len(Narration.objects.all()), 0)

    def test_it_redirect_to_listing_after_saving(self):
        response = self.client.post(self.url, self.data)

        self.assertRedirects(response, reverse('admin:narrations:details', args=[1]), fetch_redirect_response=False)

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEquals(len(msgs), 1)

    def test_response_message_is_equal_to_created_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEquals(str(msgs[0]), _("Narration Created Successfully"))


class NarrationUpdateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.narration = NarrationFactory(id=1, name="name", description='desc')
        self.url = reverse('admin:narrations:update', kwargs={'narration_id': self.narration.pk})
        self.client.login(email=self.user.email, password='secret')
        self.permission = Permission.objects.get(codename='change_narration')
        self.user.user_permissions.add(self.permission)

    def test_it_return_HttpResponseForbidden_if_user_has_no_permission(self):
        self.user.user_permissions.clear()
        response = self.client.get(self.url)
        self.assertIsInstance(response, HttpResponseForbidden)

    def test_if_narration_create_redirects_to_login_when_no_authentication_done(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_HttpResponseNotFound_if_object_not_exists(self):
        response = self.client.get(reverse('admin:narrations:update', args=[1000]))
        self.assertIsInstance(response, HttpResponseNotFound)

    def test_the_used_template(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "narrations/form.html")

    def test_form_is_included_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_title_is_included_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_create_new_narration(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['title'], "{} {}".format(_("Edit"), self.narration.translated_name))

    def test_context_form_is_instance_of_NarrationForm(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], NarrationForm)

    def test_if_the_form_of_context_is_form_with_instance(self):
        response = self.client.get(self.url)
        self.assertNotEqual(response.context['form'].instance.pk, None)


class NarrationUpdateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.narration = NarrationFactory(id=1, name="name", description='desc')
        self.url = reverse('admin:narrations:update', kwargs={'narration_id': self.narration.pk})
        self.client.login(email=self.user.email, password='secret')
        self.permission = Permission.objects.get(codename='change_narration')
        self.user.user_permissions.add(self.permission)
        self.data = {'name': 'hafs', 'description': 'desc'}

    def test_it_return_HttpResponseForbidden_if_user_has_no_permission(self):
        self.user.user_permissions.clear()
        response = self.client.post(self.url)
        self.assertIsInstance(response, HttpResponseForbidden)

    def test_if_narration_create_redirects_to_login_when_no_authentication_done(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_HttpResponseNotFound_if_object_not_exists(self):
        response = self.client.post(reverse('admin:narrations:update', args=[1000]))
        self.assertIsInstance(response, HttpResponseNotFound)

    def test_the_returned_template_used_on_errors(self):
        response = self.client.post(self.url, data={})
        self.assertTemplateUsed(response, "narrations/form.html")

    def test_title_is_included_in_the_context_on_errors(self):
        response = self.client.post(self.url, data={})
        self.assertIn("title", response.context)

    def test_form_is_included_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_context_form_is_instance_of_NarrationForm(self):
        response = self.client.post(self.url, data={})
        self.assertIsInstance(response.context['form'], NarrationForm)

    def test_context_title_is_create_new_narration(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['title'], "{} {}".format(_("Edit"), self.narration.translated_name))

    def test_form_has_errors(self):
        response = self.client.post(self.url, data={})
        self.assertIsNotNone(response.context['form'].errors)

    def test_it_create_save_the_data_in_database(self):
        self.client.post(self.url, data=self.data)
        self.narration.refresh_from_db()
        self.assertEquals(self.narration.name['ar'], 'hafs')

    def test_it_redirect_to_details_after_saving(self):
        response = self.client.post(self.url, data=self.data)
        obj = Narration.objects.last()
        self.assertRedirects(response, reverse('admin:narrations:details', args=[self.narration.pk]),
                             fetch_redirect_response=False)

    def test_response_contains_success_message(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = messages.get_messages(response.wsgi_request)
        self.assertEquals(len(msgs), 1)

    def test_response_message_is_equal_to_created_successfully(self):
        response = self.client.post(self.url, data=self.data, follow=True)
        msgs = list(messages.get_messages(response.wsgi_request))
        self.assertEquals(str(msgs[0]), _("Narration Updated Successfully"))
