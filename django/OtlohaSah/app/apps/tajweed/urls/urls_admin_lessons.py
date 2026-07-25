from django.urls import path

from apps.tajweed.views.views_admin_v1 import CreateOrUpdateLessonView, LessonListingView, DeleteLessonView, \
    LessonDetailView, CreateOrUpdateExampleLessonView, CreateOrUpdateVideoUrlView, DeleteExampleLessonView, \
    DeleteVideoUrlView, ExampleListingView
from apps.tajweed.views.views_admin_v1.views_admin_lessons_v1 import SubLessonDetailView
from apps.tajweed.views.views_admin_v1.views_admin_video_url_v1 import VideoListingView

app_name = 'lessons'

urlpatterns = [
    path('', LessonListingView.as_view(), name="listing"),
    path('create/', CreateOrUpdateLessonView.as_view(), name='create'),
    path('<int:pk>/', LessonDetailView.as_view(), name='details'),
    path('<int:pk>/update/', CreateOrUpdateLessonView.as_view(), name='update'),
    path('<int:pk>/delete/', DeleteLessonView.as_view(), name='delete'),
    path('<int:lesson>/sub-lessons/', SubLessonDetailView.as_view(), name='sub-lessons'),
    path('<int:lesson>/<int:pk>/update_example/', CreateOrUpdateExampleLessonView.as_view(), name='update_example'),
    path('<int:pk>/create_example/', CreateOrUpdateExampleLessonView.as_view(), name='create_example'),
    path('<int:pk>/delete_example/', DeleteExampleLessonView.as_view(), name='delete_example'),

    path('<int:lesson>/examples/', ExampleListingView.as_view(), name="listing_example"),

    path('<int:lesson>/<int:pk>/update_video/', CreateOrUpdateVideoUrlView.as_view(), name='update_video'),
    path('<int:pk>/create_video/', CreateOrUpdateVideoUrlView.as_view(), name='create_video'),
    path('<int:pk>/delete_video/', DeleteVideoUrlView.as_view(), name='delete_video'),
    path('<int:lesson>/videos/', VideoListingView.as_view(), name='listing_videos')
]
