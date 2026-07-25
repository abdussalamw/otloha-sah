from rest_framework import routers

from apps.settings.views.views_api.views_api import UserSettingsViewSet

app_name = "settings"
router = routers.SimpleRouter()
router.register(r'settings/(?P<settings_group>\w+)', UserSettingsViewSet, basename='settings')

urlpatterns = router.urls

