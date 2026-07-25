from django.urls import path
from rest_framework.routers import DefaultRouter

from apps.tajweed.views.views_admin_api import TajweedLevelViewSet, TajweedLessonViewSet, CalendarSlotViewSet, \
    ExamReservationListAPIView, ApproveAndRejectExamReservationUpdateAPIView, ExamReservationDeleteAPIView, \
    UserLevelPassedViewSet, TajweedLessonExampleUpdateAPIView, TajweedLessonExampleCreateAPIView, \
    TajweedLessonExampleListAPIView, TajweedLessonExampleDeleteAPIView, TajweedVideoUrlListAPIView, \
    TajweedVideoUrlCreateAPIView, TajweedVideoUrlUpdateAPIView, TajweedVideoUrlDeleteAPIView, VerseListAPIView, \
    VerseDetailAPIView

app_name = 'tajweed'
router = DefaultRouter()
router.register(r'levels', TajweedLevelViewSet, basename='level')
router.register(r'lessons', TajweedLessonViewSet, basename='lesson')
router.register(r'calendar-slots', CalendarSlotViewSet, basename='calendar-slot')
router.register(r'user-level-passed', UserLevelPassedViewSet, basename='user-level-passed')

urlpatterns = router.urls
urlpatterns += [
    path('exam-reservation', ExamReservationListAPIView.as_view(), name="listing"),
    path('exam-reservation/<int:pk>/<str:status>/', ApproveAndRejectExamReservationUpdateAPIView.as_view(), name="update"),
    path('exam-reservation/<int:pk>/delete/', ExamReservationDeleteAPIView.as_view(), name="delete"),

    path('lesson-example/<int:lesson>/', TajweedLessonExampleListAPIView.as_view(), name="listing"),
    path('lesson-example/<int:lesson>/create/', TajweedLessonExampleCreateAPIView.as_view(), name="create"),
    path('lesson-example/<int:lesson>/<int:pk>/', TajweedLessonExampleUpdateAPIView.as_view(), name="update"),
    path('lesson-example/<int:pk>/delete/', TajweedLessonExampleDeleteAPIView.as_view(), name="delete"),

    path('lesson-video/<int:lesson>/', TajweedVideoUrlListAPIView.as_view(), name="listing"),
    path('lesson-video/<int:lesson>/create/', TajweedVideoUrlCreateAPIView.as_view(), name="create"),
    path('lesson-video/<int:lesson>/<int:pk>/', TajweedVideoUrlUpdateAPIView.as_view(), name="update"),
    path('lesson-video/<int:pk>/delete/', TajweedVideoUrlDeleteAPIView.as_view(), name="delete"),
    path('<int:narration_id>/<int:chapter_id>/', VerseListAPIView.as_view(), name='verse-list'),
    path('verse/<int:id>/', VerseDetailAPIView.as_view(), name='verse-detail'),

]
