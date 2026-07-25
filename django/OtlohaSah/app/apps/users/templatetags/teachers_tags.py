from django import template
from django.utils.translation import gettext as _

from apps.users.models import TeacherProfile

register = template.Library()


@register.filter
def get_teacher_type(teacher_type):
    return dict(TeacherProfile.TEACHER_TYPE)[teacher_type] if teacher_type else _("Not Available")


@register.filter
def get_teacher_status(status):
    return dict(TeacherProfile.STATUS_CHOICES)[status] if status else _("Not Available")
