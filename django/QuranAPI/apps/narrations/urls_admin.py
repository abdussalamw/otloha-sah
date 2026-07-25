from django.urls import path, include

from apps.narrations.views_admin import NarrationListingView, NarrationCreateAndUpdateAdminView, NarrationDetailsView, \
    NarrationActionView

app_name = 'narrations'

urlpatterns = [
    path('', NarrationListingView.as_view(), name="listing"),
    path('create/', NarrationCreateAndUpdateAdminView.as_view(), name='create'),
    path('<int:narration_id>/', NarrationDetailsView.as_view(), name='details'),
    path('<int:narration_id>/toggle-action/<str:action>/', NarrationActionView.as_view(), name='toggle-action'),
    path('<int:narration_id>/update/', NarrationCreateAndUpdateAdminView.as_view(), name='update'),
    path('<int:narration_id>/verses/', include("apps.narrations.verses.urls_admin", namespace="verses")),

]
