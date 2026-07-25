from django import forms
from django.contrib.auth import get_user_model
from django.test import TestCase, RequestFactory
from django.utils.timezone import now
from django.utils.translation import gettext_lazy as _

from apps.users.factories import UserFactory
from apps.users.profile.forms import UpdateUserDataForm, UpdatePhoneNumberForm, UpdateEmailForm

UserModel = get_user_model()


def get_default_user_data():
    return {
        "email": "test1@test.test",
        "username": "Test User",
        "phone": "+201005363987",
        "password1": "newTESTPasswordD",
        "password2": "newTESTPasswordD",
        "first_name": "Test",
        "last_name": "User",
        "gender": "male",
        "birthdate": now(),
    }


def check_required(cls, key):
    data = {**cls.DEFAULT_DATA}
    data.pop(key, None)
    instance = cls.Form(data=data)
    cls.assertFalse(instance.is_valid())
    cls.assertEquals(instance.errors.as_data()[key][0].code, 'required')


def check_unique(cls, key, value):
    data = {**cls.DEFAULT_DATA}
    data.update({key: value})
    instance = cls.Form(data=data)
    cls.assertFalse(instance.is_valid())
    cls.assertEquals(instance.errors.as_data()[key][0].code, 'unique')


class UpdateUserFormValidationTest(TestCase):
    def setUp(self):
        self.DEFAULT_DATA = get_default_user_data()
        self.Form = UpdateUserDataForm

    def test_user_form_is_valid(self):
        form = UpdateUserDataForm(data=self.DEFAULT_DATA)
        self.assertTrue(form.is_valid())


class UpdateEmailFormValidationTest(TestCase):
    def setUp(self):
        self.request = RequestFactory().get('/')
        self.user = UserFactory(email='test@test.test', password='secret')
        self.Form = UpdateEmailForm
        self.DEFAULT_DATA = {
            "new_email": 'new_test@test.test',
            "password": "secret",
        }

    def test_email_form(self):
        form = UpdateEmailForm(data=self.DEFAULT_DATA, user=self.user)
        self.assertTrue(form.is_valid())

    def test_email_from_throw_error_if_provides_incomplete_data(self):
        form = UpdateEmailForm(data={}, user=self.user)
        self.assertFalse(form.is_valid())

    def test_email_from_throw_error_if_email_is_email_is_already_exists(self):
        default_data = {
            "new_email": 'test@test.test',
            "password": "secret",
        }
        form = UpdateEmailForm(data=default_data, user=self.user)
        self.assertFalse(form.is_valid())


class UpdateEmailFormTestCase(TestCase):
    def setUp(self):
        self.request = RequestFactory()
        self.form = UpdateEmailForm()

    def test_it_extends_django_Form(self):
        self.assertIsInstance(UpdateEmailForm(), forms.Form)

    def test_it_has_new_email_field(self):
        self.assertIn('new_email', self.form.fields)

    def test_new_email_field_is_instance_of_email_field(self):
        self.assertIsInstance(self.form.fields['new_email'], forms.EmailField)

    def test_new_email_field_is_required(self):
        self.assertTrue(self.form.fields['new_email'].required)

    def test_new_email_field_label(self):
        self.assertEquals(self.form.fields['new_email'].label, _("New Email"))

    def test_it_has_password_field(self):
        self.assertIn('password', self.form.fields)

    def test_password_field_is_instance_of_char_field(self):
        self.assertIsInstance(self.form.fields['password'], forms.CharField)

    def test_password_has_label_Password(self):
        self.assertEquals(self.form.fields['password'].label, _("Password"))

    def test_password_field_not_striping_its_value(self):
        form = UpdateEmailForm()
        self.assertFalse(self.form.fields['password'].strip)

    def test_password_widget_is_instance_of_passwordInput(self):
        self.assertIsInstance(self.form.fields['password'].widget, forms.PasswordInput)


class UpdatePhoneFormTestCase(TestCase):
    def setUp(self):
        self.request = RequestFactory()
        self.form = UpdatePhoneNumberForm()

    def test_it_extends_django_Form(self):
        self.assertIsInstance(UpdatePhoneNumberForm(), forms.Form)

    def test_it_has_phone_field(self):
        self.assertIn('new_phone', self.form.fields)

    def test_phone_field_is_instance_of_char_field(self):
        self.assertIsInstance(self.form.fields['new_phone'], forms.CharField)

    def test_phone_field_is_required(self):
        self.assertTrue(self.form.fields['new_phone'].required)

    def test_it_has_password_field(self):
        self.assertIn('password', self.form.fields)

    def test_password_field_is_instance_of_char_field(self):
        self.assertIsInstance(self.form.fields['password'], forms.CharField)

    def test_password_has_label_Password(self):
        self.assertEquals(self.form.fields['password'].label, _("Your Password"))

    def test_password_field_not_striping_its_value(self):
        form = UpdateEmailForm()
        self.assertFalse(self.form.fields['password'].strip)

    def test_password_widget_is_instance_of_passwordInput(self):
        self.assertIsInstance(self.form.fields['password'].widget, forms.PasswordInput)


class UpdatePhoneFormValidationTest(TestCase):
    def setUp(self):
        self.request = RequestFactory().get('/')
        self.user = UserFactory(phone="+201005263988")
        self.DEFAULT_DATA = get_default_user_data()
        self.Form = UpdatePhoneNumberForm
        self.DEFAULT_DATA = {
            "new_phone": '+201005263977',
            "password": "secret",
        }

    def test_phone_form(self):
        form = UpdatePhoneNumberForm(data=self.DEFAULT_DATA, user=self.user)
        self.assertTrue(form.is_valid())

    def test_phone_from_throw_error_if_provides_incomplete_data(self):
        form = UpdatePhoneNumberForm(data={}, user=self.user)
        self.assertFalse(form.is_valid())

    def test_phone_from_throw_error_if_new_phone_already_exists(self):
        default_data = {
            "new_phone": '+201005263988',
            "password": "secret",
        }
        form = UpdatePhoneNumberForm(data=default_data, user=self.user)
        self.assertFalse(form.is_valid())
