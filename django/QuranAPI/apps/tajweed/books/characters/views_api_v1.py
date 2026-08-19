from rest_framework.permissions import AllowAny
from rest_framework import status
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.tajweed.books.characters.filters import CharacterAPIFilterAndSearch
from apps.tajweed.books.characters.serializers import CharacterSerializer
from apps.tajweed.models import Book, Character


class CharactersListingAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, book_id, *args, **kwargs):
        book = get_object_or_404(Book, pk=book_id)

        if 'verse_id' in kwargs:
            queryset = book.character_set.filter(verse_id=kwargs['verse_id'])
        elif 'word_id' in kwargs:
            queryset = book.character_set.filter(word_id=kwargs['word_id'])
        elif 'chapter_id' in kwargs:
            queryset = book.character_set.filter(chapter_id=kwargs['chapter_id'])
        else:
            queryset = book.character_set.all()
        characters = CharacterAPIFilterAndSearch(request.GET, queryset)
        serializer = CharacterSerializer(characters.qs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class CharactersDetailsAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, book_id, character_id, *args, **kwargs):
        book = get_object_or_404(Book, pk=book_id)
        character = get_object_or_404(Character, pk=character_id)
        return Response(CharacterSerializer(character).data, status=status.HTTP_200_OK)
