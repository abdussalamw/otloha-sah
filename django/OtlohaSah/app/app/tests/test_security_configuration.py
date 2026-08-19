from django.test import SimpleTestCase
from rest_framework.permissions import AllowAny

from app.config.rest_framework import REST_FRAMEWORK
from apps.authn.views.views_social import SocialLoginView


class RestSecurityConfigurationTests(SimpleTestCase):
    def test_unsafe_requests_require_authentication_by_default(self):
        self.assertEqual(
            REST_FRAMEWORK['DEFAULT_PERMISSION_CLASSES'],
            ('rest_framework.permissions.IsAuthenticatedOrReadOnly',),
        )

    def test_social_login_is_an_explicit_public_exception(self):
        self.assertEqual(SocialLoginView.permission_classes, [AllowAny])
