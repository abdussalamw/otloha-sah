from django.urls import path, include

from apps.translations.views_admin import TranslationDetailAdminView, TranslationListAdminView, \
    TranslationCreateAndUpdateView

app_name = 'translations'

urlpatterns = [
    path('', TranslationListAdminView.as_view(), name='listing'),
    path('create/', TranslationCreateAndUpdateView.as_view(), name='create'),
    path('<int:translation_id>', TranslationDetailAdminView.as_view(), name='detail'),
    path('<int:translation_id>/update/', TranslationCreateAndUpdateView.as_view(), name='update'),
    path('verses/', include('apps.translations.translation_verses.urls_admin', namespace='verses')),
]
