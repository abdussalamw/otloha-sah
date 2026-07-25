from django.shortcuts import get_object_or_404
from django_filters.rest_framework import DjangoFilterBackend
from oauth2_provider.contrib.rest_framework import TokenHasReadWriteScope
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.quran.filters import BookFilter
from apps.quran.serializers import BookSerializer
from apps.quran.models import Book


class BooksListAPIView(APIView):
    permission_classes = [TokenHasReadWriteScope]

    serializer_class = BookSerializer
    filter_backends = [DjangoFilterBackend]
    filterset_class = BookFilter

    def filter_queryset(self, queryset):
        for backend in list(self.filter_backends):
            queryset = backend().filter_queryset(self.request, queryset, self)
        return queryset

    def get_queryset(self):
        return Book.objects.all()

    def get(self, request, *args, **kwargs):
        the_filtered_qs = self.filter_queryset(self.get_queryset())
        serializer = self.serializer_class(the_filtered_qs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class BookDetailsAPIView(APIView):
    permission_classes = [TokenHasReadWriteScope]

    def get(self, request, book_id):
        book = get_object_or_404(Book, pk=book_id)
        serializer = BookSerializer(instance=book)
        return Response(serializer.data, status=status.HTTP_200_OK)
