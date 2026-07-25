from rest_framework import routers

from .view_api import NotificationsViewSet

router = routers.SimpleRouter()
router.register(r'notifications', NotificationsViewSet, basename='notifications')
urlpatterns = router.urls
