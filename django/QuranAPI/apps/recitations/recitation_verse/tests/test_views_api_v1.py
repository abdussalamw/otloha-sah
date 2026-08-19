import inspect

from django.test import TestCase
from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.reverse import reverse
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.chapters.factories import ChapterFactory
from apps.main.helpers import create_token, create_authorization_header
from apps.users.factories import UserFactory
from apps.recitations.factories import ReciterFactory, RecitationVerseFactory, RecitationFactory
from apps.recitations.models import RecitationVerse
from apps.recitations.recitation_verse.filters import RecitationVerseFilter
from apps.recitations.recitation_verse.serializers_v1 import RecitationVerseSerializer
from apps.recitations.recitation_verse.views_api_v1 import RecitationVerseListingView, RecitationVerseDetailsView


class RecitationVerseListingAPIViewStructureTestCase(TestCase):
    def test_view_extend_api_view_class(self):
        self.assertTrue(issubclass(RecitationVerseListingView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(RecitationVerseListingView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(RecitationVerseListingView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(AllowAny, RecitationVerseListingView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(RecitationVerseListingView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(RecitationVerseListingView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(RecitationVerseListingView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class RecitationVerseListingAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        for i in range(5):
            RecitationVerseFactory(verse_number=i, recitation=RecitationFactory(reciter=ReciterFactory()),
                                   chapter=ChapterFactory())
        self.recitation_verses = RecitationVerse.objects.all()
        self.url = reverse("api-v1:recitations:recitation-verse:listing")

    def test_it_raises_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_all_available_recitation_verses(self):
        serializer = RecitationVerseSerializer(RecitationVerse.objects.all(), many=True).data
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(serializer, response.data)

    def test_it_returns_filtered_result_based_on_request_querystring(self):
        queryset = RecitationVerseFilter(queryset=self.recitation_verses, data={
            "verse_number": 1
        })
        serializer = RecitationVerseSerializer(queryset.qs, many=True)
        response = self.client.get(self.url + '?verse_number=1', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.data, serializer.data)

    def test_it_returns_empty_list_if_there_is_no_search_with_this_name(self):
        response = self.client.get(self.url + '?verse_number=1000', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.data, [])


class RecitationVerseDetailsAPIViewStructureTestCase(TestCase):
    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(RecitationVerseDetailsView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(RecitationVerseDetailsView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(RecitationVerseDetailsView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(AllowAny, RecitationVerseDetailsView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(RecitationVerseDetailsView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(RecitationVerseDetailsView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'recitation_verse_id']
        actual_signature = inspect.getfullargspec(RecitationVerseDetailsView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class RecitationVerseDetailsAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.recitation_verse = RecitationVerseFactory(
            recitation=RecitationFactory(reciter=ReciterFactory()),
            chapter=ChapterFactory())
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse("api-v1:recitations:recitation-verse:details", args=[self.recitation_verse.pk])

    def test_it_return_401_if_user_is_not_authorized(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_return_404_if_the_reciter_not_exists(self):
        response = self.client.get(reverse("api-v1:recitations:recitation-verse:details", args=[100000]),
                                   HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_correct_data_in_response(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.data, RecitationVerseSerializer(self.recitation_verse).data)
