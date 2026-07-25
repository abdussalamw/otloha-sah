from django.urls import path, include

from apps.translations.views_api_v1 import TranslationsListAPIView, TranslationsDetailsAPIView

app_name = 'translations'

urlpatterns = [
    path('', TranslationsListAPIView.as_view(), name='listing'),
    path('<int:translation_id>/', TranslationsDetailsAPIView.as_view(), name='details'),
    path('<int:translation_id>/verses/', include('apps.translations.translation_verses.urls_api_v1', namespace='verses')),
]
