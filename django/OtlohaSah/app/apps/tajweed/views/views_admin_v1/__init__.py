from apps.tajweed.views.views_admin_v1.views_admin_calendar_slots_v1 import CalendarSlotListingView, \
    CreateOrUpdateCalendarSlotView, DeleteCalendarSlotView
from apps.tajweed.views.views_admin_v1.views_admin_exam_reservations_v1 import ExamReservationListingView, \
    ApproveExamReservationView, RejectExamReservationView, DeleteExamReservationView
from apps.tajweed.views.views_admin_v1.views_admin_lesson_examples_v1 import DeleteExampleLessonView, \
    CreateOrUpdateExampleLessonView, ExampleListingView
from apps.tajweed.views.views_admin_v1.views_admin_lessons_v1 import LessonDetailView, LessonListingView, \
    CreateOrUpdateLessonView, DeleteLessonView
from apps.tajweed.views.views_admin_v1.views_admin_levels_v1 import LevelListingView, CreateOrUpdateLevelView, \
    DeleteLevelView
from apps.tajweed.views.views_admin_v1.views_admin_user_level_passed_v1 import CreateOrUpdateUserLevelPassedView, \
    DeleteUserLevelPassedView, UserLevelPassedListingView
from apps.tajweed.views.views_admin_v1.views_admin_video_url_v1 import CreateOrUpdateVideoUrlView, DeleteVideoUrlView, \
    VideoListingView

__all__ = (
    'LevelListingView',
    'LessonDetailView',
    'CreateOrUpdateLevelView',
    'DeleteLevelView',
    'LessonListingView',
    'CreateOrUpdateLessonView',
    'CreateOrUpdateExampleLessonView',
    'DeleteExampleLessonView',
    'CreateOrUpdateVideoUrlView',
    'DeleteVideoUrlView',
    'VideoListingView',
    'DeleteLessonView',
    'CalendarSlotListingView',
    'CreateOrUpdateCalendarSlotView',
    'DeleteCalendarSlotView',
    'ExamReservationListingView',
    'ApproveExamReservationView',
    'RejectExamReservationView',
    'DeleteExamReservationView',
    'UserLevelPassedListingView',
    'CreateOrUpdateUserLevelPassedView',
    'DeleteUserLevelPassedView',
    'ExampleListingView',
)
