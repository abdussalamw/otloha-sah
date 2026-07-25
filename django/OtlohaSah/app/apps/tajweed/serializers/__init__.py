from apps.tajweed.serializers.exam_reservations_serializers import ExamReservationAdminSerializer, \
    ExamReservationSerializer, ExamReservationUserSerializer
from apps.tajweed.serializers.lessons_serializers import LessonSerializer, VideoUrlSerializer, LessonExampleSerializer, \
    LessonDetailSerializer

from apps.tajweed.serializers.serializers import TajweedLessonExampleSerializer, UserLevelPassedSerializer, \
    TajweedLessonSerializer, CalendarSlotSerializer, TajweedLevelSerializer, TajweedVideoUrlSerializer, \
    LessonProgressSerializer, VerseSerializer

__all__ = (
    'VideoUrlSerializer',
    'LessonExampleSerializer',
    'LessonDetailSerializer',
    'LessonSerializer',
    'serializers',
    'TajweedLevelSerializer',
    'TajweedLessonSerializer',
    'CalendarSlotSerializer',
    'UserLevelPassedSerializer',
    'TajweedLessonExampleSerializer',
    'TajweedVideoUrlSerializer',
    'ExamReservationSerializer',
    'ExamReservationAdminSerializer',
    'ExamReservationUserSerializer',
    'LessonProgressSerializer',
    'VerseSerializer',

)
