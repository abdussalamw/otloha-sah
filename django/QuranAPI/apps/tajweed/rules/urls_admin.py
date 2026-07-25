from django.urls import path

from apps.tajweed.rules.views_admin import RulesListingView, RuleCreateAndUpdateView, RuleDetailsView

app_name = 'rules'

urlpatterns = [
    path('', RulesListingView.as_view(), name="listing"),
    path('create/', RuleCreateAndUpdateView.as_view(), name='create'),
    path('<int:rule_id>/update/', RuleCreateAndUpdateView.as_view(), name='update'),
    path('<int:rule_id>/', RuleDetailsView.as_view(), name='details')

]
