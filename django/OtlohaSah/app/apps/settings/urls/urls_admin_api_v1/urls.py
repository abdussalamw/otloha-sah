from django.urls import path

from apps.settings.views.views_admin_api_v1.settings import SettingsListAPIView, SettingsDetailAPIView, CollectMissingSettingsAPIView, \
    SettingResetAPIView

app_name = 'settings'
urlpatterns = [
    path('<str:group>/', SettingsListAPIView.as_view(), name='settings_list'),
    path('<str:group>/<int:id>/', SettingsDetailAPIView.as_view(), name='settings_detail'),
    path('collect-missing-settings/settings/', CollectMissingSettingsAPIView.as_view(), name='collect-missing-settings-api'),
    path('reset/settings/', SettingResetAPIView.as_view(), name='setting-reset'),

]
