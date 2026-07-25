import inspect
import json

from django.test import TestCase
from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status
from rest_framework.reverse import reverse
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.main.helpers import create_token, create_authorization_header
from apps.quran.page.filters import PageAPIFilter
from apps.quran.page.serializers import PageSerializer
from apps.quran.page.views_api_v1 import PagesListOrDownloadAPIView, PagesDetailAPIView
from apps.quran.factories import PageFactory, UserFactory
from apps.quran.models import Page


class PagesListOrDownloadAPIViewStructureTestCase(TestCase):
    def test_view_extend_api_view_class(self):
        self.assertTrue(issubclass(PagesListOrDownloadAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(PagesListOrDownloadAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(PagesListOrDownloadAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, PagesListOrDownloadAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(PagesListOrDownloadAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(PagesListOrDownloadAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(PagesListOrDownloadAPIView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class PagesListOrDownloadAPIViewGetTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        for _ in range(5):
            PageFactory(sub_part=1)
        self.pages = Page.objects.all()
        self.url = reverse("api-v1:pages:list")

    def tearDown(self):
        self.client.logout()

    def test_it_throws_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_return_200_status_code_when_title_is_not_available(self):
        url = reverse("api-v1:pages:list") + '?sub_part=1'
        response = self.client.get(url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_all_available_pages(self):
        page = PageSerializer(Page.objects.all(), many=True).data
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(page, response.data)

    def test_it_returns_filtered_result_based_on_request_querystring(self):
        reciters = PageAPIFilter(queryset=Page.objects.all(), data={"q": "te"})
        serializer = PageSerializer(reciters.qs, many=True)
        response = self.client.get(self.url + '?q=te', HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.data, serializer.data)

    def test_it_returns_empty_list_if_there_is_sub_page_with_this_number(self):
        url = self.url + '?sub_part=1222'
        response = self.client.get(url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(list(response.data), [])

    def test_it_returns_download_file_when_download_parameter_is_passed(self):
        response = self.client.get(self.url + "?download=1", HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.get('Content-Disposition'), 'attachment; filename=pages.json')

    def test_downloaded_file_has_correct_data(self):
        response = self.client.get(self.url + "?download=1", HTTP_AUTHORIZATION=self.token)
        self.assertEquals(json.loads(response.content), PageSerializer(self.pages, many=True).data)


class PagesDetailAPIViewStructureTestCase(TestCase):
    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(PagesDetailAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(PagesDetailAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(PagesDetailAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, PagesDetailAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(PagesDetailAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(PagesDetailAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'page_id']
        actual_signature = inspect.getfullargspec(PagesDetailAPIView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class PagesDetailAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.page = PageFactory()
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse("api-v1:pages:details", args=[self.page.pk])

    def test_it_return_401_if_user_is_not_authorized(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_return_404_if_the_page_not_exists(self):
        response = self.client.get(reverse("api-v1:pages:details", args=[100000]), HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_returns_correct_data_in_response(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.data, PageSerializer(self.page).data)
