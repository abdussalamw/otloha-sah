from django import forms
from django.test import TestCase
from django.utils.translation import gettext_lazy as _
from translation.forms import TranslatableModelForm

from apps.narrations.factories import NarrationFactory
from apps.recitations.factories import ReciterFactory
from apps.recitations.forms import RecitationForm


class RecitationFormTestCase(TestCase):
    def setUp(self):
        self.form = RecitationForm()

    def test_it_extends_django_Form(self):
        self.assertTrue(issubclass(RecitationForm, TranslatableModelForm))

    # Test Name

    def test_name_exists_in_form_fields(self):
        self.assertIn('name', self.form.fields)

    def test_name_field_is_instance_of_char_field(self):
        self.assertIsInstance(self.form.fields['name'], forms.CharField)

    def test_name_widget_is_instance_of_forms_select(self):
        self.assertIsInstance(self.form.fields['name'].widget, forms.TextInput)

    # todo:solve the error
    def test_name_has_label_Name(self):
        self.assertEqual(self.form.fields['name'].label, _('Name'))

    def test_name_field_is_required(self):
        self.assertTrue(self.form.fields['name'].required)

    # Test Narration

    def test_narration_exists_in_form_fields(self):
        self.assertIn('narration', self.form.fields)

    def test_narration_field_is_instance_of_choice_field(self):
        self.assertIsInstance(self.form.fields['narration'], forms.ModelChoiceField)

    def test_narration_widget_is_instance_of_forms_select(self):
        self.assertIsInstance(self.form.fields['narration'].widget, forms.Select)

    def test_narration_has_label_Narration(self):
        self.assertEqual(self.form.fields['narration'].label, _("Narration"))

    def test_narration_field_is_not_required(self):
        self.assertFalse(self.form.fields['narration'].required)

    # Test Reciter

    def test_reciter_exists_in_form_fields(self):
        self.assertIn('reciter', self.form.fields)

    def test_reciter_field_is_instance_of_choice_field(self):
        self.assertIsInstance(self.form.fields['reciter'], forms.ModelChoiceField)

    def test_reciter_widget_is_instance_of_forms_select(self):
        self.assertIsInstance(self.form.fields['reciter'].widget, forms.Select)

    def test_reciter_has_label_Reciter(self):
        self.assertEqual(self.form.fields['reciter'].label, _("Reciter"))

    def test_reciter_field_is_required(self):
        self.assertTrue(self.form.fields['reciter'].required)


class RecitationFormValidationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'name': 'Bokhari Tajweed Recitation',
            'narrations': NarrationFactory(),
            'reciter': ReciterFactory(),
        }

    def test_it_throws_error_if_name_has_no_value(self):
        self.data.pop('name')
        form = RecitationForm(data=self.data)
        self.assertFalse(form.is_valid())

    def test_error_code_is_required_if_name_has_no_value(self):
        self.data.pop('name')
        form = RecitationForm(data=self.data)
        self.assertEqual(form.errors.as_data()['name'][0].code, 'required')

    def test_error_message_is_required_if_name_has_no_value(self):
        self.data.pop('name')
        form = RecitationForm(data=self.data)
        self.assertEqual(form.errors.as_data()['name'][0].message, _('This field is required.'))

    def test_it_throws_error_if_reciter_has_no_value(self):
        self.data.pop('reciter')
        form = RecitationForm(data=self.data)
        self.assertFalse(form.is_valid())

    def test_error_code_is_required_if_reciter_has_no_value(self):
        self.data.pop('reciter')
        form = RecitationForm(data=self.data)
        self.assertEqual(form.errors.as_data()['reciter'][0].code, 'required')

    def test_error_message_is_required_if_reciter_has_no_value(self):
        self.data.pop('reciter')
        form = RecitationForm(data=self.data)
        self.assertEqual(form.errors.as_data()['reciter'][0].message, _('This field is required.'))

