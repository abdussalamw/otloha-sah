import django_filters
from django import forms
from django.utils.translation import gettext_lazy as _
from apps.main.services.service_search.search import SearchProvider

from apps.users.models import Teacher, TeacherProfile
from .base import NonStuffFilter


class TeacherFilter(NonStuffFilter):


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
            'teacherprofile__is_active', 'teacherprofile__status', 'teacherprofile__teacher_type', 'q',
        )
