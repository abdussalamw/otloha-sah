from django.utils.translation import gettext_lazy as _

from apps.users.models import Student
from .base import NonStuffFilter


class StudentFilter(NonStuffFilter):
    class Meta(NonStuffFilter.Meta):
        model = Student

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.filters['q'].field.widget.attrs.update({
            "placeholder": _("Search Students")
        })
