from django.test import TestCase
from django.utils.timezone import now

from apps.users.factories import UserFactory


class UserModelTestCase(TestCase):
    def setUp(self):
        self.user = UserFactory()

    def test_user_model_has_dynamic_property_is_verified(self):
        self.assertTrue(hasattr(self.user, 'is_verified'))

    def test_is_verified_returns_false_if_user_email_or_phone_are_not_verified(self):
        self.user.phone_verified_at = None
        self.user.email_verified_at = None

        self.assertFalse(self.user.is_verified)

    def test_is_verified_returns_true_if_user_email_or_phone_are_both_verified(self):
        self.user.email_verified_at = now()
        self.user.phone_verified_at = now()
        self.user.save()
        self.assertTrue(self.user.is_verified)

