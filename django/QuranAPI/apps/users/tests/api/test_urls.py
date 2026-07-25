from django.test import TestCase
from django.urls import resolve, reverse

from apps.users.views.api.user_views import UserDetails


class UserDetailViewTestCase(TestCase):
    def test_user_profile_api_view_url_resolves(self):
        url = reverse('api-v1:users-api:profile', args=[1])
        self.assertEqual(resolve(url).func.view_class, UserDetails)
