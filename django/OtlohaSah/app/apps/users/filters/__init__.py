from .admin import AdminsFilter
from .group import GroupFilter, GroupAdminsFilter
from .student import StudentFilter
from .teacher import TeacherFilter
from .teacher_recitation_pricing import BaseTeacherRecitationPricingFilter

USER_TYPE_FILTERS = {
    "student": StudentFilter,
    "teacher": TeacherFilter,
    "admin": AdminsFilter
}


def get_user_filterset_class(user_type):
    return USER_TYPE_FILTERS.get(user_type)


__all__ = (
    "TeacherFilter",
    "StudentFilter",
    "AdminsFilter",
    'get_user_filterset_class',

    "BaseTeacherRecitationPricingFilter",
    "GroupFilter",
    "GroupAdminsFilter"
)
