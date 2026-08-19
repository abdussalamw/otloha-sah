from django.test import SimpleTestCase
from rest_framework.permissions import AllowAny

from app.config.rest_framework import REST_FRAMEWORK
from apps.chapters.views_api_v1 import ChaptersListAPIView
from apps.main.views_api_v1 import SearchAPIView
from apps.users.auth.views_api_v1 import UserLoginAPIView, UserSignupAPIView


class ApiAccessPolicyTests(SimpleTestCase):
    def test_default_permission_requires_authentication(self):
        self.assertEqual(
            REST_FRAMEWORK['DEFAULT_PERMISSION_CLASSES'],
            ['rest_framework.permissions.IsAuthenticated'],
        )

    def test_quran_content_reads_are_explicitly_public(self):
        self.assertEqual(ChaptersListAPIView.permission_classes, [AllowAny])
        self.assertEqual(SearchAPIView.permission_classes, [AllowAny])

    def test_user_authentication_endpoints_are_explicitly_public(self):
        self.assertEqual(UserSignupAPIView.permission_classes, [AllowAny])
        self.assertEqual(UserLoginAPIView.permission_classes, [AllowAny])
