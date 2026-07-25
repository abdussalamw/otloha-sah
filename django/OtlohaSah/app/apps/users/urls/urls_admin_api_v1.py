from django.urls import path

from apps.users.views.views_admin_api_v1 import UserListingAPIView , \
    ToggleTeacherNarrationCertificationAPIView, UserToggleBlockAPIView, TeacherToggleActionAPIView, \
    MarkTeacherRecitationPricingAsCompleteAPIView, UserDetailsAPIView

app_name = 'all-users'

urlpatterns = [

    path('<str:user_type>/', UserListingAPIView.as_view(), name='all-users-listing'),

    path('bulk-toggle-block/<str:action>/', UserToggleBlockAPIView.as_view(), name='bulk-toggle-block-api'),
    path('bulk-toggle-teacher-action/<str:action>/', TeacherToggleActionAPIView.as_view(),
         name='bulk-toggle-teacher-action-api'),

    path('<str:user_type>/<int:pk>/', UserDetailsAPIView.as_view(), name='details'),

    path('<int:pk>/toggle-block/<str:action>/', UserToggleBlockAPIView.as_view(), name='toggle-block-api'),
    path('<int:pk>/toggle-teacher-action/<str:action>/', TeacherToggleActionAPIView.as_view(),
         name='toggle-teacher-action'),

    path('<str:user_type>/<int:pk>/<str:details_type>/', UserDetailsAPIView.as_view(),
         name='user-details-type'),


    # teacher narrations
    path('<int:pk>/narrations/<int:narration_id>/toggle-narration-certifications/<str:suspend_type>/',
         ToggleTeacherNarrationCertificationAPIView.as_view(), name='toggle-certification-api'),

    # teacher accounting
    path('<int:pk>/accounting/mark_as_complete/', MarkTeacherRecitationPricingAsCompleteAPIView.as_view(),
         name='mark-bulk-pricing-as-complete-api'),
    path('<int:pk>/accounting/<int:pricing_id>/mark_as_complete/',
         MarkTeacherRecitationPricingAsCompleteAPIView.as_view(),
         name='mark-pricing-as-complete-api'),

]
