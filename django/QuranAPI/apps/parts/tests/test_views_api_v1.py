import inspect

from django.test import TestCase, override_settings
from django.urls import reverse
from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.main.helpers import create_token, create_authorization_header
from apps.parts.factories import PartFactory
from apps.parts.models import Part
from apps.parts.serializers import PartSerializer
from apps.parts.views_api_v1 import PartsListAPIView, PartDetailAPIView
from apps.users.factories import UserFactory


class PartListAPIViewStructureTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(issubclass(PartsListAPIView, APIView))

    def test_it_has_permission_classes(self):
        self.assertTrue(hasattr(PartsListAPIView, 'permission_classes'))

    def test_permission_classes_is_equal_to_AllowAny(self):
        self.assertIn(AllowAny, PartsListAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(PartsListAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(PartsListAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(PartsListAPIView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class PartListAPIViewTestCase(TestCase):
    @override_settings(SEARCH_SERVICE_PROVIDER="apps.main.services.service_search.providers.SQLSearchProvider")
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse('api-v1:parts:listing')

        # create data
        for i in range(10):
            if i % 2:
                PartFactory(name="x", part_number=5, alias="alias x")
            else:
                PartFactory(name="y", part_number=5, alias="alias y")
        PartFactory(name="testy", part_number=99, alias="alias y")

    def test_it_through_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION='')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_200_status_code_if_user_authenticated(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_return_200_status_code_when_title_is_not_available(self):
        url = reverse("api-v1:parts:listing") + '?q=fake'
        response = self.client.get(url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_specific_name(self):
        part = Part.objects.all()
        url = reverse('api-v1:parts:listing') + '?q=x'
        response = self.client.get(url, HTTP_AUTHORIZATION=self.token)
        serializer = PartSerializer(part.filter(name='x'), many=True)
        self.assertEqual(response.data[0]['name'], serializer.data[0]['name'])

    def test_it_returns_specific_alias(self):
        part = Part.objects.all()
        url = reverse('api-v1:parts:listing') + '?q=x'
        response = self.client.get(url, HTTP_AUTHORIZATION=self.token)
        serializer = PartSerializer(part.filter(alias='alias x'), many=True)
        self.assertEqual(response.data[0]['alias'], serializer.data[0]['alias'])

    def test_it_returns_empty_list_if_filter_value_doesnot_exist(self):
        url = reverse('api-v1:parts:listing') + '?q=notexist'
        response = self.client.get(url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(list(response.data), [])
    
    def test_it_return_the_data(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(len(response.data), 11)


class PartDetailAPIViewStructureTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(issubclass(PartDetailAPIView, APIView))

    def test_it_has_permission_classes(self):
        self.assertTrue(hasattr(PartDetailAPIView, 'permission_classes'))

    def test_permission_classes_is_equal_to_AllowAny(self):
        self.assertIn(AllowAny, PartDetailAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(PartDetailAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(PartDetailAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'part_id']
        actual_signature = inspect.getfullargspec(PartDetailAPIView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class PartDetailAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.part = PartFactory()
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse('api-v1:parts:details', args=[self.part.pk])

    def test_part_detail_through_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION='')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_part_detail_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_part_detail_return_404_if_the_part_not_exists(self):
        response = self.client.get('api-v1:parts:details', args=[15], HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_it_return_the_object(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.data['id'], self.part.id)
