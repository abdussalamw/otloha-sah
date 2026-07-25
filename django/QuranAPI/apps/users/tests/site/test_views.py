# from django.contrib.auth import get_user_model
# from django.http import HttpResponseForbidden, HttpResponseNotFound
# from django.test import TestCase, Client
# from django.urls import reverse
# from django.utils.timezone import now
# from apps.users.factories import UserFactory
#
#
# class TestUserDashboardView(TestCase):
#     def setUp(self):
#         self.client = Client()
#         self.user = UserFactory()
#         # login the user
#         self.client.login(email=self.user.email, password='secret')
#         self.url = reverse('site:user-dashboard:dashboard')
#
#     def test_it_redirect_to_login_if_user_is_not_logged_in(self):
#         self.client.logout()
#         response = self.client.get(self.url)
#         self.assertRedirects(response, reverse('account_login') + '?next=' + self.url)
#
#     def test_template_used(self):
#         response = self.client.get(self.url)
#         self.assertTemplateUsed(response, "users/site/dashboard.html")
#
#     def test_course_progress_in_context(self):
#         response = self.client.get(self.url)
#         self.assertIn("courses_progress", response.context)
#
