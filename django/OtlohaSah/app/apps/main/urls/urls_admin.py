from django.urls import path

from apps.main.views.views_admin import Home, StatisticsView

app_name = 'main'

urlpatterns = [
    path('', Home.as_view(), name="home"),
    path('statistics/', StatisticsView.as_view(), name="statistics"),

]
