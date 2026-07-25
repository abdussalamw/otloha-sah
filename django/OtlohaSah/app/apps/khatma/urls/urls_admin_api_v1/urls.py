from django.urls import path

from apps.khatma.views.views_admin_api_vi.views import KhatmaDetailAPIView, UserProgressKhatamatAPIView, \
    UserProgresskhatmaAPIView

app_name = 'khatma'
urlpatterns = [

    path('<int:id>/', KhatmaDetailAPIView.as_view(), name='khatma-detail'),
    path('<int:user_id>/khatma-progress/', UserProgressKhatamatAPIView.as_view(), name='user-khatma-progress'),
    path('<int:khatma_id>/<int:user_id>/', UserProgresskhatmaAPIView.as_view(), name='user-progress-khatma'),

]
