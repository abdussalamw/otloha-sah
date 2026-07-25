import inspect

from django.test import TestCase
from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status
from rest_framework.reverse import reverse
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.main.helpers import create_token, create_authorization_header
from apps.quran.factories import UserFactory
from apps.tajweed.factories import RuleFactory, TajweedBookFactory
from apps.tajweed.filters import RuleFilter
from apps.tajweed.models import Rule
from apps.tajweed.rules.views_api_v1 import RulesListingAPIView, RuleDetailsAPIView
from apps.tajweed.serializers import RuleSerializer


class BooksListingAPIViewStructureTestCase(TestCase):
    def test_view_extend_api_view_class(self):
        self.assertTrue(issubclass(RulesListingAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(RulesListingAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(RulesListingAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, RulesListingAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(RulesListingAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(RulesListingAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(RulesListingAPIView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class BooksListingAPIViewGETTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        for _ in range(5):
            RuleFactory(description='desc', tajweed_book=TajweedBookFactory())
        RuleFactory(description='desc', tajweed_book=TajweedBookFactory(), rule_number=20)
        self.rules = Rule.objects.all()
        self.url = reverse("api-v1:tajweed:rules:listing")

    def test_it_raises_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_returns_all_available_rules(self):
        rules = RuleSerializer(Rule.objects.all(), many=True).data
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(rules, response.data)

    def test_it_returns_filtered_result_based_on_request_querystring(self):
        rules = RuleFilter(queryset=Rule.objects.all(), data={
            "rule_number": 20
        })
        serializer = RuleSerializer(rules.qs, many=True)
        response = self.client.get(self.url + '?rule_number=20', HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.data, serializer.data)

    def test_it_returns_empty_list_if_there_is_no_search_with_this_rule_number(self):
        rules = RuleFilter(queryset=Rule.objects.all(), data={
            "rule_number": 100
        })
        serializer = RuleSerializer(rules.qs, many=True)
        response = self.client.get(self.url + '?rule_number=100', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(list(response.data), [])
        self.assertEqual(list(response.data), list(serializer.data))


class RuleDetailsAPIViewStructureTestCase(TestCase):
    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(RuleDetailsAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(RuleDetailsAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(RuleDetailsAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, RuleDetailsAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(RuleDetailsAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(RuleDetailsAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'rule_id']
        actual_signature = inspect.getfullargspec(RuleDetailsAPIView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class BooksDetailsGETAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.rule = RuleFactory(description='desc', tajweed_book=TajweedBookFactory())
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse("api-v1:tajweed:rules:details", args=[self.rule.pk])

    def test_it_return_401_if_user_is_not_authorized(self):
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_return_404_if_the_rule_not_exists(self):
        response = self.client.get(reverse("api-v1:tajweed:rules:details", args=[100000]),
                                   HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_returns_correct_data_in_response(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.data, RuleSerializer(self.rule).data)
