from datetime import date

from django.contrib.contenttypes.fields import GenericRelation
from django.db import models
from django.test import TestCase
from django.utils.translation import gettext_lazy as _

from apps.quran.factories import NarrationFactory, BookFactory, PageFactory
from apps.quran.models import Page, Narration, Book, Part, ChapterModel


class PagesModelTestCase(TestCase):
    def test_page_model_is_instance_of_models_Models(self):
        self.assertTrue(issubclass(Page, models.Model))

    def test_if_field_id_in_Page_model(self):
        self.assertTrue(hasattr(Page, 'id'))

    def test_id_attribute_is_instance_of_big_auto_field(self):
        field = Page._meta.get_field('id')
        self.assertIsInstance(field, models.BigAutoField)

    def test_field_id_is_primary_key(self):
        field = Page._meta.get_field('id')
        self.assertTrue(field.primary_key)

    def test_if_field_image_in_Page_model(self):
        self.assertTrue(hasattr(Page, 'image'))

    def test_image_attribute_is_instance_of_image_field(self):
        field = Page._meta.get_field('image')
        self.assertIsInstance(field, models.ImageField)

    def test_image_field_null_is_true(self):
        field = Page._meta.get_field('image')
        self.assertTrue(field.null)

    def test_image_field_blank_is_true(self):
        field = Page._meta.get_field('image')
        self.assertTrue(field.blank)

    def test_image_field_will_upload_images_to_get_upload_to_function(self):
        field = Page._meta.get_field('image')
        self.assertEquals(field.upload_to, Page.get_upload_to)

    def test_if_field_page_number_in_Page_model(self):
        self.assertTrue(hasattr(Page, 'page_number'))

    def test_image_attribute_is_instance_of_positive_integer_field(self):
        field = Page._meta.get_field('page_number')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_page_number_verbose_field_value_is_page_number(self):
        field = Page._meta.get_field('page_number')
        self.assertEquals(field.verbose_name, _('Page_Number'))

    def test_if_field_sub_part_in_Page_model(self):
        self.assertTrue(hasattr(Page, 'sub_part'))

    def test_sub_part_attribute_is_instance_of_positive_integer_field(self):
        field = Page._meta.get_field('sub_part')
        self.assertIsInstance(field, models.PositiveIntegerField)

    def test_sub_part_verbose_field_value_is_sub_part(self):
        field = Page._meta.get_field('sub_part')
        self.assertEquals(field.verbose_name, _('Sub_Part'))

    def test_sub_part_field_null_is_true(self):
        field = Page._meta.get_field('sub_part')
        self.assertTrue(field.null)

    def test_sub_part_field_blank_is_true(self):
        field = Page._meta.get_field('sub_part')
        self.assertTrue(field.blank)

    def test_if_field_narration_in_Page_model(self):
        self.assertTrue(hasattr(Page, 'narrations'))

    def test_narration_attribute_is_instance_of_model_foreign_key(self):
        field = Page._meta.get_field('narrations')
        self.assertIsInstance(field, models.ForeignKey)

    def test_narration_attribute_model_has_relation_many_to_one(self):
        field = Page._meta.get_field('narrations')
        self.assertTrue(field.many_to_one)

    def test_narration_field_is_related_to_narration_model(self):
        field = Page._meta.get_field('narrations')
        self.assertEquals(field.remote_field.model, Narration)

    def test_narration_attribute_related_name_value(self):
        field = Page._meta.get_field('narrations')
        self.assertEquals(field.remote_field.related_name, "page_narration")

    def test_narration_attribute_on_delete_value(self):
        field = Page._meta.get_field('narrations')
        self.assertEquals(field.remote_field.on_delete, models.SET_NULL)

    def test_narration_field_null_is_true(self):
        field = Page._meta.get_field('narrations')
        self.assertTrue(field.null)

    def test_narration_field_blank_is_true(self):
        field = Page._meta.get_field('narrations')
        self.assertTrue(field.blank)

    def test_if_field_book_in_Page_model(self):
        self.assertTrue(hasattr(Page, 'book'))

    def test_book_attribute_is_instance_of_model_foreign_key(self):
        field = Page._meta.get_field('book')
        self.assertIsInstance(field, models.ForeignKey)

    def test_book_field_is_related_to_book_model(self):
        field = Page._meta.get_field('book')
        self.assertEquals(field.remote_field.model, Book)

    def test_book_attribute_model_value_has_relation_many_to_one(self):
        field = Page._meta.get_field('book')
        self.assertTrue(field.many_to_one)

    def test_book_attribute_related_name_value(self):
        field = Page._meta.get_field('book')
        self.assertEquals(field.remote_field.related_name, "book_page")

    def test_book_attribute_on_delete_value(self):
        field = Page._meta.get_field('book')
        self.assertEquals(field.remote_field.on_delete, models.CASCADE)

    def test_book_field_null_is_true(self):
        field = Page._meta.get_field('book')
        self.assertTrue(field.null)

    def test_book_field_blank_is_true(self):
        field = Page._meta.get_field('book')
        self.assertTrue(field.blank)

    def test_if_field_chapter_in_page_model(self):
        self.assertTrue(hasattr(Page, 'chapters'))

    def test_chapter_attribute_is_instance_of_model_foreign_key(self):
        field = Page._meta.get_field('chapters')
        self.assertIsInstance(field, GenericRelation)

    def test_chapter_field_is_related_to_chapter_model(self):
        field = Page._meta.get_field('chapters')
        self.assertEquals(field.related_model, ChapterModel)

    def test_if_field_part_in_Page_model(self):
        self.assertTrue(hasattr(Page, 'part'))

    def test_part_attribute_is_instance_of_model_foreign_key(self):
        field = Page._meta.get_field('part')
        self.assertIsInstance(field, models.ForeignKey)

    def test_part_field_is_related_to_part_model(self):
        field = Page._meta.get_field('part')
        self.assertEquals(field.remote_field.model, Part)

    def test_part_attribute_model_value_has_relation_many_to_one(self):
        field = Page._meta.get_field('part')
        self.assertTrue(field.many_to_one)

    def test_part_attribute_related_name_value(self):
        field = Page._meta.get_field('part')
        self.assertEquals(field.remote_field.related_name, "part_page")

    def test_part_attribute_on_delete_value(self):
        field = Page._meta.get_field('part')
        self.assertEquals(field.remote_field.on_delete, models.SET_NULL)

    def test_part_field_null_is_true(self):
        field = Page._meta.get_field('part')
        self.assertTrue(field.null)

    def test_part_field_blank_is_true(self):
        field = Page._meta.get_field('part')
        self.assertTrue(field.blank)

    def test_meta_verbose_name_is_page(self):
        self.assertEquals(Page._meta.verbose_name, _('Page'))

    def test_meta_verbose_name_plural_is_pages(self):
        self.assertEquals(Page._meta.verbose_name_plural, _('Pages'))

    def test_meta_order_field_is_page_number(self):
        self.assertEquals(Page._meta.ordering, ('book_id', 'page_number',))

    def test_page_model_has__str__attribute(self):
        self.assertTrue(hasattr(Page, '__str__'))

    def test__str__is_callable(self):
        self.assertTrue(callable(getattr(Page, '__str__')))

    def test__str__returns_field_if_available(self):
        page = Page.objects.create(page_number="1")
        self.assertEqual('1', str(page))

    def test_page_model_has_get_upload_to_attribute(self):
        self.assertTrue(hasattr(Page, 'get_upload_to'))

    def test_get_upload_to_is_callable(self):
        self.assertTrue(callable(getattr(Page, 'get_upload_to')))

    def test_get_upload_to_function_verse_model_will_create_file_with_data(self):
        page = PageFactory(
            page_number=1,
            sub_part=3,
            book=BookFactory(narration=NarrationFactory()))
        model_upload_function = Page.get_upload_to(page, "test")
        self.assertEquals(model_upload_function, 'pages/1/{}-test'.format(date.today().strftime("/%Y/%d/%m/")))
