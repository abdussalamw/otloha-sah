from django.urls import path, include

from ..views import UserStatisticAPIView, RecitationProgressAPIView, \
    GeneralRecitationsAPIView, TeachersRecitationsBoxAPIView, RemarkableRecitationsAPIView, MyRecitationsAPIView, \
    MyEvaluationsAPIView, ReportReasonListAPIView, RecitationCreateAPIView, RecitationDetailAPIView, \
    RecitationUpdateAPIView, RecitationDeleteAPIView, RateTeacherResponseAPIView, RecitationAssignAPIView, \
    UserRecitationReportAPIView, RecitationToggleActionAPIView

app_name = 'recitations'

urlpatterns = [
    path('statistics/<int:narration_id>/', UserStatisticAPIView.as_view(), name='statistics-api'),
    path('progress/<int:narration_id>/<int:chapter_id>/', RecitationProgressAPIView.as_view(), name='chapter-progress'),

    path('box/general/', GeneralRecitationsAPIView.as_view(), name='general-box'),
    path('box/teacher-recitations/', TeachersRecitationsBoxAPIView.as_view(), name='teachers-box-listing'),
    path('box/remarkable/', RemarkableRecitationsAPIView.as_view(), name='remarkable-listing'),

    path('my/recitations/', MyRecitationsAPIView.as_view(), name='my-recitations-listing'),
    path('my/students-recitations/', MyEvaluationsAPIView.as_view(), name='my-evaluations-listing'),

    path('report-reasons/', ReportReasonListAPIView.as_view(), name='report-reasons'),

    path('create/', RecitationCreateAPIView.as_view(), name='create'),
    path('<int:pk>/', RecitationDetailAPIView.as_view(), name='details'),
    path('<int:pk>/update/', RecitationUpdateAPIView.as_view(), name='update'),
    path('<int:pk>/delete/', RecitationDeleteAPIView.as_view(), name='delete'),
    path('<int:pk>/rate-teacher-response/', RateTeacherResponseAPIView.as_view(),
         name='rate_user_for_teacher'),

    path('<int:pk>/pull-recitation/', RecitationAssignAPIView.as_view(), name='pull-recitation'),
    path('<int:pk>/evaluations/',
         include('apps.recitations.api.v2.urls.urls_api_v2_evaluation', namespace='evaluation')),
    path('<int:pk>/report/', UserRecitationReportAPIView.as_view(), name='report-recitation'),
    path('<int:pk>/toggle-action/<str:target>/', RecitationToggleActionAPIView.as_view(), name='target'),

]
