from django.urls import path

from apps.users.views.views_api_v1 import TeachersListView, RegisterAsTeacherView, StudentListingView, \
    UserDetailsView, MarkAsFavTeacherAPIView, UserRecitationsAPIView

app_name = 'users'

urlpatterns = [
    path('register-as-a-teacher/', RegisterAsTeacherView.as_view(), name='register_as_teacher'),
    path('<int:user_id>/', UserDetailsView.as_view(), name='details'),
    path('<int:user_id>/recitations/', UserRecitationsAPIView.as_view(), name='recitations'),
    path('teachers/', TeachersListView.as_view(), name='teacher-listing'),
    path('students/', StudentListingView.as_view(), name='student-listing'),
    path('mark-as-fav-teacher/', MarkAsFavTeacherAPIView.as_view(), name='mark-as-fav-teacher')
]
