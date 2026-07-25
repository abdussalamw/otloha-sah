from django.urls import path

from apps.recitations.recitation_verse.views_admin import RecitationVerseListAdminView

app_name = 'recitation-verses'

urlpatterns = [
    path('', RecitationVerseListAdminView.as_view(), name='list'),
]
