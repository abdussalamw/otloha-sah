from django.utils.translation import gettext_lazy as _

from apps.users.models import Admin
from .base import BaseUserFilter


class AdminsFilter(BaseUserFilter):
    class Meta(BaseUserFilter.Meta):
        model = Admin

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.filters['q'].field.widget.attrs.update({
            "placeholder": _("Search Admins")
        })
