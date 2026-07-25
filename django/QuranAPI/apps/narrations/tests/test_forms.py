from django import forms
from django.test import TestCase
from django.utils.translation import gettext as _
from translation.forms import TranslatableModelForm

from apps.narrations.forms import NarrationForm
from apps.narrations.models import Narration


class NarrationFormsTestCase(TestCase):
    def test_it_extends_translatable_model_form(self):
        self.assertTrue(issubclass(NarrationForm, TranslatableModelForm))

    # Test Meta
    def test_it_has_meta(self):
        self.assertTrue(hasattr(NarrationForm, '_meta'))

    def test_meta_has_model(self):
        self.assertTrue(hasattr(NarrationForm._meta, 'model'))

    def test_meta_model_is_narration(self):
        self.assertEqual(NarrationForm._meta.model, Narration)

    def test_meta_has_fields(self):
        self.assertTrue(hasattr(NarrationForm._meta, 'fields'))

    def test_meta_fields_has_name(self):
        self.assertIn('name', NarrationForm._meta.fields)

    def test_name_field_is_instance_of_char_field(self):
        form = NarrationForm({'name': 'narrationName', 'description': 'narrartionDescription'})
        self.assertTrue(isinstance(form.fields['name'], forms.CharField))

    def test_meta_fields_has_description(self):
        self.assertIn('description', NarrationForm._meta.fields)

    def test_description_field_is_instance_of_char_field(self):
        form = NarrationForm({'name': 'narrationName', 'description': 'narrartionDescription'})
        self.assertTrue(isinstance(form.fields['description'], forms.CharField))


class NarrationFormValidationTestCase(TestCase):
    def setUp(self):
        self.data = {
            'name': 'narrationName',
            'description': 'narrationDescription'
        }

    # Test name field
    def test_form_is_not_valid_with_no_name(self):
        self.data.pop('name')
        form = NarrationForm(data=self.data)
        self.assertFalse(form.is_valid())

    def test_it_raise_name_field_is_required_if_name_is_missed(self):
        self.data.pop('name')
        form = NarrationForm(data=self.data)
        form.is_valid()
        self.assertEqual(form.errors.as_data()['name'][0].code, 'required')

    def test_it_raise_error_if_name_field_is_required(self):
        self.data.pop('name')
        form = NarrationForm(data=self.data)
        form.is_valid()
        self.assertEqual(form.errors['name'][0], _("This field is required."))

    # Test description field
    def test_form_is_not_valid_with_no_description(self):
        self.data.pop('description')
        form = NarrationForm(data=self.data)
        self.assertFalse(form.is_valid())

    def test_it_raise_description_field_is_required_if_description_is_missed(self):
        self.data.pop('description')
        form = NarrationForm(data=self.data)
        form.is_valid()
        self.assertEqual(form.errors.as_data()['description'][0].code, 'required')

    def test_it_raise_error_if_description_field_is_required(self):
        self.data.pop('description')
        form = NarrationForm(data=self.data)
        form.is_valid()
        self.assertEqual(form.errors['description'][0], _("This field is required."))

    # Test html representation
    def test_it_render_name_field_in_html(self):
        form = NarrationForm()
        self.assertIn('name="name"', form.as_p())

    def test_it_render_description_field_in_html(self):
        form = NarrationForm()
        self.assertIn('name="description"', form.as_p())

    def test_it_pass_the_instance_value_to_html_of_field_name(self):
        form = NarrationForm(self.data)
        self.assertIn('value="{}"'.format(self.data['name']), form.as_p())

    def test_it_pass_the_instance_value_to_html_of_field_description(self):
        form = NarrationForm(self.data)
        self.assertIn(self.data['description'], form.as_p())
