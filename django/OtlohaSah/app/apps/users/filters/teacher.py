import django_filters
from django import forms
from django.utils.translation import gettext_lazy as _

from apps.users.models import Teacher, TeacherProfile
from .base import NonStuffFilter


class TeacherFilter(NonStuffFilter):
    force_visibility = NonStuffFilter.force_visibility + (
        'teacherprofile__status', 'teacherprofile__teacher_type',
        'teacherprofile__is_active'
    )

    teacherprofile__teacher_type = django_filters.ChoiceFilter(
        label=_("Teacher Type"),
        choices=TeacherProfile.TEACHER_TYPE
    )

    teacherprofile__status = django_filters.ChoiceFilter(
        label=_("Teacher Profile Status"),
        choices=TeacherProfile.STATUS_CHOICES
    )

    teacherprofile__is_active = django_filters.ChoiceFilter(
        label=_('Is Profile Active'),
        choices=NonStuffFilter.BOOL_CHOICES,
        widget=forms.RadioSelect)

    class Meta:
        model = Teacher
        fields = NonStuffFilter.Meta.fields + (
            'teacherprofile__is_active', 'teacherprofile__status', 'teacherprofile__teacher_type',
        )

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.filters['q'].field.widget.attrs.update({
            "placeholder": _("Search Teachers")
        })
