from django.test import TestCase
from django.urls import reverse, resolve

from apps.users.views.site.user_dashboard import UserDashboardView


# class UrlsTestCase(TestCase):
#     def test_change_language_url_resolves(self):
#         url = reverse('site:users:change-lang', args=['en'])
#         self.assertEqual(resolve(url).func.view_class, ChangeLanguageView)


class UserDashboardUrls(TestCase):
    def test_user_dashboard_resolves(self):
        url = reverse('site:user-dashboard:dashboard')
        self.assertEqual(resolve(url).func.view_class, UserDashboardView)
