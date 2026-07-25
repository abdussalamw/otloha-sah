import inspect

from django.contrib.auth.models import Permission
from django.http import HttpResponseForbidden, HttpResponseNotFound
from django.test import TestCase, Client, RequestFactory
from django.utils.translation import gettext as _

from apps.chapters.factories import *
from apps.chapters.views_admin import *
from apps.users.factories import UserFactory


class ChapterAdminListingStructureViewTestCase(TestCase):
    # Test extended classed
    def test_view_extend_LoginRequiredMixin_class(self):
        self.assertTrue(issubclass(ChapterListingAdminView, LoginRequiredMixin))

    def test_view_extenda_permission_required_mixin_class(self):
        self.assertTrue(issubclass(ChapterListingAdminView, PermissionRequiredMixin))

    def test_view_extend_AdminListView_class(self):
        self.assertTrue(issubclass(ChapterListingAdminView, AdminListView))

    # Test model attribute
    def test_list_view_has_model_attribute(self):
        self.assertTrue(hasattr(ChapterListingAdminView, 'model'))

    def test_list_view_use_chapter_model(self):
        self.assertEqual(ChapterListingAdminView.model, Chapter)

    # Test filterset_class attribute
    def test_list_view_has_filter_set_class(self):
        self.assertTrue(hasattr(ChapterListingAdminView, 'filterset_class'))

    def test_list_view_filter_class(self):
        self.assertEqual(ChapterListingAdminView.filterset_class, ChapterFilter)

    # Test title attribute
    def test_list_view_has_title(self):
        self.assertTrue(hasattr(ChapterListingAdminView, 'title'))

    def test_list_view_title_equals_all_chapers(self):
        self.assertEqual(ChapterListingAdminView.title, _('All Chapters'))

    # Test permission_required attribute
    def test_list_view_has_permission_required(self):
        self.assertTrue(hasattr(ChapterListingAdminView, 'permission_required'))

    def test_list_view_permission_required_equals_all_chapers(self):
        self.assertEqual(ChapterListingAdminView.permission_required, ("chapters.view_chapter",))

    # Test list_display attribute
    def test_it_has_list_display(self):
        self.assertTrue(hasattr(ChapterListingAdminView, 'list_display'))

    def test_list_display_value_is_correct(self):
        self.assertEqual(ChapterListingAdminView.list_display, (
            ('id', _('ID')),
            ('name', _('Name')),
            ('chapter_number', _('Chapter Number')),
            ('origin', _('Origin')),
            ('actions', _('Actions'))
        ))

    # Test get_breadcrumb function
    def test_chapter_has_get_breadcrumb(self):
        self.assertTrue(hasattr(ChapterListingAdminView, 'get_breadcrumb'))

    def test_get_breadcrumb_is_callable(self):
        self.assertTrue(callable(getattr(ChapterListingAdminView, 'get_breadcrumb')))

    def test_get_breadcrumb_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(ChapterListingAdminView.get_breadcrumb)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test load_name function
    def test_chapter_has_load_name(self):
        self.assertTrue(hasattr(ChapterListingAdminView, 'load_name'))

    def test_load_name_is_callable(self):
        self.assertTrue(callable(getattr(ChapterListingAdminView, 'load_name')))

    def test_load_name_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(ChapterListingAdminView.load_name)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test load_origin function
    def test_it_has_load_origin(self):
        self.assertTrue(hasattr(ChapterListingAdminView, 'load_origin'))

    def test_load_origin_is_callable(self):
        self.assertTrue(callable(getattr(ChapterListingAdminView, 'load_origin')))

    def test_load_origin_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(ChapterListingAdminView.load_origin)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test load_actions function
    def test_it_has_load_actions(self):
        self.assertTrue(hasattr(ChapterListingAdminView, 'load_actions'))

    def test_load_actions_is_callable(self):
        self.assertTrue(callable(getattr(ChapterListingAdminView, 'load_actions')))

    def test_load_actions_signature(self):
        expected_signature = ['self', 'obj']
        actual_signature = inspect.getfullargspec(ChapterListingAdminView.load_actions)[0]
        self.assertEquals(actual_signature, expected_signature)

    # Test get_actions function
    def test_chapter_has_get_actions(self):
        self.assertTrue(hasattr(ChapterListingAdminView, 'get_actions'))

    def test_get_actions_is_callable(self):
        self.assertTrue(callable(getattr(ChapterListingAdminView, 'get_actions')))

    def test_get_actions_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(ChapterListingAdminView.get_actions)[0]
        self.assertEquals(actual_signature, expected_signature)


class ChapterAdminListingViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        self.user = UserFactory()
        self.permission = Permission.objects.get(codename='view_chapter')
        self.user.user_permissions.add(self.permission)

        self.client.login(email=self.user.email, password='secret')
        self.url = reverse('admin:chapters:listing')
        for i in range(10):
            ChapterFactory()

    # Test load_name functio
    def test_load_name_function_return_correct_value(self):
        obj = ChapterFactory(name="Hello", chapter_number=5, origin="in Makkah")
        origin = dict(Chapter.ORIGINS).get(obj.origin)
        self.assertEqual(ChapterListingAdminView().load_name(obj), mark_safe('<td>{}</td>'.format(obj.translated_name)))

    # Test load_origin functio
    def test_load_origin_function_return_correct_value(self):
        obj = ChapterFactory(name="Hello", chapter_number=5, origin="in Makkah")
        origin = dict(Chapter.ORIGINS).get(obj.origin)
        self.assertEqual(ChapterListingAdminView().load_origin(obj), mark_safe('<td>{}</td>'.format(origin)))

    # Test load_actions function
    def test_load_actions_returns_correct_html_template(self):
        obj = ChapterFactory()
        self.assertEqual(ChapterListingAdminView().load_actions(obj), mark_safe(
            '<td class="td--nowrap">' +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-primary"><i class="fa fa-edit"></i></a>'
            .format(obj.get_edit_url, _('Edit')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-info"><i class="fas fa-globe"></i></a>'
            .format(obj.get_translate_url,
                    _('Translate')) +
            '<a href="{}" title="{}" class="mx-1 btn btn-sm btn-danger"><i class="fas fa-trash"></i></a>'
            .format(obj.get_delete_url, _('Delete')) +
            '</td>'
        ))

    # Test get_actions function
    def test_get_actions_returns_correct_html_template_for_creating_new_narration(self):
        self.assertEquals(ChapterListingAdminView().get_actions(),
                          mark_safe(
                              '<a href="{}" class="btn btn-primary btn-sm">'
                              '<i class="fas fa-plus"></i>{}</a>'.format(
                                  reverse("admin:chapters:create"),
                                  _("Add New Chapter")))
                          )

        def test_it_return_the_data(self):
            response = self.client.get(self.url)
            self.assertGreater(len(response.context['object_list']), 0)

        def test_it_has_object_list_context(self):
            response = self.client.get(self.url)
            self.assertIn('object_list', response.context)

        def test_if_narration_create_redirects_to_login_when_no_authentication_done(self):
            self.client.logout()
            response = self.client.get(self.url)
            self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

    class ChapterCreateOrUpdateViewStructureTestCase(TestCase):
        # Test extended classed
        def test_if_narration_create_view_extend_login_required_mixin_class(self):
            self.assertTrue(issubclass(ChapterCreateAndUpdateAdminView, LoginRequiredMixin))

        def test_if_narration_create_view_extend_permission_required_mixin_class(self):
            self.assertTrue(issubclass(ChapterCreateAndUpdateAdminView, PermissionRequiredMixin))

        def test_if_view_extends_view_class(self):
            self.assertTrue(issubclass(ChapterCreateAndUpdateAdminView, View))

        # Test get_permssion_required
        def test_it_has_get_permission_required_attribute(self):
            self.assertTrue(hasattr(ChapterCreateAndUpdateAdminView, 'get_permission_required'))

        def test_view_has_method_get_permission_required_is_callable(self):
            self.assertTrue(callable(ChapterCreateAndUpdateAdminView.get_permission_required))

        def test_get_permission_required_signature(self):
            expected_signature = ['self']
            actual_signature = inspect.getfullargspec(ChapterCreateAndUpdateAdminView.get_permission_required)[0]
            self.assertEquals(actual_signature, expected_signature)

        def test_view_has_method_get(self):
            self.assertTrue(hasattr(ChapterCreateAndUpdateAdminView, 'get'))

        def test_view_has_method_get_is_callable(self):
            self.assertTrue(callable(ChapterCreateAndUpdateAdminView.get))

        def test_get_method_signature(self):
            expected_signature = ['self', 'request']
            actual_signature = inspect.getfullargspec(ChapterCreateAndUpdateAdminView.get)[0]
            self.assertEquals(actual_signature, expected_signature)

        def test_view_has_method_post(self):
            self.assertTrue(hasattr(ChapterCreateAndUpdateAdminView(), 'post'))

        def test_view_has_method_post_is_callable(self):
            self.assertTrue(callable(ChapterCreateAndUpdateAdminView.post))

        def test_post_method_signature(self):
            expected_signature = ['self', 'request']
            actual_signature = inspect.getfullargspec(ChapterCreateAndUpdateAdminView.post)[0]
            self.assertEquals(actual_signature, expected_signature)

    class ChapterCreateOrUpdateViewGetPermissionRequiredTestCase(TestCase):
        def setup_view(self, view, request, *args, **kwargs):
            view.request = request
            view.args = args
            view.kwargs = kwargs
            return view

        def setUp(self):
            self.factory = RequestFactory()

        def test_it_has_returns_add_permission_if_chapter_id_is_not_available(self):
            request = self.factory.get(reverse('admin:chapters:create'))
            view = self.setup_view(ChapterCreateAndUpdateAdminView(), request)
            self.assertEquals(view.get_permission_required(), ("chapters.add_chapter",))

        def test_it_has_returns_change_permission_if_chapter_id_is_available(self):
            chapter = ChapterFactory()
            request = self.factory.get(reverse('admin:chapters:update', kwargs={"chapter_id": chapter.id}))
            view = self.setup_view(ChapterCreateAndUpdateAdminView(), request, chapter_id=chapter.id)
            self.assertEquals(view.get_permission_required(), ("chapters.change_chapter",))

    class ChapterCreateViewGETTestCase(TestCase):
        def setUp(self):
            self.client = Client()
            self.user = UserFactory()
            self.url = reverse('admin:chapters:create')
            self.client.login(email=self.user.email, password='secret')
            self.permission = Permission.objects.filter(codename='add_chapter').last()
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
            self.assertTemplateUsed(response, "chapter/form.html")

        def test_form_is_included_in_the_context(self):
            response = self.client.get(self.url)
            self.assertIn("form", response.context)

        def test_title_is_included_in_the_context(self):
            response = self.client.get(self.url)
            self.assertIn("title", response.context)

        def test_context_form_is_instance_of_ChapterForm(self):
            response = self.client.get(self.url)
            self.assertIsInstance(response.context['form'], ChapterForm)

        def test_if_the_form_of_context_is_new_form(self):
            response = self.client.get(self.url)
            self.assertEquals(response.context['form'].instance.pk, None)

    class ChapterCreateViewPOSTTestCase(TestCase):
        def setUp(self):
            self.client = Client()
            self.user = UserFactory()
            self.user.user_permissions.add(
                Permission.objects.get(codename='view_chapter'),
                Permission.objects.get(codename='add_chapter')
            )
            self.url = reverse('admin:chapters:create')
            self.client.login(email=self.user.email, password='secret')

        def test_it_return_HttpResponseForbidden_if_user_has_no_permission(self):
            self.user.user_permissions.clear()
            response = self.client.post(self.url)
            self.assertIsInstance(response, HttpResponseForbidden)

        def test_if_narration_create_redirects_to_login_when_no_authentication(self):
            self.client.logout()
            response = self.client.post(self.url)
            self.assertRedirects(response, reverse('auth:login') + '?next=' + self.url)

        def test_the_returned_template_used_on_errors(self):
            response = self.client.post(self.url, data={})
            self.assertTemplateUsed(response, "chapter/form.html")

        def test_title_is_included_in_the_context_on_errors(self):
            response = self.client.post(self.url, data={})
            self.assertIn("title", response.context)

        def test_context_form_is_instance_of_ChapterForm(self):
            response = self.client.post(self.url, data={})
            self.assertIsInstance(response.context['form'], ChapterForm)

        def test_for_has_errors(self):
            response = self.client.post(self.url, data={})
            self.assertIsNotNone(response.context['form'].errors)

        def test_it_create_save_the_data_in_database(self):
            response = self.client.post(self.url, data={'name': 'hafs', 'chapter_number': 5, 'origin': "makkiah"})
            self.assertGreater(len(Chapter.objects.all()), 0)

        def test_it_redirect_to_details_after_saving(self):
            response = self.client.post(self.url, data={'name': 'hafs', 'chapter_number': 5, 'origin': "makkiah"})
            obj = Chapter.objects.last()
            url = reverse('admin:chapters:listing') + "?id={}".format(obj.pk)
            self.assertRedirects(response, url)

    class ChapterUpdateViewGETTestCase(TestCase):
        def setUp(self):
            self.client = Client()
            self.user = UserFactory()
            self.chapter = ChapterFactory(id=1, name="Hello", chapter_number=5, origin="in Makkah")
            self.url = reverse('admin:chapters:update', kwargs={'chapter_id': self.chapter.pk})
            self.client.login(email=self.user.email, password='secret')
            self.permission = Permission.objects.filter(codename='change_chapter').last()
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
            response = self.client.get(reverse('admin:chapters:update', args=[1000]))
            self.assertIsInstance(response, HttpResponseNotFound)

        def test_the_used_template(self):
            response = self.client.get(self.url)
            self.assertTemplateUsed(response, "chapter/form.html")

        def test_form_is_included_in_the_context(self):
            response = self.client.get(self.url)
            self.assertIn("form", response.context)

        def test_title_is_included_in_the_context(self):
            response = self.client.get(self.url)
            self.assertIn("title", response.context)

        def test_context_form_is_instance_of_ChapterForm(self):
            response = self.client.get(self.url)
            self.assertIsInstance(response.context['form'], ChapterForm)

        def test_if_the_form_of_context_is_form_with_instance(self):
            response = self.client.get(self.url)
            self.assertNotEqual(response.context['form'].instance.pk, None)

    class ChapterUpdateViewPOSTTestCase(TestCase):
        def setUp(self):
            self.client = Client()
            self.user = UserFactory()
            self.chapter = ChapterFactory(name="Hello", chapter_number=5, origin="makkiah")
            self.url = reverse('admin:chapters:update', kwargs={'chapter_id': self.chapter.pk})
            self.client.login(email=self.user.email, password='secret')
            self.user.user_permissions.add(
                Permission.objects.filter(codename='view_chapter').last(),
                Permission.objects.filter(codename='change_chapter').last()
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
            response = self.client.post(reverse('admin:chapters:update', args=[1000]))
            self.assertIsInstance(response, HttpResponseNotFound)

        def test_the_returned_template_used_on_errors(self):
            response = self.client.post(self.url, data={})
            self.assertTemplateUsed(response, "chapter/form.html")

        def test_title_is_included_in_the_context_on_errors(self):
            response = self.client.post(self.url, data={})
            self.assertIn("title", response.context)

        def test_context_form_is_instance_of_ChapterForm(self):
            response = self.client.post(self.url, data={})
            self.assertIsInstance(response.context['form'], ChapterForm)

        def test_form_has_errors(self):
            response = self.client.post(self.url, data={})
            self.assertIsNotNone(response.context['form'].errors)

        def test_it_update_the_instance_the_data_in_database(self):
            response = self.client.post(self.url, data={'name': 'hafs', 'chapter_number': 6, 'origin': "makkiah"})
            self.chapter.refresh_from_db()
            self.assertEquals(self.chapter.name['ar'], 'hafs')

        def test_it_redirect_to_filtered_listing_after_saving(self):
            response = self.client.post(self.url, data={'name': 'hafs', 'chapter_number': 6, 'origin': "makkiah"})
            obj = Chapter.objects.last()
            url = reverse('admin:chapters:listing') + "?id={}".format(obj.pk)
            self.assertRedirects(response, url)
