from django.urls import path

from apps.translations.translation_verses.views_admin import TranslationVersesListAdminView

app_name = 'verses'

urlpatterns = [
    path('<int:translation_id>/', TranslationVersesListAdminView.as_view(), name='listing'),
]
