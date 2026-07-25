from django.urls import path

from apps.quran.page.views_admin import PageListAdminView, PageDetailsView

app_name = 'page'

urlpatterns = [

    path('', PageListAdminView.as_view(), name='listing'),
    path('<int:page_id>/', PageDetailsView.as_view(), name='details'),
    # path('update/<int:page_id>/', PageUpdateAdminView.as_view(), name='update'),
    # path('verses/', include('apps.quran.page.verses.urls_admin', namespace='verses')),

]
