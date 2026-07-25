from django.urls import path

from apps.quran.views_api_v1 import BooksListAPIView, BookDetailsAPIView

app_name = 'books'

urlpatterns = [
    path('', BooksListAPIView.as_view(), name="list"),
    path('<int:book_id>/', BookDetailsAPIView.as_view(), name="details"),
]
