import inspect

from django.test import TestCase
from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status
from rest_framework.reverse import reverse
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.main.helpers import create_token, create_authorization_header
from apps.translations.factories import TranslationFactory
from apps.translations.filters import TranslationFilter
from apps.translations.models import Translation
from apps.translations.serializers import TranslationSerializer
from apps.translations.views_api_v1 import TranslationsListAPIView, TranslationsDetailsAPIView
from apps.users.factories import UserFactory


class TranslationsListingAPIViewTestCase(TestCase):
    def test_view_extend_api_view_class(self):
        self.assertTrue(issubclass(TranslationsListAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(TranslationsListAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(TranslationsListAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, TranslationsListAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(TranslationsListAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(TranslationsListAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(TranslationsListAPIView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class TranslationsListingAPIViewGETTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        for _ in range(5):
            TranslationFactory()
        TranslationFactory(language='en')
        self.translations = Translation.objects.all()
        self.url = reverse("api-v1:translations:listing")

    def test_it_raises_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_returns_all_available_translations(self):
        translations = TranslationSerializer(Translation.objects.all(), many=True).data
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(translations, response.data)

    def test_it_returns_filtered_result_based_on_request_querystring(self):
        translations = TranslationFilter(queryset=Translation.objects.all(), data={
            "language": 'en'
        })
        serializer = TranslationSerializer(translations.qs, many=True)
        response = self.client.get(self.url + '?language=en', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(len(list(response.data)), 1)
        self.assertEquals(response.data, serializer.data)
    #
    # def test_it_returns_empty_list_if_there_is_no_search_with_this_language(self):
    #     translations = TranslationFilter(queryset=Translation.objects.all(), data={
    #         "language": 'fr'
    #     })
    #     serializer = TranslationSerializer(translations.qs, many=True)
    #     response = self.client.get(self.url + '?language=fr', HTTP_AUTHORIZATION=self.token)
    #     self.assertEqual(list(response.data), [])
    #     self.assertEqual(list(response.data), list(serializer.data))


class TranslationsDetailsAPIViewTestCase(TestCase):
    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(TranslationsDetailsAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(TranslationsDetailsAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(TranslationsDetailsAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, TranslationsDetailsAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(TranslationsDetailsAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(TranslationsDetailsAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'translation_id']
        actual_signature = inspect.getfullargspec(TranslationsDetailsAPIView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class TranslationsDetailsGETAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.translation = TranslationFactory()
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse("api-v1:translations:details", args=[self.translation.pk])

    def test_it_return_401_if_user_is_not_authorized(self):
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_return_404_if_the_translation_not_exists(self):
        response = self.client.get(reverse("api-v1:translations:details", args=[100000]),
                                   HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_returns_correct_data_in_response(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.data, TranslationSerializer(self.translation).data)
