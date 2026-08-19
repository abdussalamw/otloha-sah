from django.urls import reverse
from django.utils.timezone import now
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.test import APIClient
from rest_framework.test import APITestCase

from apps.users.factories import UserFactory


class UpdateProfileDataApiViewTestCase(APITestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.token.key)
        self.url = reverse('api-v1:profile:profile-info')
        self.data = {
            'first_name': self.user.first_name,
            'last_name': self.user.last_name,
            "gender": "male",
            "birthdate": now(),
        }

    def tearDown(self):
        self.client.logout()

    def test_it_through_exception_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.put(self.url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_returns_201_when_user_created_successfully(self):
        response = self.client.put(self.url, data=self.data)
        self.assertEqual(response.status_code, 201)


class UpdateEmailApiViewTestCase(APITestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory(email='test@test.com')
        self.token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.token.key)
        self.url = reverse('api-v1:profile:update-email')
        self.data = {
            'email': "newtest@test.com",
            "password": "secret",
        }

    def tearDown(self):
        self.client.logout()

    def test_it_through_exception_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.put(self.url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_returns_422_when_data_is_invalid(self):
        response = self.client.put(self.url, data={})
        self.assertEqual(response.status_code, 422)

    def test_it_returns_201_when_user_created_successfully(self):
        response = self.client.put(self.url, data=self.data)
        self.assertEqual(response.status_code, 201)

    def test_it_returns_201_when_user_created_not_successfully(self):
        data = {
            'email': "test@test.com",
            "password": "secret",
        }
        response = self.client.put(self.url, data=data)
        self.assertEqual(response.status_code, 422)


class UpdatePhoneApiViewTestCase(APITestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory(phone='+201005263977')
        self.token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.token.key)
        self.url = reverse('api-v1:profile:update-phone')
        self.data = {
            'phone': "+201005263988",
            "password": "secret",
        }

    def tearDown(self):
        self.client.logout()

    def test_it_through_exception_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.put(self.url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_returns_422_when_data_is_invalid(self):
        response = self.client.put(self.url, data={})
        self.assertEqual(response.status_code, 422)

    def test_it_returns_201_when_user_created_successfully(self):
        response = self.client.put(self.url, data=self.data)
        self.assertEqual(response.status_code, 201)

    def test_it_returns_201_when_user_created_not_successfully(self):
        data = {
            'phone': "+201005263977",
            "password": "secret",
        }
        response = self.client.put(self.url, data=data)
        self.assertEqual(response.status_code, 422)


class UpdatePasswordApiViewTestCase(APITestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory(password='AZ_secret_123')
        self.token = Token.objects.create(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION='Token ' + self.token.key)
        self.url = reverse('api-v1:profile:update-password')
        self.data = {
            'password': "AZ_secret_123",
            "new_password": "AZ_test_456",
        }

    def tearDown(self):
        self.client.logout()

    def test_it_through_exception_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.put(self.url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_returns_422_when_data_is_invalid(self):
        response = self.client.put(self.url, data={})
        self.assertEqual(response.status_code, 422)

    def test_it_returns_201_when_user_created_successfully(self):
        response = self.client.put(self.url, data=self.data)
        self.assertEqual(response.status_code, 201)

    def test_it_returns_201_when_user_created_not_successfully(self):
        data = {
            "password": "secret100",
            "new_password": "AZ_test_456",
        }
        response = self.client.put(self.url, data=data)
        self.assertEqual(response.status_code, 400)
