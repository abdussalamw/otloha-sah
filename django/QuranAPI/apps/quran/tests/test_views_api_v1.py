import inspect

from django.test import TestCase
from django.urls import reverse
from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.test import APIClient
from rest_framework.views import APIView

from apps.main.helpers import create_authorization_header, create_token
from apps.narrations.factories import NarrationFactory
from apps.quran.serializers import BookSerializer
from apps.quran.views_api_v1 import BooksListAPIView
from apps.quran.factories import *
from apps.users.factories import UserFactory


class BooksAPIListingStructureView(TestCase):
    def test_view_extend_api_view_class(self):
        self.assertTrue(issubclass(BooksListAPIView, APIView))

    def test_it_has_permission_class_attribute(self):
        self.assertTrue(hasattr(BooksListAPIView, 'permission_classes'))

    def test_permission_classes_is_list(self):
        self.assertIsInstance(BooksListAPIView.permission_classes, list)

    def test_permission_classes_has_token_read_write_scope(self):
        self.assertIn(AllowAny, BooksListAPIView.permission_classes)

    def test_view_has_method_get(self):
        self.assertTrue(hasattr(BooksListAPIView, 'get'))

    def test_view_has_method_get_is_callable(self):
        self.assertTrue(callable(BooksListAPIView.get))

    def test_get_method_signature(self):
        expected_signature = ['self', 'request']
        actual_signature = inspect.getfullargspec(BooksListAPIView.get)[0]
        self.assertEqual(actual_signature, expected_signature)


class APIBookListingViewTestCase(TestCase):

    def setUp(self):
        self.maxDiff = None
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        self.books = []
        for i in range(10):
            if i % 2 == 0:
                self.books.append(BookFactory(name="my name", narration=NarrationFactory()))
            self.books.append(BookFactory(narration=NarrationFactory()))

        self.url = reverse("api-v1:books:list")

    def tearDown(self):
        self.client.logout()

    def test_it_through_exception_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_return_200_status_code_when_title_is_not_available(self):
        url = reverse("api-v1:books:list") + '?name=my name'
        response = self.client.get(url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_specific_title(self):
        book = Book.objects.all()
        url = reverse('api-v1:books:list') + '?name=my name'
        response = self.client.get(url, HTTP_AUTHORIZATION=self.token)
        serializer = BookSerializer(book.filter(name='my name'), many=True)
        self.assertEqual(response.data[0]['name'], serializer.data[0]['name'])


class BookDetailAPIViewTestCase(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = UserFactory()
        self.token = create_authorization_header(create_token(self.user))
        self.narration = NarrationFactory()
        self.book = BookFactory(name="newBook", narration_id=self.narration.pk)
        self.url = reverse('api-v1:books:details', args=[1])

    def tearDown(self):
        self.client.logout()

    def test_it_through_exception_if_user_is_not_authenticated(self):
        self.client.logout()
        response = self.client.get(self.url, HTTP_AUTHORIZATION='')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_returns_200_status_code(self):
        response = self.client.get(self.url, HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

    def test_it_return_404_if_the_book_not_exists(self):
        response = self.client.get(reverse('api-v1:books:details', args=[15]), HTTP_AUTHORIZATION=self.token)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
