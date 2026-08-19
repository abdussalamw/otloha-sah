import inspect

from django.test import TestCase, override_settings
from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.reverse import reverse
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.chapters.factories import ChapterFactory
from apps.chapters.filters import ChapterAPISearch
from apps.chapters.models import Chapter
from apps.chapters.serializers import ChapterSerializer
from apps.chapters.views_api_v1 import ChaptersListAPIView, ChaptersDetailAPIView
from apps.main.helpers import create_token, create_authorization_header
from apps.users.factories import UserFactory


class ChapterListAPIViewStructureTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(issubclass(ChaptersListAPIView, APIView))

    def test_it_has_permission_classes(self):
        self.assertTrue(hasattr(ChaptersListAPIView(), 'permission_classes'))

    def test_permission_classes_is_equal_to_AllowAny(self):
        self.assertIn(AllowAny, ChaptersListAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(ChaptersListAPIView(), 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(ChaptersListAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(ChaptersListAPIView.get)[0]
        self.assertEqual(actual_signature, expected_signature)

class ChapterListAPIViewTestCase(TestCase):
    @override_settings(SEARCH_SERVICE_PROVIDER="apps.main.services.service_search.providers.SQLSearchProvider")
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse('api-v1:chapters:listing')

        for i in range(10):
            if i % 2:
                ChapterFactory(name='ElBakara')
            else:
                ChapterFactory(name='Other name')

    def test_it_through_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION='')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_return_200_status_code_when_name_is_not_available(self):
        response = self.client.get(self.url + '?q=test', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_test_it_return_all_the_data(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(len(response.data), 10)

    def test_it_return_no_data_with_unavailable_filter_value(self):
        response = self.client.get(self.url + '?q="dummyName"', HTTP_AUTHORIZATION=self.token)
        self.assertIsNotNone(response.data)

    def test_it_return_the_correct_chapters_data(self):
        response = self.client.get(self.url + '?q=ElBakara', HTTP_AUTHORIZATION=self.token)
        chapters = ChapterAPISearch({'q': "ElBakara"}, Chapter.objects.all())
        serializer = ChapterSerializer(chapters.qs, many=True)
        self.assertEqual(serializer.data, response.data)


class ChapterDetailAPIViewStructureTestCase(TestCase):
    def test_view_extend_login_required_mixin_class(self):
        self.assertTrue(issubclass(ChaptersDetailAPIView, APIView))

    def test_it_has_permission_classes(self):
        self.assertTrue(hasattr(ChaptersDetailAPIView, 'permission_classes'))

    def test_permission_classes_is_equal_to_AllowAny(self):
        self.assertIn(AllowAny, ChaptersDetailAPIView.permission_classes)
    
    def test_view_has_method_get(self):
        self.assertTrue(hasattr(ChaptersDetailAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(ChaptersDetailAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'chapter_id']
        actual_signature = inspect.getfullargspec(ChaptersDetailAPIView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class ChapterDetailAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.chapter = ChapterFactory(name="Hello", chapter_number=5, origin="in Makkah")
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse('api-v1:chapters:details', args=[self.chapter.pk])

    def test_it_through_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION='')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_200_status_code_is_returned(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_404_is_returned_if_the_chapter_not_exists(self):
        response = self.client.get('api-v1:chapters:details', args=[15])
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_it_return_the_correct_chapter(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.data['id'], self.chapter.id)
