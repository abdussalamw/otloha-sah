from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin, PermissionRequiredMixin
from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from django.urls import reverse
from django.utils.translation import gettext as _
from django.views import View
from django.views.generic.detail import SingleObjectTemplateResponseMixin
from django.views.generic.edit import ProcessFormView, ModelFormMixin

from apps.recitation.serializers import BaseRecitationSerializer
from apps.users.models import Teacher
from apps.users.notifications import PaymentCompletedNotification
from apps.users.teachers.forms import TeacherForm


class EditTeacherView(LoginRequiredMixin, PermissionRequiredMixin, SingleObjectTemplateResponseMixin, ModelFormMixin,
                      ProcessFormView):
    permission_required = 'users.change_teacher'
    model = Teacher
    template_name = 'users/teachers/admin/form.html'
    pk_url_kwarg = 'teacher_id'
    form_class = TeacherForm

    def get_context_data(self, **kwargs):
        context = super(EditTeacherView, self).get_context_data(**kwargs)
        context['breadcrumb'] = [
            {"url": "/", "title": _("Home"), },
            {"url": reverse("admin:teachers:listing"), "title": _("All Teachers"), },
            {"url": self.get_success_url(), "title": self.object.get_full_name},
            {"title": _("Edit")}
        ]
        context['title'] = _("Edit Teacher: {teacher_name}").format(teacher_name=self.object.get_full_name)
        return context

    def get_message(self):
        return _('Teacher: "{}" profile updated successfully').format(self.object.get_full_name)

    def form_valid(self, form):
        valid = super(EditTeacherView, self).form_valid(form)
        messages.success(self.request, self.get_message())
        return valid

    def get_success_url(self):
        return self.object.get_details_url

    def get(self, request, *args, **kwargs):
        self.object = self.get_object()
        return super(EditTeacherView, self).get(request, *args, **kwargs)

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        return super(EditTeacherView, self).post(request, *args, **kwargs)




