from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APIClient

from apps.users.factories import UserFactory


class UserSignupAPITestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.url = reverse('api-v1:users:auth:signup')
        self.data = {
            'username': "test",
            "email": "test@test.com",
            "password": "secret",
            "confirm_password": "secret",
            "phone": "+201005263988",
            'first_name': self.user.first_name,
            'last_name': self.user.last_name,
        }

    def test_it_returns_422_when_data_is_invalid(self):
        """
            set Up :
              - we are trying post empty registration form data to serializer
            result : returning response 422 the data you posted not valid
        """
        response = self.client.post(self.url, {})
        self.assertEquals(response.status_code, 422)

    def test_it_returns_201_when_user_created_successfully(self):
        """
              set Up :
                - we are trying post registration data to serializer
              result : returning response 201 the data you posted is right and create product
        """

        response = self.client.post(self.url, self.data)
        self.assertEquals(response.status_code, 201)

    def test_it_returns_user_data_after_created(self):
        """
              set Up :
                - we are trying post registration data to serializer
              result : if user in response coming with data
        """
        response = self.client.post(self.url, self.data)
        self.assertIn('user', response.data)


class LoginViewPOSTTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.url = reverse('api-v1:users:auth:login')
        self.data = {
            'username': self.user.email,
            "password": self.user.password,
            "phone": "+201005263988",
        }

    def test_it_returns_200_when_user_login_with_username_and_password_only(self):
        """
              set Up :
                - we are trying post login data (username and password) after removing phone data to serializer
              result : returning response 200 the data you posted is right and create product
        """
        self.data.pop('phone')
        response = self.client.post(self.url, self.data)
        self.assertEqual(response.status_code, 200)

    def test_it_returns_200_when_user_login_with_phone_and_password_only(self):
        """
              set Up :
                - we are trying post login data (phone and password) after removing username to serializer
              result : returning response 200 the data you posted is right and create product
        """
        self.data.pop('username')
        response = self.client.post(self.url, self.data)
        self.assertEqual(response.status_code, 200)

    def test_it_returns_422_when_user_login_with_no_data(self):
        """
              set Up :
                - we are trying post registration data to serializer
              result : returning response 201 the data you posted is right and create product
        """
        response = self.client.post(self.url, {})
        self.assertEqual(response.status_code, 422)

