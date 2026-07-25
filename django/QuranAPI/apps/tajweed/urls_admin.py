from django.urls import path, include

app_name = 'tajweed'

urlpatterns = [
    path('books/', include('apps.tajweed.books.urls_admin', namespace='books')),
    path('rules/', include('apps.tajweed.rules.urls_admin', namespace='rules'))

]
