from django.urls import path, include

from apps.tajweed.books.views_admin import BookListingView, BookCreateAndUpdateView, BookDetailsView

app_name = 'books'

urlpatterns = [
    path('', BookListingView.as_view(), name="listing"),
    path('create/', BookCreateAndUpdateView.as_view(), name='create'),
    path('<int:book_id>/update/', BookCreateAndUpdateView.as_view(), name='update'),
    path('<int:book_id>', BookDetailsView.as_view(), name='details'),
    path('<int:book_id>/verses/', include('apps.tajweed.verses.urls_admin', namespace='verses')),
]
