from django.urls import path

from apps.users.teachers.views_admin import  EditTeacherView

app_name = 'teachers'

urlpatterns = [
    path('<int:teacher_id>/edit/', EditTeacherView.as_view(), name='edit'),

]
