from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.tajweed.books.filters import BookAPISearch
from apps.tajweed.models import Book
from apps.tajweed.serializers import BookSerializer


class BooksListAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, *args, **kwargs):
        books = BookAPISearch(request.GET, Book.objects.all())
        serializer = BookSerializer(books.qs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class BooksDetailsAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, book_id):
        book = get_object_or_404(Book, pk=book_id)
        serializer = BookSerializer(book)
        return Response(serializer.data, status=status.HTTP_200_OK)
