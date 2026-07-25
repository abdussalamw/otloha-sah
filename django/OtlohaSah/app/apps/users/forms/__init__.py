__all__ = (
    "UserForm",
    "AdminForm",
    "RegisterForm",
    "TeacherForm",
    "GroupForm",

    "USER_FORMS",
)

from .admin import AdminForm
from .auth import RegisterForm
from .group import GroupForm
from .teacher import TeacherForm
from .user import UserForm

USER_FORMS = {
    "admin": AdminForm,
    "teacher": TeacherForm,
}
