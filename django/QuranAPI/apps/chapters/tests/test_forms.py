from django.test import TestCase
from django.utils.translation import gettext as _
from translation.forms import TranslatableModelForm

from apps.chapters.forms import ChapterForm
from apps.chapters.models import Chapter


class ChapterFormTest(TestCase):

    def test_it_extend_TranslatableModelForm(self):
        self.assertIsInstance(ChapterForm(), TranslatableModelForm)

    def test_it_has_meta_class(self):
        self.assertIn('Meta', ChapterForm.__dict__)

    def test_meta_has_model(self):
        self.assertTrue(hasattr(ChapterForm._meta, 'model'))

    def test_it_use_chapter_model(self):
        self.assertEquals(ChapterForm._meta.model, Chapter)

    def test_meta_has_fields(self):
        self.assertTrue(hasattr(ChapterForm._meta, 'fields'))
    
    def test_meta_fields_has_name(self):
        self.assertIn('name', ChapterForm._meta.fields)
    
    def test_meta_fields_has_origin(self):
        self.assertIn('origin', ChapterForm._meta.fields)

    def test_meta_fields_has_chapter_number(self):
        self.assertIn('chapter_number', ChapterForm._meta.fields)

    def test_name_field_is_required(self):
        form = ChapterForm(data={'name': '', 'chapter_number': 5, 'origin': 'in El Madina'})
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['name'][0].code, 'required')

    def test_it_raise_error_message_for_name_field(self):
        form = ChapterForm(data={'name': '', 'chapter_number': 5, 'origin': 'in El Madina'})
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors['name'][0], _('This field is required.'))

    def test_chapter_number_field_is_required(self):
        form = ChapterForm(
            data={'name': 'chapterName', 'origin': 'in El Madina'})
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['chapter_number'][0].code, 'required')   

    def test_it_raise_error_message_for_chapter_number_field(self):
        form = ChapterForm(
            data={'name': 'chapterName', 'origin': 'in El Madina'})
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors['chapter_number'][0], _('This field is required.'))

    def test_origin_field_is_required(self):
        form = ChapterForm(data={'name': 'chapterName', 'chapter_number': 5})
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors.as_data()['origin'][0].code, 'required')

    def test_it_raise_error_message_for_origin_field(self):
        form = ChapterForm(data={'name': 'chapterName', 'chapter_number': 5})
        self.assertFalse(form.is_valid())
        self.assertEquals(form.errors['origin'][0], _('This field is required.'))



class ChapterFormValidationTest(TestCase):
    def setUp(self):
        self.data={
            'name': 'chapterName',
            'chapter_number': 5,
            'origin': 'in El Madina',
        }


    def test_if_chapter_form_validates_name_field(self):
        self.data.pop('name')
        form = ChapterForm(data=self.data)
        self.assertFalse(form.is_valid())

    def test_it_raise_name_field_is_required_if_name_is_missed(self):
        self.data.pop('name')
        form = ChapterForm(data=self.data)
        form.is_valid()
        self.assertEqual(form.errors.as_data()['name'][0].code, 'required')
    
    def test_it_raise_error_if_name_field_is_required(self):
        self.data.pop('name')
        form = ChapterForm(data=self.data)
        form.is_valid()
        self.assertEqual(form.errors['name'][0], _("This field is required."))

    def test_if_chapter_form_validates_origin_field(self):
        self.data.pop('origin')
        form = ChapterForm(data=self.data)
        self.assertFalse(form.is_valid())

    def test_it_raise_origin_field_is_required_if_origin_is_missed(self):
        self.data.pop('origin')
        form = ChapterForm(data=self.data)
        form.is_valid()
        self.assertEqual(form.errors.as_data()['origin'][0].code, 'required')
    
    def test_it_raise_error_if_origin_field_is_required(self):
        self.data.pop('origin')
        form = ChapterForm(data=self.data)
        form.is_valid()
        self.assertEqual(form.errors['origin'][0], _("This field is required."))

    def test_if_chapter_form_validates_chapter_number_field(self):
        self.data.pop('chapter_number')
        form = ChapterForm(data=self.data)
        self.assertFalse(form.is_valid())

    def test_it_raise_chapter_number_field_is_required_if_origin_is_missed(self):
        self.data.pop('chapter_number')
        form = ChapterForm(data=self.data)
        form.is_valid()
        self.assertEqual(form.errors.as_data()['chapter_number'][0].code, 'required')
    
    def test_it_raise_error_if_chapter_number_field_is_required(self):
        self.data.pop('chapter_number')
        form = ChapterForm(data=self.data)
        form.is_valid()
        self.assertEqual(form.errors['chapter_number'][0], _("This field is required."))

    def test_if_chapter_form_render_html_field_with_name_name(self):
        form = ChapterForm()
        self.assertIn('name="name"', form.as_p())
    
    def test_it_pass_the_instance_value_to_html_of_field_name(self):
        form = ChapterForm(self.data)
        self.assertIn('value="{}"'.format(self.data['name']), form.as_p())

    def test_if_chapter_form_render_html_field_with_name_origin(self):
        form = ChapterForm()
        self.assertIn('name="origin"', form.as_p())
    
    def test_it_pass_the_instance_value_to_html_of_field_origin(self):
        form = ChapterForm(self.data)
        self.assertIn(self.data['origin'], form.as_p())

    def test_if_chapter_form_render_html_field_with_name_chapter_number(self):
        form = ChapterForm()
        self.assertIn('name="chapter_number"', form.as_p())
    
    def test_it_pass_the_instance_value_to_html_of_field_chapter_number(self):
        form = ChapterForm(self.data)
        self.assertIn('value="{}"'.format(self.data['chapter_number']), form.as_p())



