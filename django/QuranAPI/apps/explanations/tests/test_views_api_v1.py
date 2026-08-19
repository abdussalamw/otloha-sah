import inspect

from django.test import TestCase, override_settings
from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.reverse import reverse
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.explanations.factories import ExplanationFactory
from apps.explanations.filters import ExplanationAPIFilter
from apps.explanations.models import Explanation
from apps.explanations.serializers import ExplanationSerializer
from apps.explanations.views_api_v1 import ExplanationListingView, ExplanationDetailsView
from apps.main.helpers import create_token, create_authorization_header
from apps.narrations.factories import NarrationFactory
from apps.users.factories import UserFactory


class ExplanationsListingAPIViewStructureTestCase(TestCase):
    def test_view_extend_api_view_class(self):
        self.assertTrue(issubclass(ExplanationListingView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(ExplanationListingView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(ExplanationListingView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(AllowAny, ExplanationListingView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(ExplanationListingView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(ExplanationListingView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(ExplanationListingView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class ExplanationsListingAPIViewGETTestCase(TestCase):
    @override_settings(SEARCH_SERVICE_PROVIDER="apps.main.services.service_search.providers.SQLSearchProvider")
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        for _ in range(5):
            ExplanationFactory(name="new explanations name", narration=NarrationFactory())
        ExplanationFactory(narration=NarrationFactory())
        self.url = reverse("api-v1:explanations:listing")

    def test_it_raises_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_all_available_explanations(self):
        explanations = ExplanationSerializer(Explanation.objects.all(), many=True).data
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(explanations, response.data)

    def test_it_returns_filtered_result_based_on_request_querystring_with_q(self):
        explanations = ExplanationAPIFilter(queryset=Explanation.objects.all(), data={
            'q': 'new',
        })
        serializer = ExplanationSerializer(explanations.qs, many=True)
        response = self.client.get(self.url + '?q=new', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.data, serializer.data)

    def test_it_returns_empty_list_if_there_is_no_search_with_this_q(self):
        explanations = ExplanationAPIFilter(queryset=Explanation.objects.all(), data={
            "q": 'mmm'
        })
        serializer = ExplanationSerializer(explanations.qs, many=True)
        response = self.client.get(self.url + '?q=mmm', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(list(response.data), [])
        self.assertEqual(list(response.data), list(serializer.data))

    def test_it_returns_filtered_result_based_on_request_querystring_with_narration(self):
        explanations = ExplanationAPIFilter(queryset=Explanation.objects.all(), data={
            "narrations": 6,
        })
        serializer = ExplanationSerializer(explanations.qs, many=True)
        response = self.client.get(self.url + '?narrations=6', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.data, serializer.data)

    def test_it_returns_empty_list_if_there_is_no_search_with_this_narration(self):
        NarrationFactory()
        explanations = ExplanationAPIFilter(queryset=Explanation.objects.all(), data={'narration': 7})
        serializer = ExplanationSerializer(explanations.qs, many=True)
        response = self.client.get(self.url + '?narration=7', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(list(response.data), [])
        self.assertEqual(list(response.data), list(serializer.data))


class ExplanationDetailsViewStructureTestCase(TestCase):
    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(ExplanationDetailsView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(ExplanationDetailsView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(ExplanationDetailsView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(AllowAny, ExplanationDetailsView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(ExplanationDetailsView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(ExplanationDetailsView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'explanation_id']
        actual_signature = inspect.getfullargspec(ExplanationDetailsView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class ExplanationsDetailsGETAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.explanation = ExplanationFactory()
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse("api-v1:explanations:details", args=[self.explanation.pk])

    def test_it_return_401_if_user_is_not_authorized(self):
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_return_404_if_the_explanation_not_exists(self):
        response = self.client.get(reverse("api-v1:explanations:details", args=[100000]),
                                   HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_correct_data_in_response(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.data, ExplanationSerializer(self.explanation).data)
