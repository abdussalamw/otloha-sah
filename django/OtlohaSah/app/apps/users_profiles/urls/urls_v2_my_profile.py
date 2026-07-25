from django.urls import path

from apps.users_profiles.views.views_api_v2 import StudentsAPIView, FriendsListAPIView, MyProfileAPIView, \
    RemoveFavoriteTeacherView

app_name = 'my_profile'

urlpatterns = [
    path('', MyProfileAPIView.as_view(), name="my-profile"),
    path('students/', StudentsAPIView.as_view(), name="listing-students"),
    path('friends/', FriendsListAPIView.as_view(), name="listing-friends"),
    path('remove-favorite-teacher/', RemoveFavoriteTeacherView.as_view(), name='remove-favorite-teacher'),
]
