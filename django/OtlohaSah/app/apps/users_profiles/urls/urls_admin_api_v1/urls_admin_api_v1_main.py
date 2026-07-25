from django.urls import path

from apps.users_profiles.views.views_admin_api_v1.views_admin_api_v1_main import \
    ToggleTeacherNarrationCertificationView, UserToggleBlockAPIView, TeacherToggleActionAPIView, \
    ToggleMarkTeacherRecitationPricingAsCompleteView, TeacherCorrectRecitationToggleActionAPIView

app_name = 'actions'
urlpatterns = [
    path('toggle/<str:action>/', UserToggleBlockAPIView.as_view(), name="toggle-block"),
    path('toggle/<str:action>/', TeacherToggleActionAPIView.as_view(), name="toggle-teacher-action"),
    path('toggle-certification/<int:narration_id>/<str:action>', ToggleTeacherNarrationCertificationView.as_view(),
         name="toggle-teacher-certification"),
    path('toggle-mark-recitation-pricing-as-completed/<int:pricing_id>/',
         ToggleMarkTeacherRecitationPricingAsCompleteView.as_view(),
         name="toggle-mark-recitation-pricing-as-completed"),
    path('toggle-correct-recitation/<str:action>/', TeacherCorrectRecitationToggleActionAPIView.as_view(),
         name="toggle-correct-recitation"),
]
