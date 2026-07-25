from rest_framework import routers

from apps.ads.views.views_api_v1 import AdsViewSet

app_name = 'ads'

router = routers.SimpleRouter()
router.register(r'ads', AdsViewSet, basename='ads')
urlpatterns = router.urls
