import inspect

from django.test import TestCase, override_settings
from django.urls import reverse
from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.main.helpers import create_token, create_authorization_header
from apps.narrations.factories import NarrationFactory
from apps.narrations.filters import NarrationAPIFilter
from apps.narrations.models import Narration
from apps.narrations.serializers import NarrationSerializer
from apps.narrations.views_api_v1 import NarrationsListView, NarrationsDetailView
from apps.users.factories import UserFactory


class NarrationListAPIViewStructureTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(issubclass(NarrationsListView, APIView))

    def test_it_has_permission_classes(self):
        self.assertTrue(hasattr(NarrationsListView, 'permission_classes'))

    def test_permission_classes_is_equal_to_TokenHasReadWriteScope(self):
        self.assertIn(TokenHasReadWriteScope, NarrationsListView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(NarrationsListView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(NarrationsListView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(NarrationsListView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class NarrationListAPIViewTestCase(TestCase):
    @override_settings(SEARCH_SERVICE_PROVIDER="apps.main.services.service_search.providers.SQLSearchProvider")
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse('api-v1:narrations:listing')
        for i in range(10):
            if i % 2:
                NarrationFactory(name='Hafs')
            else:
                NarrationFactory(name='other narrations name')

    def test_it_through_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION='')
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_return_200_status_code_when_name_is_not_available(self):
        response = self.client.get(self.url + '?q=test', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_narrations_filters_by_name_is_does_not_exist_will_return_empty_list(self):
        response = self.client.get(self.url + '?q="dummyName"', HTTP_AUTHORIZATION=self.token)
        self.assertIsNotNone(response.data)

    def test_it_return_the_narration_data(self):
        response = self.client.get(self.url + '?q=Hafs', HTTP_AUTHORIZATION=self.token)
        narrations = NarrationAPIFilter({'q': "Hafs"}, Narration.objects.all())
        serializer = NarrationSerializer(narrations.qs, many=True)
        self.assertEqual(serializer.data, response.data)


class NarrationDetailAPIViewStructureTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(issubclass(NarrationsDetailView, APIView))

    def test_it_has_permission_classes(self):
        self.assertTrue(hasattr(NarrationsDetailView, 'permission_classes'))

    def test_permission_classes_is_equal_to_TokenHasReadWriteScope(self):
        self.assertIn(TokenHasReadWriteScope, NarrationsDetailView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(NarrationsDetailView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(NarrationsDetailView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'narration_pk']
        actual_signature = inspect.getfullargspec(NarrationsDetailView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class NarrationDetailAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        self.narration = NarrationFactory(name='hafs')
        self.url = reverse('api-v1:narrations:details', args=[self.narration.pk])

    def test_exception_is_thrown_if_user_is_not_authenticated(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION='')
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_200_status_code_is_returned(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_404_is_returned_if_the_narration_not_exists(self):
        response = self.client.get('api-v1:narrations:details', args=[15], HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_it_return_the_correct_data_of_the_object(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.data['id'], self.narration.id)
