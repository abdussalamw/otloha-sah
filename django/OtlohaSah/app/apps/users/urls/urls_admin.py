from django.urls import path

from apps.users.views.views_admin import TeacherToggleActionView
from apps.users.views.views_admin import UserListingView, UserDetailsView, ToggleTeacherNarrationCertificationView, \
    MarkTeacherRecitationPricingAsCompleteView, UserToggleBlockView
from apps.users.views.views_admin.actions import ExportCSVView
from apps.users.views.views_admin.main import CreateOrUpdateUserView
from apps.users.views.views_admin.views_statistics  import UserStatisticsView

app_name = 'users'

urlpatterns = [
    path('', UserListingView.as_view(), name='listing'),
    path('create/', CreateOrUpdateUserView.as_view(), name='create'),
    path('statistics/', UserStatisticsView.as_view(), name='statistics'),
    path('bulk-toggle-block/<str:action>/', UserToggleBlockView.as_view(), name='bulk-toggle-block'),
    path('bulk-toggle-teacher-action/<str:action>/', TeacherToggleActionView.as_view(),
         name='bulk-toggle-teacher-action'),
    path('export-as-csv/<str:action>/', ExportCSVView.as_view(), name='export-csv'),

    path('<int:pk>/', UserDetailsView.as_view(), name='details'),
    path('<int:pk>/edit/', CreateOrUpdateUserView.as_view(), name='edit'),

    path('<int:pk>/toggle-block/<str:action>/', UserToggleBlockView.as_view(), name='toggle-block'),
    path('<int:pk>/toggle-teacher-action/<str:action>/', TeacherToggleActionView.as_view(),
         name='toggle-teacher-action'),

    path('<int:pk>/<str:details_type>/', UserDetailsView.as_view(), name='details-inner'),

    # teacher narrations
    path('<int:pk>/narrations/<int:narration_id>/toggle-narration-certifications/',
         ToggleTeacherNarrationCertificationView.as_view(),
         name='toggle-certification'),

    # teacher accounting
    path('<int:pk>/accounting/mark_as_complete/', MarkTeacherRecitationPricingAsCompleteView.as_view(),
         name='mark-bulk-pricing-as-complete'),
    path('<int:pk>/accounting/<int:pricing_id>/mark_as_complete/',
         MarkTeacherRecitationPricingAsCompleteView.as_view(),
         name='mark-pricing-as-complete'),

]

