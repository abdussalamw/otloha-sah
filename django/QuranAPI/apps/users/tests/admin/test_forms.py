from django.test import TestCase

from app.form_checkers import check_required
from apps.users.forms.admin.group_forms import GroupForm

group_data = {
    'name': 'Admin',
    'permissions': ['admin | log entry | Can change log entry']
}


class GroupFormTest(TestCase):
    DEFAULT_DATA = group_data
    Form = GroupForm

    def test_name_is_required(self):
        check_required(self, 'name')

    def test_permission_is_required(self):
        check_required(self, 'permissions')
