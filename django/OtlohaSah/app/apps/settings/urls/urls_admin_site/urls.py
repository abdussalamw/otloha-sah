from django.urls import path

from apps.settings.views.views_site.views import SettingView, ResetSettingsView, CollectMissingSettingsView

app_name = 'settings'

urlpatterns = [
    path('reset/', ResetSettingsView.as_view(), name="reset"),
    path('collect-missing-settings/', CollectMissingSettingsView.as_view(), name="collect-missing-settings"),
    path('<str:settings_group>/', SettingView.as_view(), name="listing"),
]
