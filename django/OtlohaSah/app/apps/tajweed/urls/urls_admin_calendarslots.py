from django.urls import path

from apps.tajweed.views.views_admin_v1 import CalendarSlotListingView, CreateOrUpdateCalendarSlotView, \
    DeleteCalendarSlotView

app_name = 'calendar-slots'

urlpatterns = [
    path('', CalendarSlotListingView.as_view(), name="listing"),
    path('create/', CreateOrUpdateCalendarSlotView.as_view(), name='create'),
    path('<int:pk>/update/', CreateOrUpdateCalendarSlotView.as_view(), name='update'),
    path('<int:pk>/delete/', DeleteCalendarSlotView.as_view(), name='delete'),
]
