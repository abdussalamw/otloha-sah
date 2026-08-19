from django.contrib.auth.models import Group
from django.test import TestCase, Client
from django.urls import reverse
from django.utils.translation import gettext_lazy as _

from apps.users.factories import UserFactory, GroupFactory
from apps.users.models import User


class UserAccountsListingViewTestCase(TestCase):
    maxDiff = None

    def setUp(self):
        self.client = Client()
        for _ in range(10):
            UserFactory()
        self.response = self.client.get(reverse('admin:users:accounts-listing'))

    def test_it_returns_with_200_status_code(self):
        """ test status is 200 """
        self.assertEqual(self.response.status_code, 200)

    def test_users_queryset_returned(self):
        """ test course queryset is returned in context """
        self.assertIn("object_list", self.response.context)

    def test_user_list_queryset_is_correct(self):
        """ test course_list queryset matches the following queryset """
        self.assertQuerySetEqual(User.objects.all(), self.response.context['object_list'])

    def test_it_returns_columns_in_context(self):
        """ test if columns returned in the context and columns is the same columns in test """
        self.assertIn('columns', self.response.context)
        self.assertEqual((
            ('id', _('id')),
            ('username', _('username')),
            ('email', _('email')),
            ('phone', _('phone')),
            ('actions', _('actions')),
        ), self.response.context['columns'])

    def test_it_returns_actions_in_context(self):
        """ check if context has actions in it """
        self.assertIn('actions', self.response.context)

    def test_that_all_users_are_not_staff(self):
        for i in range(10):
            UserFactory()
        all_staff = all([not user.is_staff for user in User.objects.all()])
        self.assertTrue(all_staff)


class UserStaffListingViewTestCase(TestCase):
    maxDiff = None

    def setUp(self):
        self.client = Client()
        for _ in range(5):
            UserFactory()
        self.response = self.client.get(reverse('admin:users:stuff-listing'))

    def test_it_returns_with_200_status_code(self):
        """ test status is 200 """
        self.assertEqual(self.response.status_code, 200)

    def test_template_used(self):
        """ test template used is admin/courses/course_list.html """
        self.assertTemplateUsed(self.response, 'main/admin/list_view.html')

    def test_it_returns_columns_in_context(self):
        """ test if columns returned in the context and columns is the same columns in test """
        self.assertIn('columns', self.response.context)

    def test_it_returns_actions_in_context(self):
        """ check if context has actions in it """
        self.assertIn('actions', self.response.context)


class GroupListingViewTestCase(TestCase):
    maxDiff = None

    def setUp(self):
        self.client = Client()
        for _ in range(10):
            GroupFactory()
        self.response = self.client.get(reverse('admin:groups:listing'))

    def test_it_returns_with_200_status_code(self):
        """ test status is 200 """
        self.assertEqual(self.response.status_code, 200)

    def test_template_used(self):
        """ test template used is admin/courses/course_list.html """
        self.assertTemplateUsed(self.response, 'main/admin/list_view.html')

    def test_groups_queryset_returned(self):
        """ test course queryset is returned in context """
        self.assertIn('group_list', self.response.context)

    def test_group_list_queryset_is_correct(self):
        """ test course_list queryset matches the following queryset """
        self.assertQuerySetEqual(Group.objects.all()[:10], self.response.context['group_list'], ordered=False)

    def test_it_returns_columns_in_context(self):
        """ test if columns returned in the context and columns is the same columns in test """
        self.assertIn('columns', self.response.context)
        self.assertEqual((
            ('id', _('id')),
            ('name', _('name')),
            ('actions', _('actions')),
        ), self.response.context['columns'])

    def test_it_returns_actions_in_context(self):
        """ check if context has actions in it """
        self.assertIn('actions', self.response.context)


class GroupCreateAndUpdateViewTestCase(TestCase):
    def setUp(self):
        self.client = Client()
        for i in range(40):
            GroupFactory()
        self.response = self.client.get(reverse('admin:groups:create'))

    def test_it_returns_with_200_status_code(self):
        """ test status is 200 """
        self.response = self.client.get(reverse('admin:groups:create'))
        self.assertEqual(self.response.status_code, 200)

    def test_template_used(self):
        """ test template used is admin/courses/form.html """
        self.response = self.client.get(reverse('admin:groups:create'))
        self.assertTemplateUsed(self.response, "admin/groups/form.html")

