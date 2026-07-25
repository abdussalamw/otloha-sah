import inspect

from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.contrib.auth.models import Permission
from django.contrib.humanize.templatetags import humanize
from django.http import HttpResponseForbidden, HttpResponseNotFound
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.safestring import mark_safe
from django.utils.translation import gettext as _
from django.views import View
from rest_framework.test import APIClient

from apps.main.views_admin import AdminListView
from apps.parts.factories import PartFactory
from apps.parts.filters import PartFilter
from apps.parts.forms import PartForm
from apps.parts.models import Part
from apps.parts.views_admin import PartListingAdminView, PartCreateAndUpdateAdminView
from apps.users.factories import UserFactory


class PartListingViewStructureTestCase(TestCase):

    # Test extended classes
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(PartListingAdminView, LoginRequiredMixin))

    def test_view_extend_PermissionRequiredMixin_class(self):
        self.assertTrue(issubclass(PartListingAdminView, PermissionRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(issubclass(PartListingAdminView, AdminListView))

    # Test model attribute
    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(PartListingAdminView, 'model'))

    def test_list_view_use_part_model(self):
        self.assertEqual(PartListingAdminView.model, Part)

    # Test filterset_class attribute
    def test_list_view_has_filterset_class(self):
        self.assertTrue(hasattr(PartListingAdminView, 'filterset_class'))

    def test_filterset_class_is_instance_of_part_filter(self):
        self.assertEqual(PartListingAdminView.filterset_class, PartFilter)

    # Test list_display attribute
    def test_list_view_has_list_display(self):
        self.assertTrue(hasattr(PartListingAdminView, 'list_display'))

    def test_list_display_with_correct_value(self):
        list_display = (
            ('id', 'id'),
            ('name', _('name')),
            ('alias', _('alias')),
            ('part_number', _('part_number')),
            ('created_at', 'created at'),
            ('updated_at', 'updated_at'),
            ('actions', _('actions'))
        )
        self.assertEqual(PartListingAdminView.list_display, list_display)

    # Test title attribute
    def test_it_has_title_attribute(self):
        self.assertTrue(hasattr(PartListingAdminView, 'title'))

    def test_title_equals_all_parts(self):
        self.assertEqual(PartListingAdminView.title, _("All Parts"))

    # Test permission_required attribute
    def test_list_view_has_permission_required_attribute(self):
        self.assertTrue(hasattr(PartListingAdminView, 'permission_required'))

    def test_list_view_permission_required_equals_view_part(self):
        self.assertEqual(PartListingAdminView.permission_required, ("parts.view_part",))

    # Test get_breadcrumb function
    def test_it_has_get_actions(self):
        self.assertTrue(hasattr(PartListingAdminView, 'get_breadcrumb'))

    def test_get_breadcrumb_is_callable(self):
        self.assertTrue(callable(getattr(PartListingAdminView, 'get_breadcrumb')))

    def test_get_breadcrumb_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(PartListingAdminView.get_breadcrumb)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test load_name function
    def test_part_has_load_name_attribute(self):
        self.assertTrue(hasattr(PartListingAdminView, 'load_name'))

    def test_load_name_is_callable(self):
        self.assertTrue(callable(getattr(PartListingAdminView, 'load_name')))

    def test_load_name_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(PartListingAdminView.load_name)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test load_alias function
    def test_part_has_load_alias_attribute(self):
        self.assertTrue(hasattr(PartListingAdminView, 'load_alias'))

    def test_load_alias_is_callable(self):
        self.assertTrue(callable(getattr(PartListingAdminView, 'load_alias')))

    def test_load_alias_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(PartListingAdminView.load_alias)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test load_created_at function
    def test_part_has_load_created_at_attribute(self):
        self.assertTrue(hasattr(PartListingAdminView, 'load_created_at'))

    def test_load_created_at_is_callable(self):
        self.assertTrue(callable(getattr(PartListingAdminView, 'load_created_at')))

    def test_load_created_at_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(PartListingAdminView.load_created_at)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test load_updated_at function
    def test_part_has_load_updated_at_attribute(self):
        self.assertTrue(hasattr(PartListingAdminView, 'load_updated_at'))

    def test_load_updated_at_is_callable(self):
        self.assertTrue(callable(getattr(PartListingAdminView, 'load_updated_at')))

    def test_load_updated_at_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(PartListingAdminView.load_updated_at)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test get_actions function
    def test_it_has_get_actions_attribute(self):
        self.assertTrue(hasattr(PartListingAdminView, 'get_actions'))

    def test_get_actions_is_callable(self):
        self.assertTrue(callable(getattr(PartListingAdminView, 'get_actions')))

    def test_get_actions_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(PartListingAdminView.get_actions)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test load_actions function
    def test_part_has_load_actions_attribute(self):
        self.assertTrue(hasattr(PartListingAdminView, 'load_actions'))

    def test_load_actions_is_callable(self):
        self.assertTrue(callable(getattr(PartListingAdminView, 'load_actions')))

    def test_load_actions_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(PartListingAdminView.load_actions)[0]
        self.assertEquals(actual_signature, expected_signature)


class PartListingViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.part = PartFactory()
        self.user.user_permissions.add(
            Permission.objects.filter(codename='view_part').last()
        )
        self.client.login(username=self.user.email, password='secret')
        self.url = reverse('admin:parts:listing')

    # Test load_alias functio
    def test_load_alias_function_return_correct_value(self):
        obj = PartFactory()
        self.assertEqual(PartListingAdminView().load_alias(obj), mark_safe('<td>{}</td>'.format(obj.translated_alias)))

    # Test load_name functio
    def test_load_name_function_return_correct_value(self):
        obj = PartFactory()
        self.assertEqual(PartListingAdminView().load_name(obj),
                         mark_safe('<td class="main-cell">{}</td>'.format(obj.translated_name)))

    # Test load_created_at functio
    def test_load_created_at_function_return_correct_value(self):
        obj = PartFactory()
        self.assertEqual(PartListingAdminView().load_created_at(obj),
                         mark_safe('<td class="main-cell">{}</td>'.format(humanize.datetime.date(obj.created_at))))

    # Test load_updated_at functio
    def test_load_updated_at_function_return_correct_value(self):
        obj = PartFactory()
        self.assertEqual(PartListingAdminView().load_updated_at(obj),
                         mark_safe('<td class="main-cell">{}</td>'.format(humanize.datetime.date(obj.updated_at))))

    # Test load_actions function
    def test_load_actions_returns_correct_html_template_for_translation(self):
        obj = self.part
        self.assertEquals(PartListingAdminView().load_actions(obj), mark_safe(
            '<td class="td--nowrap">' +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-primary"><i class="fa fa-edit"></i></a>'
            .format(reverse('admin:parts:update', args=[obj.pk]), _('Edit')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-info"><i class="fa fa-globe"></i></a>'
            .format(reverse('translation:translate_form', args=['parts', 'part', obj.pk]) + '?next={}'.format(
                reverse('admin:parts:listing')), _('Translate')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-danger"><i class="fa fa-trash"></i></a>'
            .format(
                reverse('admin:softdelete:single-delete', args=['parts', 'Part', obj.pk]) + '?next={}'.format(
                    reverse('admin:parts:listing')),
                _('Delete')) +
            '</td>'
        ))

    # Test get_actions function
    def test_get_actions_returns_correct_html_template_for_creating_new_part(self):
        self.assertEquals(
            PartListingAdminView().get_actions(),
            mark_safe('<a href="{}" class="btn btn-primary btn-block">'
                      '<i class="fas fa-plus"></i>{}</a>'.format(reverse("admin:parts:create"), _("Add New Part"))))

    def test_it_redirects_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_has_object_list_context(self):
        response = self.client.get(self.url)
        self.assertIn('object_list', response.context)

    def test_it_list_all_the_data(self):
        for _ in range(10):
            PartFactory()
        response = self.client.get(self.url)
        self.assertEquals(len(response.context_data['object_list']), 10)


class PartCreateOrUpdateViewStructureTestCase(TestCase):
    # Test extended classed
    def test_it_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(PartCreateAndUpdateAdminView, LoginRequiredMixin))

    def test_it_extend_PermissionRequiredMixin_class(self):
        self.assertTrue(issubclass(PartCreateAndUpdateAdminView, PermissionRequiredMixin))

    def test_it_extends_View_class(self):
        self.assertTrue(issubclass(PartCreateAndUpdateAdminView, View))

    # Test has_permission method
    def test_it_has_has_permission_attribute(self):
        self.assertTrue(hasattr(PartCreateAndUpdateAdminView, 'has_permission'))

    def test_view_has_method_has_permission_is_callable(self):
        self.assertTrue(callable(PartCreateAndUpdateAdminView.has_permission))

    def test_has_permission_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(PartCreateAndUpdateAdminView.has_permission)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test get method
    def test_view_has_method_get(self):
        self.assertTrue(hasattr(PartCreateAndUpdateAdminView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(PartCreateAndUpdateAdminView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(PartCreateAndUpdateAdminView.get)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test post method
    def test_view_has_method_post(self):
        self.assertTrue(hasattr(PartCreateAndUpdateAdminView, 'post'))

    def test_view_has_method_post_is_callable(self):
        self.assertTrue(callable(PartCreateAndUpdateAdminView.post))

    def test_post_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(PartCreateAndUpdateAdminView.post)[0]
        self.assertEquals(actual_signature, expected_signature)


class PartCreateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.url = reverse('admin:parts:create')
        self.client.login(email=self.user.email, password='secret')
        self.permission = Permission.objects.filter(codename='add_part').last()
        self.user.user_permissions.add(self.permission)

    def test_it_return_HttpResponseForbidden_if_user_has_no_permission(self):
        self.user.user_permissions.clear()
        response = self.client.get(self.url)
        self.assertIsInstance(response, HttpResponseForbidden)

    def test_if_part_create_redirects_to_login_when_no_authentication_done(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_used_template(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "parts/form.html")

    def test_form_is_included_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_title_is_included_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_title_is_create_new_part(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['title'], _("Part Form"))

    def test_context_form_is_instance_of_PartForm(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], PartForm)

    def test_if_the_form_of_context_is_new_form(self):
        response = self.client.get(self.url)
        self.assertEquals(response.context['form'].instance.pk, None)


class PartCreateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.url = reverse('admin:parts:create')
        self.client.login(email=self.user.email, password='secret')
        self.user.user_permissions.add(
            Permission.objects.filter(codename='view_part').last(),
            Permission.objects.filter(codename='add_part').last()
        )
        self.data = {'name': 'hafs', 'alias': 'desc', 'part_number': 1}

    def test_it_return_HttpResponseForbidden_if_user_has_no_permission(self):
        self.user.user_permissions.clear()
        response = self.client.post(self.url)
        self.assertIsInstance(response, HttpResponseForbidden)

    def test_redirect_to_login_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_the_returned_template_used_on_errors(self):
        response = self.client.post(self.url, data={})
        self.assertTemplateUsed(response, "parts/form.html")

    def test_title_is_included_in_the_context_on_errors(self):
        response = self.client.post(self.url, data={})
        self.assertIn("title", response.context)

    def test_context_form_is_instance_of_PartForm(self):
        response = self.client.post(self.url, data={})
        self.assertIsInstance(response.context['form'], PartForm)

    def test_for_has_errors(self):
        response = self.client.post(self.url, data={})
        self.assertIsNotNone(response.context['form'].errors)

    def test_it_create_save_the_data_in_database(self):
        response = self.client.post(self.url, data={'name': 'hafs', 'alias': 'desc', 'part_number': 1})
        self.assertGreater(len(Part.objects.all()), 0)

    def test_it_redirect_to_listing_after_saving(self):
        response = self.client.post(self.url, data={'name': 'hafs', 'alias': 'desc', 'part_number': 1})
        self.assertRedirects(response, reverse('admin:parts:listing'))


class PartUpdateViewGETTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.part = PartFactory(id=1, name="name", alias='name', part_number=2)
        self.url = reverse('admin:parts:update', kwargs={'part_id': self.part.pk})
        self.client.login(email=self.user.email, password='secret')
        self.user.user_permissions.add(
            Permission.objects.filter(codename='view_part').last(),
            Permission.objects.filter(codename='change_part').last()
        )

    def test_it_return_HttpResponseForbidden_if_user_has_no_permission(self):
        self.user.user_permissions.clear()
        response = self.client.get(self.url)
        self.assertIsInstance(response, HttpResponseForbidden)

    def test_if_narration_create_redirects_to_login_when_no_authentication_done(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_HttpResponseForbidden_if_object_not_exists(self):
        response = self.client.get(reverse('admin:narrations:update', args=[1000]))
        self.assertIsInstance(response, HttpResponseForbidden)

    def test_the_used_template(self):
        response = self.client.get(self.url)
        self.assertTemplateUsed(response, "parts/form.html")

    def test_form_is_included_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn("form", response.context)

    def test_title_is_included_in_the_context(self):
        response = self.client.get(self.url)
        self.assertIn("title", response.context)

    def test_context_form_is_instance_of_PartForm(self):
        response = self.client.get(self.url)
        self.assertIsInstance(response.context['form'], PartForm)

    def test_if_the_form_of_context_is_form_with_instance(self):
        response = self.client.get(self.url)
        self.assertNotEqual(response.context['form'].instance.pk, None)


class PartUpdateViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.part = PartFactory(id=1, name="name", alias='name', part_number=2)
        self.url = reverse('admin:parts:update', kwargs={'part_id': self.part.pk})
        self.client.login(email=self.user.email, password='secret')
        self.user.user_permissions.add(
            Permission.objects.filter(codename='view_part').last(),
            Permission.objects.filter(codename='change_part').last()
        )

    def test_it_return_HttpResponseForbidden_if_user_has_no_permission(self):
        self.user.user_permissions.clear()
        response = self.client.post(self.url)
        self.assertIsInstance(response, HttpResponseForbidden)

    def test_if_narration_create_redirects_to_login_when_no_authentication_done(self):
        self.client.logout()
        response = self.client.post(self.url)
        self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    def test_it_return_HttpResponseNotFound_if_object_not_exists(self):
        response = self.client.post(reverse('admin:parts:update', args=[1000]))
        self.assertIsInstance(response, HttpResponseNotFound)

    def test_the_returned_template_used_on_errors(self):
        response = self.client.post(self.url, data={})
        self.assertTemplateUsed(response, "parts/form.html")

    def test_title_is_included_in_the_context_on_errors(self):
        response = self.client.post(self.url, data={})
        self.assertIn("title", response.context)

    def test_context_form_is_instance_of_PartForm(self):
        response = self.client.post(self.url, data={})
        self.assertIsInstance(response.context['form'], PartForm)

    def test_form_has_errors(self):
        response = self.client.post(self.url, data={})
        self.assertIsNotNone(response.context['form'].errors)

    def test_it_create_save_the_data_in_database(self):
        response = self.client.post(self.url, data={'name': 'hafs', 'alias': 'hafs alias', 'part_number': 1})
        self.part.refresh_from_db()
        self.assertEquals(self.part.name['ar'], 'hafs')

    def test_it_redirect_to_listing_after_saving(self):
        response = self.client.post(self.url, data={'name': 'hafs', 'alias': 'hafs alias', 'part_number': 1})
        self.assertRedirects(response, reverse('admin:parts:listing'))
