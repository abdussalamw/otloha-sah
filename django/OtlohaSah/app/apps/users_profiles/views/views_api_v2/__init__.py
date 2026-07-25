__all__ = (
    'StudentsAPIView',
    'FriendsListAPIView',
    'TeachersListAPIView',
    'MyProfileAPIView',
    'UserDetailsView',
    'UnfriendUserView',
    'RemoveFavoriteTeacherView',
)

from apps.users_profiles.views.views_api_v2.views_api_v2 import FriendsListAPIView, StudentsAPIView, \
    TeachersListAPIView, MyProfileAPIView, UserDetailsView, UnfriendUserView, RemoveFavoriteTeacherView
