import inspect

from django.test import TestCase
from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status, filters
from rest_framework.reverse import reverse
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.main.helpers import create_token, create_authorization_header
from apps.quran.factories import UserFactory
from apps.recitations.factories import ReciterFactory, RecitationFactory
from apps.recitations.models import Recitation
from apps.recitations.serializers_v1 import RecitationSerializer
from apps.recitations.views_api_v1 import RecitationDetailsView, RecitationListAPIView


class RecitationListAPIViewStructureTestCase(TestCase):
    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(RecitationListAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(RecitationListAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(RecitationListAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, RecitationListAPIView.permission_classes)

    def test_it_has_serializer_class_attribute(self):
        self.assertTrue(hasattr(RecitationListAPIView, 'serializer_class'))

    def test_serializer_class_is_RecitationSerializer(self):
        self.assertEquals(RecitationListAPIView.serializer_class, RecitationSerializer)

    def test_it_has_filter_backends_attribute(self):
        self.assertTrue(hasattr(RecitationListAPIView, 'filter_backends'))

    def test_filter_backends_is_list(self):
        self.assertIsInstance(RecitationListAPIView.filter_backends, list)

    def test_filter_backends_has_search_serializer(self):
        self.assertIn(filters.SearchFilter, RecitationListAPIView.filter_backends)

    def test_it_has_search_fields_attribute(self):
        self.assertTrue(hasattr(RecitationListAPIView, 'search_fields'))

    def test_search_fields_is_list(self):
        self.assertIsInstance(RecitationListAPIView.search_fields, list)

    def test_search_fields_has_recitation_name(self):
        self.assertIn('reciter__name', RecitationListAPIView.search_fields)

    def test_search_fields_has_narration_name(self):
        self.assertIn('narration__name', RecitationListAPIView.search_fields)

    def test_view_has_method_filter_queryset(self):
        self.assertTrue(hasattr(RecitationListAPIView, 'filter_queryset'))

    def test_view_has_method_filter_queryset_is_callable(self):
        self.assertTrue(callable(RecitationListAPIView.filter_queryset))

    def test_filter_queryset_method_signature(self):
        expected_signature = ['self', 'queryset']
        actual_signature = inspect.getfullargspec(RecitationListAPIView.filter_queryset)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_view_has_method_get_queryset(self):
        self.assertTrue(hasattr(RecitationListAPIView, 'get_queryset'))

    def test_view_has_method_get_queryset_is_callable(self):
        self.assertTrue(callable(RecitationListAPIView.get_queryset))

    def test_get_queryset_method_signature(self):
        expected_signature = ['self']
        actual_signature = inspect.getfullargspec(RecitationListAPIView.get_queryset)[0]
        self.assertEquals(actual_signature, expected_signature)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(RecitationListAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(RecitationListAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(RecitationListAPIView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class RecitationListAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        self.reciter = ReciterFactory(name='test')
        for _ in range(5):
            self.recitation = Recitation.objects.create(reciter=self.reciter)
        self.url = reverse("api-v1:recitation:list-recitations")

    def test_it_through_exception_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_return_200_status_code_when_name_is_available(self):
        url = reverse("api-v1:recitation:list-recitations") + '?search=test'
        response = self.client.get(url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)


class RecitationDetailsAPIViewStructureTestCase(TestCase):
    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(RecitationDetailsView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(RecitationDetailsView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(RecitationDetailsView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, RecitationDetailsView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(RecitationDetailsView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(RecitationDetailsView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'recitation_id']
        actual_signature = inspect.getfullargspec(RecitationDetailsView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class RecitersDetailsGETAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.recitation = RecitationFactory(reciter=ReciterFactory())
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse("api-v1:recitation:details", args=[self.recitation.pk])

    def test_it_return_401_if_user_is_not_authorized(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_return_404_if_the_reciter_not_exists(self):
        response = self.client.get(reverse("api-v1:reciters:details", args=[100000]),
                                   HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_returns_correct_data_in_response(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.data, RecitationSerializer(self.recitation).data)
