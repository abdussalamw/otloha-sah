from .admin import Admin, AdminManager
from .invitation import Invitation
from .student import Student, StudentManager
from .teacher import Teacher, TeacherProfile, TeacherNarration, TeacherRecitationPricing, TeacherFiles, TeacherManager
from .user import User, UserProgress, UserQuerySet, UserManager
from .. import config

USER_MODELS = {
    config.USER_TYPE_TEACHER: Teacher,
    config.USER_TYPE_STUDENT: Student,
    # config.USER_TYPE_ENTITY: ENTITY,
    config.USER_TYPE_ADMIN: Admin,
}

__all__ = (
    'UserQuerySet',
    'UserManager',
    'User',
    'UserProgress',
    'TeacherManager',
    'Teacher',
    'TeacherProfile',
    'TeacherNarration',
    'TeacherRecitationPricing',
    'TeacherFiles',
    'StudentManager',
    'Student',
    'AdminManager',
    'Admin',
    'Invitation',
    'USER_MODELS'
)
