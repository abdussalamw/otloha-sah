from django.urls import path

from apps.chapters.views_admin import *

app_name = 'chapters'

urlpatterns = [
    path('', ChapterListingAdminView.as_view(), name="listing"),
    path('create/', ChapterCreateAndUpdateAdminView.as_view(), name='create'),
    path('<int:chapter_id>/', ChapterCreateAndUpdateAdminView.as_view(), name='update'),
    # path('<int:chapter_id>/details/', ChapterDetailAdminView.as_view(), name='details'),
]
