from django.contrib.auth import views
from django.test import TestCase
from django.urls import reverse, resolve

from apps.users.auth.views_api_v1 import UserSignupAPIView, UserLoginAPIView
from apps.users.auth.views_site import AuthenticateView, RegisterView, PhoneVerify


class SiteUrlsTestCase(TestCase):
    def test_login_url_resolves(self):
        url = reverse('auth:login')
        self.assertEqual(resolve(url).func.view_class, AuthenticateView)

    def test_register_url_resolves(self):
        url = reverse('auth:register')
        self.assertEqual(resolve(url).func.view_class, RegisterView)

    def test_logout_url_resolves(self):
        url = reverse('auth:logout')
        self.assertEqual(resolve(url).func.view_class, views.LogoutView)

    def test_phone_verify_url_resolves(self):
        url = reverse("auth:verify-phone")
        self.assertEqual(resolve(url).func.view_class, PhoneVerify)


class APIV1UrlsTestCase(TestCase):
    def test_api_v1_login_url_resolves(self):
        url = reverse('api-v1:users:auth:login')
        self.assertEqual(resolve(url).func.view_class, UserLoginAPIView)

    def test_api_v1_register_url_resolves(self):
        url = reverse('api-v1:users:auth:signup')
        self.assertEqual(resolve(url).func.view_class, UserSignupAPIView)
