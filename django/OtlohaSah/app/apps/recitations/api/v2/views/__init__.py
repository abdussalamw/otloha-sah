__all__ = (
    "RecitationCreateAPIView",
    "RecitationUpdateAPIView",
    "RecitationDeleteAPIView",
    "GeneralRecitationsAPIView",
    "KhatmaRecitationsBoxAPIView",
    "TeachersRecitationsBoxAPIView",
    "MyRecitationsAPIView",
    "MyEvaluationsAPIView",
    "RecitationCreateAPIView",
    "RecitationsUserListAPIView",
    "FinishEvaluationAPIView",
    "UserRecitationReportAPIView",
    "ReportReasonListAPIView",
    "RemarkableRecitationsAPIView",
    "DeleteEvaluationAPIView",
    "EditEvaluationAPIView",
    "RateTeacherResponseAPIView",
    "RecitationAssignAPIView",
    "EvaluationListAPIView",
    "CreateEvaluationAPIView",
    "RecitationToggleActionAPIView",
    "UserStatisticAPIView",
    "RecitationProgressAPIView",
    "RecitationDetailAPIView",

)

from .view_api_v2_create import RecitationCreateAPIView, RecitationUpdateAPIView, \
    RecitationDeleteAPIView, RecitationToggleActionAPIView
from .view_api_v2_progress import UserStatisticAPIView, RecitationProgressAPIView
from .view_api_v2_report import UserRecitationReportAPIView, ReportReasonListAPIView
from .views_api_v2_details import RecitationDetailAPIView

from .views_api_v2_evaluation import FinishEvaluationAPIView, DeleteEvaluationAPIView, EditEvaluationAPIView, \
    RateTeacherResponseAPIView, RecitationAssignAPIView, EvaluationListAPIView, CreateEvaluationAPIView
from .views_api_v2_listing import GeneralRecitationsAPIView, KhatmaRecitationsBoxAPIView, \
    TeachersRecitationsBoxAPIView, MyRecitationsAPIView, MyEvaluationsAPIView, RecitationsUserListAPIView, \
    RemarkableRecitationsAPIView
