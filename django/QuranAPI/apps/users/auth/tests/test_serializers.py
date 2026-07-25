from django.contrib.auth import get_user_model
from django.test import TestCase

from apps.users.auth.serializers_api_v1 import RegisterSerializer, LoginSerializer
from apps.users.factories import UserFactory


class RegisterSerializerTestCase(TestCase):
    def setUp(self):
        self.UserModel = get_user_model()
        self.user = UserFactory()
        self.serializer = RegisterSerializer(instance=self.user)
        self.data = {
            'username': "test",
            "email": "test@test.com",
            "password": "secret",
            "confirm_password": "secret",
            "phone": "+201005263988",
            'first_name': "test serializer",
            'last_name': "serializer",
        }

    def test_it_contains_all_expected_fields(self):
        """
             result : returning the correct fields for the serializer
        """
        data = self.serializer.data
        self.assertEquals(set(data.keys()),
                          {'username', 'email', 'phone'})

    def test_email_is_required(self):
        """
              set Up :
                - we are removing the email value and check if serializer will be valid
              result : returning serializer not valid
        """
        self.data.pop('email')
        serializer = RegisterSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(serializer.errors.keys(), {'email'})

    def test_it_return_validation_error_when_email_does_not_correct(self):
        """
              set Up :
                - we are updating email value with invalid data and check if serializer will be valid
              result : returning serializer not valid
        """
        self.data['email'] = 'bad email'
        serializer = RegisterSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(serializer.errors.keys(), {'email'})

    def test_username_is_required(self):
        """
              set Up :
                - we are removing the username value and check if serializer will be valid
              result : returning serializer not valid
        """
        self.data.pop('username')
        serializer = RegisterSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(set(serializer.errors.keys()), {'username'})

    def test_it_returns_validation_error_when_password_does_not_provided(self):
        """
              set Up :
                - we are removing the password value and check if serializer will be valid
              result : returning serializer not valid
        """
        self.data.pop('password')
        serializer = RegisterSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(set(serializer.errors.keys()), {'password'})

    def test_it_returns_validation_error_when_phone_does_not_provided(self):
        """
              set Up :
                - we are removing the password value and check if serializer will be valid
              result : returning serializer not valid
        """
        self.data.pop('phone')
        serializer = RegisterSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(set(serializer.errors.keys()), {'phone'})

    def test_it_returns_validation_error_when_first_name_does_not_provided(self):
        """
              set Up :
                - we are removing the first name value and check if serializer will be valid
              result : returning serializer not valid
        """
        self.data.pop('first_name')
        serializer = RegisterSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(set(serializer.errors.keys()), {'first_name'})

    def test_it_returns_validation_error_when_last_name_does_not_provided(self):
        """
              set Up :
                - we are removing the last name value and check if serializer will be valid
              result : returning serializer not valid
        """
        self.data.pop('last_name')
        serializer = RegisterSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(set(serializer.errors.keys()), {'last_name'})

    def test_confirm_password_is_required(self):
        """
              set Up :
                - we are removing the confirm_password value and check if serializer will be valid
              result : returning serializer not valid
        """
        self.data.pop('confirm_password')
        serializer = RegisterSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(set(serializer.errors.keys()), {'confirm_password'})

    def test_it_returns_validation_error_when_confirm_password_does_not_match_password(self):
        """
              set Up :
                - we are updating confirm_password value with no match password data and check if serializer will be valid
              result : returning serializer not valid
        """
        self.data['confirm_password'] = 'no matching'
        serializer = RegisterSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(set(serializer.errors.keys()), {'confirm_password'})

    def test_it_returns_validation_errors_when_password_and_confirm_password_does_not_exist_on_create(self):
        """
              set Up :
                - we are removing the password and confirm_password value and check if serializer will be valid
              result : returning serializer not valid
        """
        self.data.pop('password')
        self.data.pop('confirm_password')
        serializer = RegisterSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(set(serializer.errors.keys()), {'password', 'confirm_password'})

    def test_it_remove_confirm_password_from_validated_data_when_update(self):
        """
              set Up :
                - we are removing the is created context and check if serializer will be valid
              result : returning serializer not valid
        """
        user = UserFactory()
        serializer = RegisterSerializer(data=self.data, instance=user)
        serializer.is_valid()
        instance = serializer.save()
        self.assertEquals(serializer.data['username'], instance.username)

    def test_username_field_equals_user_in_user_object(self):
        data = self.serializer.data
        self.assertEqual(data['username'], self.user.username)

    def test_email_field_equals_email_in_user_object(self):
        data = self.serializer.data
        self.assertEqual(data['email'], self.user.email)

    def test_it_remove_confirm_password_from_validated_data_when_create(self):
        serializer = RegisterSerializer(data=self.data)
        serializer.is_valid()
        instance = serializer.save()
        self.assertIsInstance(instance, self.UserModel)


class LoginSerializerTestCase(TestCase):
    def setUp(self):
        self.UserModel = get_user_model()
        self.user = UserFactory()
        self.serializer = LoginSerializer(instance=self.user)
        self.data = {
            'username': "test@test.com",
            "password": "secret",
            "phone": "+201005263988",
        }

    def test_it_contains_all_expected_fields(self):
        """
             result : returning the correct fields for the serializer
        """
        data = self.serializer.data
        self.assertEquals(set(data.keys()), {'password'})

    def test_it_returns_error_when_no_data(self):
        serializer = LoginSerializer(data={})

        self.assertFalse(serializer.is_valid())
        self.assertEqual(len(serializer.errors), 1)

    def test_username_is_not_required(self):
        """
              set Up :
                - we are removing the username value and check if serializer will be valid
              result : returning serializer not valid
        """
        self.data.pop('username')
        serializer = LoginSerializer(data=self.data)
        self.assertTrue(serializer.is_valid())

    def test_phone_is_not_required(self):
        """
              set Up :
                - we are removing the Phone value and check if serializer will be valid
              result : returning serializer not valid
        """
        self.data.pop('phone')
        serializer = LoginSerializer(data=self.data)
        self.assertTrue(serializer.is_valid())

    def test_password_is_required(self):
        """
              set Up :
                - we are removing the password value and check if serializer will be valid
              result : returning serializer not valid
        """
        self.data.pop('password')
        serializer = LoginSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
        self.assertEquals(serializer.errors.keys(), {'password'})

    def test_if_phone_and_username_is_removed_will_raise_error(self):
        """
              set Up :
                - we are removing the Phone value and check if serializer will be valid
              result : returning serializer not valid
        """

        self.data.pop('username')
        self.data.pop('phone')
        serializer = LoginSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())

    def test_if_phone_and_username_are_together_will_raise_error(self):
        """
              set Up :
                - we are removing the Phone value and check if serializer will be valid
              result : returning serializer not valid
        """
        serializer = LoginSerializer(data=self.data)
        self.assertFalse(serializer.is_valid())
