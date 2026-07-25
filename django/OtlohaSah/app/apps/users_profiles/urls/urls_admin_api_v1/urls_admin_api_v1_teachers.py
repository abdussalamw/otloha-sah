from django.urls import path

from apps.users_profiles.views.views_admin_api_v1 import AdminTeachersListAPIView, AdminTeacherDetailAPIView, \
    AdminTeacherStudentsView, AdminTeacherNarrationsView, AdminTeacherAccountingView, \
    AdminTeacherRecitationsView

app_name = 'teachers'
urlpatterns = [
    path('', AdminTeachersListAPIView.as_view(), name="listing"),
    path('<int:pk>/', AdminTeacherDetailAPIView.as_view(), name="listing"),
    path('<int:teacher_id>/students/', AdminTeacherStudentsView.as_view(),
         name='teacher-students'),
    path('<int:teacher_id>/narrations/', AdminTeacherNarrationsView.as_view(), name='teacher-narrations'),
    path('<int:teacher_id>/accounting/', AdminTeacherAccountingView.as_view(), name='teacher-accounting'),
    path('<int:teacher_id>/<str:recitations>/', AdminTeacherRecitationsView.as_view(),
         name='teacher-recitations'),

]
