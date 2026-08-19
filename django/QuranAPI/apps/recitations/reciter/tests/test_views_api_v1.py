import inspect

from django.test import TestCase
from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.reverse import reverse
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.main.helpers import create_token, create_authorization_header
from apps.users.factories import UserFactory
from apps.recitations.factories import ReciterFactory
from apps.recitations.models import Reciter
from apps.recitations.reciter.filters import ReciterAPIFilter
from apps.recitations.reciter.serializers_v1 import RecitersSerializer
from apps.recitations.reciter.views_api_v1 import RecitersListAPIView, RecitersDetailsAPIView


class RecitersListingAPIViewTestCase(TestCase):
    def test_view_extend_api_view_class(self):
        self.assertTrue(issubclass(RecitersListAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(RecitersListAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(RecitersListAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(AllowAny, RecitersListAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(RecitersListAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(RecitersListAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(RecitersListAPIView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class RecitersListingAPIViewGETTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        for _ in range(5):
            ReciterFactory()
        ReciterFactory(name='test')
        self.reciters = Reciter.objects.all()
        self.url = reverse("api-v1:reciters:listing")

    def test_it_raises_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_all_available_reciters(self):
        reciters = RecitersSerializer(Reciter.objects.all(), many=True).data
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(reciters, response.data)

    def test_it_returns_filtered_result_based_on_request_querystring(self):
        reciters = ReciterAPIFilter(queryset=Reciter.objects.all(), data={
            "q": "te"
        })
        serializer = RecitersSerializer(reciters.qs, many=True)
        response = self.client.get(self.url + '?q=te', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.data, serializer.data)

    def test_it_returns_empty_list_if_there_is_no_search_with_this_name(self):
        response = self.client.get(self.url + '?q=test2', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(list(response.data), [])


class RecitersDetailsAPIViewTestCase(TestCase):
    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(RecitersDetailsAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(RecitersDetailsAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(RecitersDetailsAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(AllowAny, RecitersDetailsAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(RecitersDetailsAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(RecitersDetailsAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'reciter_id']
        actual_signature = inspect.getfullargspec(RecitersDetailsAPIView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class RecitersDetailsGETAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.reciter = ReciterFactory()
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse("api-v1:reciters:details", args=[self.reciter.pk])

    def test_it_return_401_if_user_is_not_authorized(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_return_404_if_the_reciter_not_exists(self):
        response = self.client.get(reverse("api-v1:reciters:details", args=[100000]),
                                   HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_correct_data_in_response(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.data, RecitersSerializer(self.reciter).data)
