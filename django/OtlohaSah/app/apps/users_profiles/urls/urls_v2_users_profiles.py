from django.urls import path

from apps.recitations.api.v2.views import RecitationsUserListAPIView
from apps.users_profiles.views.views_api_v2 import TeachersListAPIView, StudentsAPIView, UnfriendUserView, \
    UserDetailsView

app_name = 'users_profiles'

urlpatterns = [
    path('teachers/', TeachersListAPIView.as_view(), name="listing-teachers"),
    path('students/', StudentsAPIView.as_view(), name="listing-students"),
    path('<int:user>/recitations/', RecitationsUserListAPIView.as_view(), name='recitations-user-list'),
    path('<int:pk>/', UserDetailsView.as_view(), name='user-profile'),
    path('unfriend/<int:friend_id>/', UnfriendUserView.as_view(), name='unfriend-user'),
]
