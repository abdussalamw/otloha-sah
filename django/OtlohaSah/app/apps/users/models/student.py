from django.utils.translation import gettext_lazy as _

from .user import User, UserManager
from .. import config


class StudentManager(UserManager):
    def get_queryset(self, *args, **kwargs):
        return super(StudentManager, self).get_queryset().filter(is_a_teacher=False, is_staff=False)


class Student(User):
    objects = StudentManager()

    class Meta:
        proxy = True
        verbose_name = config.USER_TYPE_STUDENT_VERBOSE_NAME
        verbose_name_plural = config.USER_TYPE_STUDENT_VERBOSE_NAME_PLURAL
        default_permissions = ['change', 'view']
        permissions = (
            ("toggle_block_student", _("Can toggle block student")),
        )