# class AdminUserCreateViewGET(TestCase):
#     def setUp(self):
#         self.client = Client()
#         self.user = UserFactory()
#         self.client.login(email=self.user.email, password='secret')
#         self.url = reverse('admin:users:create')
#
#     def test_it_redirects_to_login_if_user_is_not_authenticated(self):
#         self.client.logout()
#         response = self.client.get(self.url)
#         self.assertRedirects(response, reverse("account_login") + '?next=' + self.url)
#
#     def test_it_returns_with_200_status_code(self):
#         """ test status is 200 """
#         response = self.client.get(self.url)
#         self.assertEqual(response.status_code, 200)
#
#     def test_template_used(self):
#         """ test template used is admin/collections/form.html """
#         response = self.client.get(self.url)
#         self.assertTemplateUsed(response, "admin/users/form.html")
#
#     def test_context_contains_form(self):
#         response = self.client.get(self.url)
#         self.assertIn("form", response.context)
#
#     def test_context_form_is_instance_of_CollectionForm(self):
#         response = self.client.get(self.url)
#         self.assertIsInstance(response.context['form'], AdminUserCreateForm)
#
#     def test_context_form_is_new_form(self):
#         response = self.client.get(self.url)
#         self.assertEqual(response.context['form'].instance.pk, None)
#
#
# class AdminUserUpdateViewGET(TestCase):
#     def setUp(self):
#         self.client = Client()
#         self.user = UserFactory()
#
#         # login the user
#         self.client.login(email=self.user.email, password='secret')
#         self.url = reverse('admin:users:update', kwargs={'user_id': self.user.pk})
#
#     def test_it_redirects_to_login_if_user_is_not_authenticated(self):
#         self.client.logout()
#         response = self.client.get(self.url)
#         self.assertRedirects(response, reverse('account_login') + '?next=' + self.url)
#
#     def test_it_returns_with_200_status_code(self):
#         """ test status is 200 """
#         response = self.client.get(self.url)
#         self.assertEqual(response.status_code, 200)
#
#     def test_template_used(self):
#         """ test template used is admin/collections/form.html """
#         response = self.client.get(self.url)
#         self.assertTemplateUsed(response, "admin/users/form.html")
#
#     def test_context_contains_form(self):
#         response = self.client.get(self.url)
#         self.assertIn("form", response.context)
#
#     def test_context_form_instance_is_equal_to_user(self):
#         response = self.client.get(self.url)
#         self.assertEqual(response.context['form'].instance, self.user)
#
#
# class AdminUserUpdateViewPOST(TestCase):
#     def setUp(self):
#         self.client = Client()
#         self.user = UserFactory()
#         # login the user
#         self.client.login(email=self.user.email, password='secret')
#         self.url = reverse('admin:users:update', kwargs={'user_id': self.user.pk})
#
#     def test_it_redirects_to_login_if_user_is_not_authenticated(self):
#         self.client.logout()
#         response = self.client.get(self.url)
#         self.assertRedirects(response, reverse('account_login') + '?next=' + self.url)
#
#     def test_it_return_the_correct_template_after_error(self):
#         response = self.client.post(self.url, {})
#         self.assertTemplateUsed(response, "admin/users/form.html")
#
#     def test_return_422_status_code_for_invalid_data(self):
#         response = self.client.post(self.url, {})
#         self.assertEqual(response.status_code, 422)
#
#     def test_it_return_the_correct_context_on_error(self):
#         response = self.client.post(self.url, {})
#         self.assertIn("form", response.context)
#
#     def test_it_return_the_correct_form_instance_after_error(self):
#         response = self.client.post(self.url, {})
#         self.assertIsInstance(response.context['form'], AdminUserEditForm)
#
#     def test_the_return_form_is_equal_to_admin_user_form_instance(self):
#         response = self.client.post(self.url, {})
#         self.assertEqual(response.context['form'].instance, self.user)
#
#     def test_it_saves_request_data_on_success(self):
#         response = self.client.post(self.url, {'username': 'new username'})
#         self.assertIn(User.objects.get(pk=self.user.id), User.objects.all())
#
#     def test_it_deactivate_the_user_and_his_children(self):
#         child = User.objects.create(email='a@a.com', phone='1431')
#         response = self.client.post(self.url, {'is_active': False})
#         self.user.refresh_from_db()
#         child.refresh_from_db()
#         self.assertFalse(self.user.is_active)

