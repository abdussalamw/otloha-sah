from django.db import models
from django.utils.translation import gettext as _
from django.contrib.auth import get_user_model
from django.contrib.auth.models import Permission

User = get_user_model()


class PermissionRequest(models.Model):
    class Meta:
        default_permissions = ['view', 'create']
        permissions = (
            ('response_permissionrequest', _('Can response permission request')),
        )

    user = models.ForeignKey(User, on_delete=models.CASCADE)
    permission = models.ForeignKey(Permission, on_delete=models.CASCADE)
    requested_at = models.DateTimeField(auto_now_add=True)
    approved_by = models.ForeignKey(User, null=True, blank=True, on_delete=models.SET_NULL,
                                    related_name='approved_requests')

    approved_at = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f'{self.user} requests {self.permission.codename}'
