import inspect

from django.test import TestCase
from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status
from rest_framework.reverse import reverse
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.explanations.explanation_verse.views_api_v1 import ExplanationVerseListingView, ExplanationVerseDetailsView
from apps.explanations.factories import ExplanationVerseFactory, ExplanationFactory
from apps.explanations.models import ExplanationVerse
from apps.explanations.serializers import ExplanationVerseSerializer
from apps.main.helpers import create_token, create_authorization_header
from apps.quran.factories import UserFactory


class ExplanationVersesListingAPIViewStructureTestCase(TestCase):
    def test_view_extend_api_view_class(self):
        self.assertTrue(issubclass(ExplanationVerseListingView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(ExplanationVerseListingView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(ExplanationVerseListingView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, ExplanationVerseListingView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(ExplanationVerseListingView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(ExplanationVerseListingView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(ExplanationVerseListingView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class ExplanationVersesListingAPIViewGETTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        for _ in range(5):
            ExplanationVerseFactory(explanation=ExplanationFactory())
        ExplanationVerseFactory(explanation=ExplanationFactory())
        self.explanation_verses = ExplanationVerse.objects.all()
        self.url = reverse("api-v1:explanations:verses:listing")

    def test_it_raises_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_returns_all_available_explanation_verses(self):
        explanation_verses = ExplanationVerseSerializer(ExplanationVerse.objects.all(), many=True).data
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(explanation_verses, response.data)


class ExplanationVersesDetailsAPIViewStructureTestCase(TestCase):
    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(ExplanationVerseDetailsView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(ExplanationVerseDetailsView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(ExplanationVerseDetailsView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, ExplanationVerseDetailsView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(ExplanationVerseDetailsView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(ExplanationVerseDetailsView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'explanation_verse_id']
        actual_signature = inspect.getfullargspec(ExplanationVerseDetailsView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class ExplanationVersesDetailsGETAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.explanation_verse = ExplanationVerseFactory(explanation=ExplanationFactory())
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse("api-v1:explanations:verses:details", args=[self.explanation_verse.pk])

    def test_it_return_401_if_user_is_not_authorized(self):
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_return_404_if_the_explanation_verse_not_exists(self):
        response = self.client.get(reverse("api-v1:translations:verses:details", args=[100000]),
                                   HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_returns_correct_data_in_response(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.data, ExplanationVerseSerializer(self.explanation_verse).data)
