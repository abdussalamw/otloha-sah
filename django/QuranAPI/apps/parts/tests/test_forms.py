from django import forms
from django.test import TestCase
from django.utils.translation import gettext as _
from translation.forms import TranslatableModelForm

from apps.parts.forms import PartForm
from apps.parts.models import Part


class PartFormTest(TestCase):
    def test_it_extend_TranslatableModelForm(self):
        self.assertIsInstance(PartForm(), TranslatableModelForm)

    # Test Meta class
    def test_it_has_meta_class(self):
        self.assertIn('Meta', PartForm.__dict__)

    def test_it_use_part_model(self):
        self.assertEqual(PartForm._meta.model, Part)

    # Test Meta Name field
    def test_meta_fields_has_name(self):
        self.assertIn('name', PartForm._meta.fields)

    def test_name_field_is_instance_of_char_field(self):
        form = PartForm(data={'name': 'name', 'alias': 'alias', 'part_number': 1})
        self.assertTrue(form.is_valid())
        self.assertTrue(isinstance(form.fields['name'], forms.CharField))

    # Test Meta Alias field
    def test_meta_fields_has_alias(self):
        self.assertIn('alias', PartForm._meta.fields)

    def test_alias_field_is_instance_of_char_field(self):
        form = PartForm(data={'name': 'name', 'alias': 'alias', 'part_number': 1})
        self.assertTrue(isinstance(form.fields['alias'], forms.CharField))

    # Test Meta Part_number field
    def test_meta_fields_has_part_number(self):
        self.assertIn('part_number', PartForm._meta.fields)

    def test_part_number_field_is_instance_of_integer_field(self):
        form = PartForm(data={'name': 'name', 'alias': 'alias', 'part_number': 1})
        self.assertTrue(isinstance(form.fields['part_number'], forms.IntegerField))


class PartFormValidationTest(TestCase):
    def setUp(self):
        self.data = {
            'name': 'narrationName',
            'alias': "partAlias",
            'part_number': 1,
        }

    # Test name field
    def test_form_is_not_valid_with_no_name(self):
        self.data.pop('name')
        form = PartForm(data=self.data)
        self.assertFalse(form.is_valid())

    def test_it_raise_name_field_is_required_if_name_is_missed(self):
        self.data.pop('name')
        form = PartForm(data=self.data)
        self.assertEqual(form.errors.as_data()['name'][0].code, 'required')

    def test_it_raise_error_if_name_field_is_required(self):
        self.data.pop('name')
        form = PartForm(data=self.data)
        self.assertEqual(form.errors['name'][0], _("This field is required."))

    # Test alias field
    def test_form_is_not_valid_with_no_alias(self):
        self.data.pop('alias')
        form = PartForm(data=self.data)
        self.assertFalse(form.is_valid())

    def test_alias_field_is_required(self):
        self.data.pop('alias')
        form = PartForm(data=self.data)
        self.assertEqual(form.errors.as_data()['alias'][0].code, 'required')

    def test_it_raise_error_if_alias_field_is_required(self):
        self.data.pop('alias')
        form = PartForm(data=self.data)
        self.assertEqual(form.errors.as_data()['alias'][0].message, _("This field is required."))

    # Test part_number field
    def test_form_is_not_valid_with_no_part_number(self):
        self.data.pop('part_number')
        form = PartForm(data=self.data)
        self.assertFalse(form.is_valid())

    def test_part_number_field_is_required(self):
        self.data.pop('part_number')
        form = PartForm(data=self.data)
        self.assertEqual(form.errors.as_data()['part_number'][0].code, 'required')

    def test_it_raise_error_if_part_number_field_is_required(self):
        self.data.pop('part_number')
        form = PartForm(data=self.data)
        self.assertEqual(form.errors.as_data()['part_number'][0].message, _("This field is required."))

    def test_it_render_name_field_in_html(self):
        form = PartForm()
        self.assertIn('name="name"', form.as_p())

    def test_it_render_alias_field_in_html(self):
        form = PartForm()
        self.assertIn('name="alias"', form.as_p())

    def test_it_render_part_number_field_in_html(self):
        form = PartForm()
        self.assertIn('name="part_number"', form.as_p())

    def test_it_pass_the_instance_value_to_html_of_field_alias(self):
        form = PartForm(self.data)
        self.assertIn('value="{}"'.format(self.data['alias']), form.as_p())

    def test_it_pass_the_instance_value_to_html_of_field_part_number(self):
        form = PartForm(self.data)
        self.assertIn('value="{}"'.format(self.data['part_number']), form.as_p())
