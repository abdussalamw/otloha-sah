from django.urls import path

from apps.users_profiles.views.views_admin_api_v1 import AdminStudentsListAPIView, \
    UserRecitationProgressAPIView, UserTajweedProgressAPIView, AdminListGeneralRecitation, \
    AdminListKhatmaRecitation, AdminListTajweedRecitation

app_name = 'students'
urlpatterns = [
    path('', AdminStudentsListAPIView.as_view(), name="listing"),
    path('<int:pk>/recitations-progress/<str:narration_id>/', UserRecitationProgressAPIView.as_view(),
         name='recitations-progress'),
    path('<int:pk>/tajweed-progress/', UserTajweedProgressAPIView.as_view(), name='user-tajweed-progress'),

    path('<int:pk>/recitations/general/', AdminListGeneralRecitation.as_view(), name='general-recitation-list'),
    path('<int:pk>/recitations/khatma/', AdminListKhatmaRecitation.as_view(), name='khatma-recitation-list'),
    path('<int:pk>/recitations/tajweed/', AdminListTajweedRecitation.as_view(), name='tajweed-recitation-list'),

]
