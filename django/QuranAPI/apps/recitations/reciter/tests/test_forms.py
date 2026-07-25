from django.test import TestCase
from django.utils.translation import gettext as _
from translation.forms import TranslatableModelForm

from apps.recitations.models import Reciter
from apps.recitations.reciter.forms import ReciterForm


class ReciterFormStructureTestCase(TestCase):
    def setUp(self):
        self.form = ReciterForm()

    def test_it_extends_django_Form(self):
        self.assertIsInstance(ReciterForm(), TranslatableModelForm)

    def test_serializer_class_has_meta_class_on_it(self):
        self.assertIn('Meta', ReciterForm.__dict__)

    def test_the_model_used_in_the_meta_is_Reciter_Model(self):
        self.assertEquals(Reciter, ReciterForm.Meta.model)

    def test_name_exists_in_serializer_fields(self):
        self.assertIn('name', ReciterForm.Meta.fields)


class ReciterFormValidationTest(TestCase):
    def setUp(self):
        self.data = {'name': "test"}

    def test_reciter_form(self):
        form = ReciterForm(data=self.data)
        self.assertTrue(form.is_valid())

    def test_it_throws_error_if_name_is_not_provided(self):
        self.data.pop('name')
        form = ReciterForm(data=self.data)
        self.assertFalse(form.is_valid())

    def test_error_code_is_required_if_name_has_no_value(self):
        self.data.pop('name')
        form = ReciterForm(data=self.data)
        self.assertEquals(form.errors.as_data()['name'][0].code, 'required')

    def test_error_message_is_required_if_name_has_no_value(self):
        self.data.pop('name')
        form = ReciterForm(data=self.data)
        self.assertEquals(form.errors.as_data()['name'][0].message, _('This field is required.'))
