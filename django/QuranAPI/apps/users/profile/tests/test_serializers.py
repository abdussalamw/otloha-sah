from django.contrib.auth import get_user_model
from django.test import TestCase
from django.utils.timezone import now

from apps.users.factories import UserFactory
from apps.users.profile.serializers import ChangePasswordSerializer, UpdatePhoneNumberSerializer, \
    UpdateEmailSerializer, UpdateUserDataSerializer


class UpdateUserDataSerializerValidationTestCase(TestCase):
    def setUp(self):
        self.UserModel = get_user_model()
        self.user = UserFactory()
        self.serializer = UpdateUserDataSerializer(instance=self.user)
        self.data = {
            "first_name": "Test",
            "last_name": "User",
            "gender": "male",
            "birthdate": now(),
        }

    def test_it_contains_all_expected_fields(self):
        data = self.serializer.data
        self.assertEquals(set(data.keys()), {'first_name', 'last_name', 'gender', 'birth_date', 'image'})

    def test_it_returns_error_when_no_data(self):
        serializer = UpdateUserDataSerializer(data={})
        self.assertTrue(serializer.is_valid())
        self.assertEqual(len(serializer.errors), 0)

    def test_username_is_not_required(self):
        self.data.pop('first_name')
        serializer = UpdateUserDataSerializer(data=self.data)
        self.assertTrue(serializer.is_valid())

    def test_phone_is_not_required(self):
        self.data.pop('last_name')
        serializer = UpdateUserDataSerializer(data=self.data)
        self.assertTrue(serializer.is_valid())

    def test_it_creates_page(self):
        serializer = UpdateUserDataSerializer(data=self.data)
        self.assertTrue(serializer.is_valid())

    def test_it_updates_page_data(self):
        serializer = UpdateUserDataSerializer(instance=self.user, data=self.data)
        self.assertTrue(serializer.is_valid())
        serializer.save()
        self.assertEquals(UpdateUserDataSerializer(instance=self.user).data, serializer.data)


class UpdateEmailSerializerValidationTestCase(TestCase):
    def setUp(self):
        self.UserModel = get_user_model()
        self.user = UserFactory(email='test@test.com')
        self.serializer = UpdateEmailSerializer(instance=self.user)
        self.data = {
            'email': "newtest@test.com",
            "password": "secret",
        }

    def test_it_contains_all_expected_fields(self):
        data = self.serializer.data
        self.assertEquals(set(data.keys()), {'email', 'password'})

    def test_it_returns_error_when_no_data(self):
        serializer = UpdateEmailSerializer(data={})

        self.assertFalse(serializer.is_valid())
        self.assertEqual(len(serializer.errors), 2)

    def test_username_is_not_required(self):
        self.data.pop('email')
        serializer = UpdateEmailSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())

    def test_password_is_required(self):
        self.data.pop('password')
        serializer = UpdateEmailSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(serializer.errors.keys(), {'password'})

    def test_it_creates_page(self):
        serializer = UpdateEmailSerializer(data=self.data, user=self.user)
        self.assertTrue(serializer.is_valid())

    def test_it_updates_page_data(self):
        serializer = UpdateEmailSerializer(instance=self.user, data=self.data, user=self.user)
        self.assertTrue(serializer.is_valid())
        serializer.save()
        self.assertEquals(UpdateEmailSerializer(instance=self.user, user=self.user).data, serializer.data)

    def test_it_updates_email_with_one_exists_data(self):
        data = {
            'email': "test@test.com",
            "password": "secret",
        }
        serializer = UpdateEmailSerializer(instance=self.user, data=data, user=self.user)
        self.assertFalse(serializer.is_valid())


class UpdatePhoneNumberSerializerValidationTestCase(TestCase):
    def setUp(self):
        self.UserModel = get_user_model()
        self.user = UserFactory(phone='+201005263988')
        self.serializer = UpdatePhoneNumberSerializer(instance=self.user)
        self.data = {
            'phone': "+201005263977",
            "password": "secret",
        }

    def test_it_contains_all_expected_fields(self):
        data = self.serializer.data
        self.assertEquals(set(data.keys()), {'phone', 'password'})

    def test_it_returns_error_when_no_data(self):
        serializer = UpdatePhoneNumberSerializer(data={})

        self.assertFalse(serializer.is_valid())
        self.assertEqual(len(serializer.errors), 2)

    def test_username_is_not_required(self):
        self.data.pop('phone')
        serializer = UpdatePhoneNumberSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(serializer.errors.keys(), {'phone'})

    def test_password_is_required(self):
        self.data.pop('password')
        serializer = UpdatePhoneNumberSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(serializer.errors.keys(), {'password'})

    def test_it_creates_page(self):
        serializer = UpdatePhoneNumberSerializer(data=self.data, user=self.user)
        self.assertTrue(serializer.is_valid())

    def test_it_updates_page_data(self):
        serializer = UpdatePhoneNumberSerializer(instance=self.user, data=self.data, user=self.user)
        self.assertTrue(serializer.is_valid())
        serializer.save()
        self.assertEquals(UpdatePhoneNumberSerializer(instance=self.user, user=self.user).data, serializer.data)

    def test_it_updates_email_with_one_exists_data(self):
        data = {
            'phone': "+201005263988",
            "password": "secret",
        }
        serializer = UpdatePhoneNumberSerializer(instance=self.user, data=data, user=self.user)
        self.assertFalse(serializer.is_valid())


class ChangePasswordSerializerValidationTestCase(TestCase):
    def setUp(self):
        self.UserModel = get_user_model()
        self.user = UserFactory(password='AZ_secret_123')
        self.serializer = ChangePasswordSerializer(instance=self.user)
        self.data = {
            'password': "AZ_secret_123",
            "new_password": "AZ_test_456",
        }

    def test_it_contains_all_expected_fields(self):
        """
             result : returning the correct fields for the serializer
        """
        data = self.serializer.data
        self.assertEquals(set(data.keys()), {'password'})

    def test_it_returns_error_when_no_data(self):
        serializer = ChangePasswordSerializer(data={})

        self.assertFalse(serializer.is_valid())
        self.assertEqual(len(serializer.errors), 2)

    def test_username_is_not_required(self):
        self.data.pop('password')
        serializer = ChangePasswordSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(serializer.errors.keys(), {'password'})

    def test_password_is_required(self):
        self.data.pop('new_password')
        serializer = ChangePasswordSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(serializer.errors.keys(), {'new_password'})

    def test_it_creates_page(self):
        serializer = ChangePasswordSerializer(data=self.data)
        self.assertTrue(serializer.is_valid())

    def test_it_updates_page_data(self):
        serializer = ChangePasswordSerializer(instance=self.user, data=self.data)
        self.assertTrue(serializer.is_valid())
        serializer.save()
        self.assertEquals(ChangePasswordSerializer(instance=self.user).data, serializer.data)
