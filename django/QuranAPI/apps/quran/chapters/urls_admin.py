from django.urls import path

from apps.quran.chapters.views_admin import BookChaptersListAdminView

app_name = 'chapters'

urlpatterns = [
    path('', BookChaptersListAdminView.as_view(), name='listing'),
]
