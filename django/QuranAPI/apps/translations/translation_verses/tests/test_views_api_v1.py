import inspect

from django.test import TestCase
from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status
from rest_framework.reverse import reverse
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.main.helpers import create_token, create_authorization_header
from apps.quran.factories import UserFactory
from apps.translations.factories import TranslationVerseFactory, TranslationFactory
from apps.translations.filters import TranslationVerseFilter
from apps.translations.models import TranslationVerse
from apps.translations.serializers import TranslationVerseSerializer
from apps.translations.translation_verses.views_api_v1 import TranslationVersesListAPIView, \
    TranslationVersesDetailsAPIView


class TranslationVersesListingAPIViewTestCase(TestCase):
    def test_view_extend_api_view_class(self):
        self.assertTrue(issubclass(TranslationVersesListAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(TranslationVersesListAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(TranslationVersesListAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, TranslationVersesListAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(TranslationVersesListAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(TranslationVersesListAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(TranslationVersesListAPIView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class TranslationVersesListingAPIViewGETTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        for _ in range(5):
            TranslationVerseFactory(translation=TranslationFactory())
        TranslationVerseFactory(translation=TranslationFactory(), verse_number=2)
        self.translation_verses = TranslationVerse.objects.all()
        self.url = reverse("api-v1:translations:verses:listing")

    def test_it_raises_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_returns_all_available_translation_verses(self):
        translation_verses = TranslationVerseSerializer(TranslationVerse.objects.all(), many=True).data
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(translation_verses, response.data)

    def test_it_returns_filtered_result_based_on_request_querystring(self):
        translation_verses = TranslationVerseFilter(queryset=TranslationVerse.objects.all(), data={
            "verse_number": 2
        })
        serializer = TranslationVerseSerializer(translation_verses.qs, many=True)
        response = self.client.get(self.url + '?verse_number=2', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(len(list(response.data)), 1)
        self.assertEquals(response.data, serializer.data)

    def test_it_returns_empty_list_if_there_is_no_search_with_this_verse_number(self):
        translation_verses = TranslationVerseFilter(queryset=TranslationVerse.objects.all(), data={
            "verse_number": 3
        })
        serializer = TranslationVerseSerializer(translation_verses.qs, many=True)
        response = self.client.get(self.url + '?verse_number=3', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(list(response.data), [])
        self.assertEqual(list(response.data), list(serializer.data))


class TranslationVersesDetailsAPIViewTestCase(TestCase):
    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(TranslationVersesDetailsAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(TranslationVersesDetailsAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(TranslationVersesDetailsAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, TranslationVersesDetailsAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(TranslationVersesDetailsAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(TranslationVersesDetailsAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'translation_verse_id']
        actual_signature = inspect.getfullargspec(TranslationVersesDetailsAPIView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class TranslationVersesDetailsGETAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.translation_verse = TranslationVerseFactory(translation=TranslationFactory())
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse("api-v1:translations:verses:details", args=[self.translation_verse.pk])

    def test_it_return_401_if_user_is_not_authorized(self):
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_return_404_if_the_translation_verse_not_exists(self):
        response = self.client.get(reverse("api-v1:translations:verses:details", args=[100000]),
                                   HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_returns_correct_data_in_response(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.data, TranslationVerseSerializer(self.translation_verse).data)
