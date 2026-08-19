from django.test import TestCase

from apps.users.factories import UserFactory
from apps.users.serializers.user_serializers import ProfileSerializerResponse


class UserProfileSerializerResponseTestCase(TestCase):
    def setUp(self):
        self.user = UserFactory()

    def test_it_contains_expected_fields(self):
        data = ProfileSerializerResponse(instance=self.user).data
        self.assertEqual(set(data.keys()),
                          {'id', 'username', 'gender', 'locale', 'first_name', 'last_name', 'email', 'phone',
                           'email_verified_at',
                           '_order', 'last_login', 'user_permissions', 'groups'})
