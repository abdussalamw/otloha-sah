from django.urls import path

from apps.translations.translation_verses.views_api_v1 import TranslationVersesListAPIView, \
    TranslationVersesDetailsAPIView

app_name = 'verses'

urlpatterns = [
    path('', TranslationVersesListAPIView.as_view(), name='listing'),
    path('<int:translation_verse_id>/', TranslationVersesDetailsAPIView.as_view(), name='details'),
]
