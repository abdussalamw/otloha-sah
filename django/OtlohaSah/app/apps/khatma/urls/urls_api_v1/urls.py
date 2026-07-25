from django.urls import path

from apps.khatma.views.views_api_v1.views import KhatmaCreateView, ListKhatmaAPIView, KhatmaDeleteView, \
    KhatmaUserDeleteView, KhatmaStartView, KhatmaFinishView

app_name = 'khatma'

urlpatterns = [
    path('create/', KhatmaCreateView.as_view(), name='create'),
    path('list/', ListKhatmaAPIView.as_view(), name='list'),
    path('start/<int:khatma>/', KhatmaStartView.as_view(), name='start'),
    path('finish/<int:khatma>/', KhatmaFinishView.as_view(), name='finish'),

    path('<int:pk>/delete/', KhatmaDeleteView.as_view(), name='khatma-delete'),
    path('<int:khatma>/<int:user>/delete/', KhatmaUserDeleteView.as_view(), name='khatma-user-delete'),

]
