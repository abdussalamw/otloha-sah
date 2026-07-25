from django.urls import path, include

app_name = 'tajweed'

urlpatterns = [
    path('books/', include('apps.tajweed.books.urls_api_v1', namespace='books')),
]
