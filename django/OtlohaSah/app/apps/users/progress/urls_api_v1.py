from rest_framework import routers

from apps.users.progress.views_api_v1 import ProgressViewSet

app_name = "progress"

router = routers.SimpleRouter()
router.register(r'progress', ProgressViewSet, basename='progress')

urlpatterns = router.urls
