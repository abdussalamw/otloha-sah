import inspect

from django.test import TestCase
from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status
from rest_framework.reverse import reverse
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.main.helpers import create_token, create_authorization_header
from apps.narrations.factories import NarrationFactory
# from apps.quran.factories import UserFactory
from apps.tajweed.books.filters import BookAPISearch
from apps.tajweed.books.views_api_v1 import BooksListAPIView, BooksDetailsAPIView
from apps.tajweed.factories import TajweedBookFactory
from apps.tajweed.models import Book
from apps.tajweed.serializers import BookSerializer
from apps.users.factories import UserFactory


class BooksListingAPIViewTestCase(TestCase):
    def test_view_extend_api_view_class(self):
        self.assertTrue(issubclass(BooksListAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(BooksListAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(BooksListAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, BooksListAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(BooksListAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(BooksListAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(BooksListAPIView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class BooksListingAPIViewGETTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        for _ in range(5):
            TajweedBookFactory(narration=NarrationFactory())
        self.n1 = NarrationFactory()
        TajweedBookFactory(narration=self.n1)
        self.books = Book.objects.all()
        self.url = reverse("api-v1:tajweed:books:listing")

    def test_it_raises_exception_if_user_is_not_authenticated(self):
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_returns_all_available_books(self):
        books = BookSerializer(Book.objects.all(), many=True).data
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(books, response.data)

    def test_it_returns_filtered_result_based_on_request_querystring(self):
        books = BookAPISearch(queryset=Book.objects.all(), data={
            "narration": self.n1
        })
        serializer = BookSerializer(books.qs, many=True)
        response = self.client.get(self.url + '?narration=6', HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.data, serializer.data)

    def test_it_returns_empty_list_if_there_is_no_search_with_this_narration(self):
        NarrationFactory()
        books = BookAPISearch(queryset=Book.objects.all(), data={
            "narration": 7
        })
        serializer = BookSerializer(books.qs, many=True)
        response = self.client.get(self.url + '?narration=7', HTTP_AUTHORIZATION=self.token)
        self.assertEqual(list(response.data), [])
        self.assertEqual(list(response.data), list(serializer.data))

class BooksDetailsAPIViewTestCase(TestCase):
    def test_view_extend_view_class(self):
        self.assertTrue(issubclass(BooksDetailsAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(BooksDetailsAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(BooksDetailsAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(TokenHasReadWriteScope, BooksDetailsAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(BooksDetailsAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(BooksDetailsAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request', 'book_id']
        actual_signature = inspect.getfullargspec(BooksDetailsAPIView.get)[0]
        self.assertEquals(actual_signature, expected_signature)


class BooksDetailsGETAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.book = TajweedBookFactory()
        self.token = create_authorization_header(create_token(self.user))
        self.url = reverse("api-v1:tajweed:books:details", args=[self.book.pk])

    def test_it_return_401_if_user_is_not_authorized(self):
        response = self.client.get(self.url)
        self.assertEquals(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_it_return_404_if_the_book_not_exists(self):
        response = self.client.get(reverse("api-v1:tajweed:books:details", args=[100000]),
                                   HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.status_code, status.HTTP_200_OK)

    def test_it_returns_correct_data_in_response(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEquals(response.data, BookSerializer(self.book).data)
