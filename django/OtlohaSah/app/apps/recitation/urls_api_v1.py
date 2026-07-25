from rest_framework import routers

from apps.recitation.views_api_v1 import RecitationViewSet

app_name = "recitations"

router = routers.SimpleRouter()
router.register(r'recitations', RecitationViewSet, basename='recitations')

urlpatterns = router.urls
