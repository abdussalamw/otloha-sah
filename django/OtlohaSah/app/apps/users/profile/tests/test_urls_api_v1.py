from django.test import TestCase
from django.urls import resolve, reverse

from apps.users.profile.views_api_v1 import UpdateProfileDataAPIView, UpdateEmailAPIView, UpdatePhoneAPIView
from apps.users.profile.views_site import UpdateProfileInfoView, ChangeEmailView, PhoneUpdateView


class ProfileSiteViewsTestCase(TestCase):
    def test_user_update_profile_info_site_view_url_resolves(self):
        url = reverse('site:profile:profile-update')
        self.assertEqual(resolve(url).func.view_class, UpdateProfileInfoView)

    def test_update_user_email_site_view_url_resolves(self):
        url = reverse('site:profile:email-update')
        self.assertEqual(resolve(url).func.view_class, ChangeEmailView)

    def test_update_user_phone_site_view_url_resolves(self):
        url = reverse('site:profile:phone-update')
        self.assertEqual(resolve(url).func.view_class, PhoneUpdateView)


class ProfileAPIViewsTestCase(TestCase):
    def test_user_update_profile_info_api_view_url_resolves(self):
        url = reverse('api-v1:profile:profile-info')
        self.assertEqual(resolve(url).func.view_class, UpdateProfileDataAPIView)

    def test_update_user_email_api_view_url_resolves(self):
        url = reverse('api-v1:profile:update-email')
        self.assertEqual(resolve(url).func.view_class, UpdateEmailAPIView)

    def test_update_user_phone_api_view_url_resolves(self):
        url = reverse('api-v1:profile:update-phone')
        self.assertEqual(resolve(url).func.view_class, UpdatePhoneAPIView)
