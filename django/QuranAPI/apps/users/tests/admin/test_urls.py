from django.test import TestCase
from django.urls import resolve

from apps.users.views.admin.group_views import *
from apps.users.views.admin.user_views import *


class AdminUsersTestCase(TestCase):
    def test_user_accounts_listing_url_resolves(self):
        url = reverse('admin:users:accounts-listing')
        self.assertEqual(resolve(url).func.view_class, AdminUserAccountsListingView)

    def test_user_staff_listing_url_resolves(self):
        url = reverse('admin:users:stuff-listing')
        self.assertEqual(resolve(url).func.view_class, AdminUserStuffListingView)

    def test_user_details_url_resolves(self):
        url = reverse('admin:users:details', args=[1])
        self.assertEqual(resolve(url).func.view_class, AdminUserDetailsView)


class AdminGroupsTestCase(TestCase):
    def test_group_listing_url_resolves(self):
        url = reverse('admin:groups:listing')
        self.assertEqual(resolve(url).func.view_class, AdminGroupListingView)

    def test_group_create_url_resolves(self):
        url = reverse('admin:groups:create')
        self.assertEqual(resolve(url).func.view_class, AdminGroupCreateOrUpdate)

    def test_group_details_url_resolves(self):
        url = reverse('admin:groups:details', args=[1])
        self.assertEqual(resolve(url).func.view_class, AdminGroupDetailsView)

    def test_group_edit_url_resolves(self):
        url = reverse('admin:groups:edit', args=[1])
        self.assertEqual(resolve(url).func.view_class, AdminGroupCreateOrUpdate)
