from django.urls import path, include

from apps.tajweed.books.views_api_v1 import BooksListAPIView, BooksDetailsAPIView

app_name = 'books'

urlpatterns = [
    path('', BooksListAPIView.as_view(), name='listing'),
    path('<int:book_id>/', BooksDetailsAPIView.as_view(), name='details'),
    path('<int:book_id>/characters/', include('apps.tajweed.books.characters.urls_api_v1', namespace='characters')),
]
