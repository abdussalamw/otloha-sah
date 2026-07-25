from django.urls import path

from social.views_admin import ProvidersListView, CreateOrUpdateProviderView

app_name = "social"

urlpatterns = [
    path('providers/', ProvidersListView.as_view(), name="providers-list"),
    path('providers/create/', CreateOrUpdateProviderView.as_view(), name="providers-create"),
    path('providers/<int:provider_id>/edit', CreateOrUpdateProviderView.as_view(), name="providers-update"),
]
