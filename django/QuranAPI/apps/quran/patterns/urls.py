from django.urls import path

from apps.quran.patterns.views import BookPatternCreateOrUpdateView, BookPatternsListAdminView

app_name = 'patterns'

urlpatterns = [
    path('', BookPatternsListAdminView.as_view(), name='listing'),
    path('create/', BookPatternCreateOrUpdateView.as_view(), name='create'),
    path('<int:pattern_id>/update/', BookPatternCreateOrUpdateView.as_view(), name='update'),
]
