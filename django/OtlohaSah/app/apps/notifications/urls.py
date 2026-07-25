from django.urls import path

from .views import NotificationsJsonListView, MarkNotificationAsReadView

app_name = 'notifications'

urlpatterns = [
    path('', NotificationsJsonListView.as_view(), name="json-listing"),
    path('mark-as-read/<int:notification_id>/', MarkNotificationAsReadView.as_view(), name="mark-as-read"),
]
