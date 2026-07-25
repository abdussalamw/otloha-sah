from django.urls import path

from apps.tajweed.rules.views_api_v1 import RulesListingAPIView, RuleDetailsAPIView

app_name = 'rules'

urlpatterns = [
    path('', RulesListingAPIView.as_view(), name="listing"),
    path('<int:rule_id>/', RuleDetailsAPIView.as_view(), name='details')

]
