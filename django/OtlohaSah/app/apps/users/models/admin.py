from apps.users.models.user import User, UserManager
from django.utils.translation import gettext_lazy as _


class AdminManager(UserManager):
    def get_queryset(self):
        return super(AdminManager, self).get_queryset().filter(is_staff=True)


class Admin(User):
    objects = AdminManager()

    class Meta:
        proxy = True
        permissions = (
            ("toggle_block_admin", _("Can toggle block admin")),
        )
