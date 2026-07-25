from django.urls import path, include

from apps.quran.views_admin import BookCreateAndUpdateView, BookListView, BookDetailsView

app_name = 'books'

urlpatterns = [
    path('', BookListView.as_view(), name="listing"),
    path('create/', BookCreateAndUpdateView.as_view(), name='create'),
    path('<int:book_id>/', BookDetailsView.as_view(), name='details'),
    path('<int:book_id>/update/', BookCreateAndUpdateView.as_view(), name='update'),
    path('<int:book_id>/patterns/', include("apps.quran.patterns.urls", namespace="patterns")),
    path('<int:book_id>/pages/', include("apps.quran.page.admin_urls", namespace="pages")),
    path('<int:book_id>/chapters/', include("apps.quran.chapters.urls_admin", namespace="chapters")),
]
