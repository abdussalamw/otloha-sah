from apps.users_profiles.views.views_admin_api_v1.views_admin_api_v1_main import TeacherToggleActionAPIView, \
    UserToggleBlockAPIView, ToggleTeacherNarrationCertificationView, ToggleMarkTeacherRecitationPricingAsCompleteView, \
    TeacherCorrectRecitationToggleActionAPIView, UserStatisticsAPIView
from apps.users_profiles.views.views_admin_api_v1.views_admin_api_v1_teachers import AdminTeachersListAPIView, \
    AdminTeacherDetailAPIView, AdminTeacherStudentsView, AdminTeacherNarrationsView, AdminTeacherAccountingView, \
    AdminTeacherRecitationsView

from apps.users_profiles.views.views_admin_api_v1.views_admin_api_v1_admins import AdminCreateAPIView, \
    AdminsListAPIView, AdminUpdateِAPIView, AdminSuspendActionAPIView
from apps.users_profiles.views.views_admin_api_v1.views_admin_api_v1_main import UserToggleBlockAPIView
from apps.users_profiles.views.views_admin_api_v1.views_admin_api_v1_students import AdminStudentsListAPIView, \
    UserRecitationProgressAPIView, UserTajweedProgressAPIView, AdminListGeneralRecitation, \
    AdminListKhatmaRecitation, AdminListTajweedRecitation

__all__ = (
    "AdminTeachersListAPIView",
    "UserToggleBlockAPIView",
    "TeacherToggleActionAPIView",
    "ToggleTeacherNarrationCertificationView",
    "AdminTeacherDetailAPIView",
    "AdminTeacherStudentsView",
    "AdminTeacherNarrationsView",
    "ToggleMarkTeacherRecitationPricingAsCompleteView",
    "AdminTeacherAccountingView",
    "AdminTeacherRecitationsView",
    "TeacherCorrectRecitationToggleActionAPIView",
    "AdminCreateAPIView",
    "AdminsListAPIView",
    "AdminUpdateِAPIView",
    "AdminSuspendActionAPIView",
    "UserToggleBlockAPIView",
    "AdminStudentsListAPIView",
    "UserRecitationProgressAPIView",
    "UserTajweedProgressAPIView",
    "AdminListGeneralRecitation",
    "AdminListKhatmaRecitation",
    "AdminListTajweedRecitation",
    "UserStatisticsAPIView"
)

