from app.celery import app

from app import settings
from apps.users.models import User


@app.task
def update_user_on_pre_save_task(user_id):
    user = User.objects.get(id=user_id)
    if user.is_a_teacher and hasattr(user, 'teacherprofile') and hasattr(user, '_original_is_blocked'):
        if getattr(user, 'is_blocked') != user._original_is_blocked and user.is_blocked:
            user.teacherprofile.is_active = False
            user.teacherprofile.save()
            from apps.users.notifications import TeacherPrivilegeGrantedOrRevokedNotification
            user.notify(TeacherPrivilegeGrantedOrRevokedNotification, receivers=user)


@app.task
def publish_user_settings_to_created_user_task(user_id):
    from apps.settings.models import UserSetting
    user = User.objects.get(id=user_id)
    for item in settings.USER_SETTINGS_GROUPS:
        UserSetting.objects.reset(group=item[0], user=user)
